import 'package:buy_and_sell_used_stuff_mobile_application/model/phone_model.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/price_text_format.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product_click_event.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/product_details_page/product_details_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/connectivity_service.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/big_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final ConnectivityService _connectivityService = ConnectivityService();
  late String userId;
  List<Product> products = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';

    _connectivityService.onConnectivityChanged
        .listen((ConnectivityResult result) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (products.isEmpty && mounted) {
      FirebaseFirestore.instance
          .collection('products')
          .orderBy('uploadDate', descending: true)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty && mounted) {
          setState(() {
            products =
                snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: avgDimension(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      right: avgDimension(20),
                    ),
                    child: const TitleText(
                      text: 'تمام محصولات',
                      color: AppColors.mainColor,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            // height: avgDimension(200),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(top: avgDimension(10)),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              reverse: true,
              itemBuilder: (context, index) {
                return buildListView(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView(int index) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('products')
          .orderBy('uploadDate', descending: false)
          .snapshots(),
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

        return GestureDetector(
          onTap: () {

            print('Id: ${documents[index].id}');
          print('Id: ${snapshot.data!.docs[index].id}');

            ClickEvent(
              documentId: documents[index].id,
            ).onProductClick();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                ProductDetailsScreen(snapshot.data!.docs[index].id),
              ),
            );
          },
          child: ProductListItem(
            imageUrl: imageUrl,
            title: imageTitle,
            description: descriptionText,
            product: Product.fromFirestore(snapshot.data!.docs[index]),
            userId: userId,
            documentId: snapshot.data!.docs[index].id,
            placeholderColor: AppColors.placeholderColors[index],
          ),
        );
      },
    );
  }
}

class ProductListItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Product product;
  final String userId;
  final String documentId;
  final Color placeholderColor;
  ProductListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.product,
    required this.userId,
    required this.documentId,
    required this.placeholderColor,
  });

  final FirebaseFirestore _db = FirebaseFirestore.instance;
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
      favoriteRef.set(
        {
          'productId': product.id,
          'documentId': documentId,
        },
      );
    }
  }

  // void addFavoriteProduct(String userId, String productId) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('favorites')
  //       .doc(productId)
  //       .set(
  //     {
  //       'contentId': productId,
  //     },
  //   );
  // }

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
            icon: const Icon(
              Icons.favorite,
              color: AppColors.favoriteIconColor,
              size: 25,
            ),
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
    return Column(
      children: [
        SizedBox(
          height: avgDimension(5),
        ),
        SizedBox(
          width: double.maxFinite,
          child: Card(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBackgroundColor
                : AppColors.lightBackgroundColor,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: placeholderColor,
                      width: double.infinity,
                      height: 100,
                    ),
                    Visibility(
                      visible: imageUrl.isNotEmpty,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                // CachedNetworkImage(
                //   // height: avgDimension(250),
                //   imageUrl: product.images.first,
                //   fit: BoxFit.cover,
                // ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 20,
                    right: 10,
                    left: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.titleDarkThemeColor
                              : AppColors.titleLightThemeColor,
                          fontSize: avgDimension(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceTextFormat(product: product),
                          favoriteButton
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              "آدرس: " + product.address!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: avgDimension(18),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.addressAndPhoneDarkThemeColor
                                    : AppColors.addressAndPhoneLightThemeColor,
                              ),
                            ),
                          ),
                          phoneGestureDetector(product, context),
                          SizedBox(
                            height: avgDimension(10),
                          ),
                          Center(
                            child: SizedBox(
                              width: avgDimension(300),
                              child: Divider(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.dividerDarkThemeColor
                                    : AppColors.dividerLightThemeColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: avgDimension(10),
                          ),
                          Text(
                            product.description,
                            style: const TextStyle(
                              color: AppColors.smallTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: avgDimension(5),
        ),
      ],
    );
  }
}
