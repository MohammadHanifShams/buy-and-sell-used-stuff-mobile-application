import 'package:buy_and_sell_used_stuff_mobile_application/model/price_text_format.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product_click_event.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/home_page/all_products.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/home_page/popular.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/product_details_page/product_details_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/connectivity_service.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/big_text.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/small_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'categories.dart';
import 'ads_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(viewportFraction: 0.90);
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = avgDimension(220);
  final ConnectivityService _connectivityService = ConnectivityService();

  late String userId;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
    _connectivityService.onConnectivityChanged
        .listen((ConnectivityResult result) {});
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: avgDimension(50),
                bottom: avgDimension(15),
                right: avgDimension(20),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          right: avgDimension(10),
                        ),
                        child: TitleText(
                          text: "پیشنهاد ها",
                          fontSize: avgDimension(24),
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //کنترولر پیشنهاد ها
            SizedBox(
              height: avgDimension(260),
              child: PageView.builder(
                controller: pageController,
                itemCount: 5,
                itemBuilder: (context, position) {
                  return _buildSuggestionsItems(position);
                },
              ),
            ),

            DotsIndicator(
              dotsCount: 5,
              position: _currPageValue,
              decorator: DotsDecorator(
                activeColor: AppColors.mainColor,
                size: Size.square(avgDimension(9)),
                activeSize: Size(
                  avgDimension(18),
                  avgDimension(9),
                ),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    radius(
                      avgDimension(5),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: avgDimension(5),
            ),

            Categories(),
            const Popular(),
            const AdsView(),
            const AllProducts(),

            SizedBox(
              height: avgDimension(90),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsItems(int index) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        if (index >= documents.length) {
          return const Text('No data');
        }

        List<dynamic> imageList = documents[index].get('images');
        String imageUrl = imageList.isNotEmpty ? imageList.first : '';
        String imageTitle = documents[index].get('title');
        String descriptionText = documents[index].get('description');

        // TODO: bray scale dadn rast wa chap active view hast.
        Matrix4 matrix = Matrix4.identity();
        if (index == _currPageValue.floor()) {
          var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
          var currTrans = _height * (1 - currScale) / 2;
          matrix = Matrix4.diagonal3Values(1, currScale, 1)
            ..setTranslationRaw(0, currTrans, 0);
        } else if (index == _currPageValue.floor() + 1) {
          var currScale =
              _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
          var currTrans = _height * (1 - currScale) / 2;
          matrix = Matrix4.diagonal3Values(1, currScale, 1);
          matrix = Matrix4.diagonal3Values(1, currScale, 1)
            ..setTranslationRaw(0, currTrans, 0);
        } else if (index == _currPageValue.floor() - 1) {
          var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
          var currTrans = _height * (1 - currScale) / 2;
          matrix = Matrix4.diagonal3Values(1, currScale, 1);
          matrix = Matrix4.diagonal3Values(1, currScale, 1)
            ..setTranslationRaw(0, currTrans, 0);
        } else {
          var currScale = 0.8;
          matrix = Matrix4.diagonal3Values(1, currScale, 1)
            ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
        }

        return GestureDetector(
          onTap: () {
            ClickEvent(
              documentId: snapshot.data!.docs[index].id,
            ).onProductClick();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsScreen(snapshot.data!.docs[index].id),
              ),
            );
          },
          child: ProductListItem(
            matrix: matrix,
            imageUrl: imageUrl,
            title: imageTitle,
            description: descriptionText,
            product: Product.fromFirestore(snapshot.data!.docs[index]),
            userId: userId,
            documentId: snapshot.data!.docs[index].id,
          ),
        );
      },
    );
  }
}

class ProductListItem extends StatelessWidget {
  ProductListItem({
    super.key,
    required this.matrix,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.product,
    required this.userId,
    required this.documentId,
  });

  final Matrix4 matrix;
  final String imageUrl;
  final String title;
  final String description;
  final Product product;
  final String documentId;


  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  void _toggleFavorite() async {
    DocumentReference favoriteRef = _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id);

    final doc = await favoriteRef.get();

    if (doc.exists) {
      favoriteRef.delete();
    } else {
      favoriteRef.set({
        'productId': product.id,
        'documentId': documentId,
      });
    }
  }

  void addFavoriteProduct(String userId, String productId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .set({
      'contentId': productId,
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget favoriteButton = StreamBuilder<DocumentSnapshot>(
      stream: _db
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(product.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          return IconButton(
            icon:
                const Icon(Icons.favorite, color: AppColors.favoriteIconColor),
            onPressed: _toggleFavorite,
          );
        } else {
          return IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: AppColors.favoriteIconColor,
            ),
            onPressed: _toggleFavorite,
          );
        }
      },
    );
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: avgDimension(190),
            margin: EdgeInsets.only(
              left: avgDimension(10),
              right: avgDimension(10),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                radius(
                  avgDimension(30),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.boxShadowDarkColor.withOpacity(0.3),
                  blurRadius: avgDimension(5),
                  offset: Offset(
                    avgDimension(0),
                    avgDimension(5),
                  ),
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(product.images.first),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: avgDimension(125),
              margin: EdgeInsets.only(
                left: avgDimension(25),
                right: avgDimension(25),
                bottom: avgDimension(15),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    radius(
                      avgDimension(20),
                    ),
                  ),
                  color: Color(0xF9F6EEEE).withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.boxShadowDarkColor.withOpacity(0.1),
                      blurRadius: avgDimension(5),
                      offset: Offset(
                        avgDimension(0),
                        avgDimension(5),
                      ),
                    ),
                    BoxShadow(
                      color: AppColors.boxShadowDarkColor.withOpacity(0.1),
                      blurRadius: avgDimension(5),
                      offset: Offset(
                        avgDimension(3),
                        avgDimension(0),
                      ),
                    ),
                    BoxShadow(
                      color: AppColors.boxShadowDarkColor.withOpacity(0.1),
                      blurRadius: avgDimension(5),
                      offset: Offset(
                        avgDimension(-3),
                        avgDimension(0),
                      ),
                    ),
                  ],
    ),
              child: Container(
                padding: EdgeInsets.only(
                  top: avgDimension(5),
                  left: avgDimension(15),
                  right: avgDimension(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: avgDimension(5),
                      ),
                      child: TitleText(
                        text: product.title,
                        fontSize: avgDimension(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: avgDimension(5),
                    ),
                    SizedBox(
                      height: avgDimension(30),
                      child: SmallText(
                        text: product.description,
                      ),
                    ),
                    SizedBox(
                      height: avgDimension(5),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: avgDimension(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceTextFormat(product: product),
                          GestureDetector(
                            child: favoriteButton,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
