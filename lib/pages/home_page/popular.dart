import 'package:buy_and_sell_used_stuff_mobile_application/model/price_text_format.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product_click_event.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/product_details_page/product_details_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/connectivity_service.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/big_text.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/small_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  final ConnectivityService _connectivityService = ConnectivityService();
  late String userId;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';
    _connectivityService.onConnectivityChanged
        .listen((ConnectivityResult result) {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: avgDimension(10),
            right: avgDimension(20),
          ),
          child: const TitleText(
            text: 'محصولات پرطرفدار',
            color: AppColors.mainColor,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: avgDimension(10),
          ),
          child: FutureBuilder(
            future: fetchPopularProducts(),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data');
              } else {
                List<DocumentSnapshot> popularProducts = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: avgDimension(5),
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: popularProducts.length,
                  itemBuilder: (context, index) {
                    return buildProductItem(popularProducts[index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<DocumentSnapshot>> fetchPopularProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('clickCount', descending: true)
        .limit(5)
        .get();
    return querySnapshot.docs;
  }

  Widget buildProductItem(DocumentSnapshot document) {
    List<dynamic> imageList = document.get('images');
    String imageUrl = imageList.isNotEmpty ? imageList.first : '';
    String imageTitle = document.get('title');
    String descriptionText = document.get('description');
    return GestureDetector(
      onTap: () {
        ClickEvent(
          documentId: document.id,
        ).onProductClick();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(document.id),
          ),
        );
      },
      child: ProductListItem(
        imageUrl: imageUrl,
        title: imageTitle,
        description: descriptionText,
        product: Product.fromFirestore(document),
        userId: userId,
        documentId: document.id,
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  ProductListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.product,
    required this.userId,
    required this.documentId,
  });

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
    return Container(
      height: avgDimension(120),
      margin: EdgeInsets.only(
        left: avgDimension(20),
        right: avgDimension(20),
        top: avgDimension(10),
        bottom: avgDimension(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(avgDimension(55)),
          bottomRight: Radius.circular(avgDimension(55)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // تصویر
          Stack(
            children: [
              Container(
                height: avgDimension(99),
                width: avgDimension(99),
                margin: EdgeInsets.all(
                  avgDimension(10),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      product.images.first,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                left: -5,
                child: favoriteButton,
              ),
            ],
          ),
          // متن
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                right: avgDimension(10),
                top: avgDimension(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleText(
                    text: product.title,
                    fontSize: avgDimension(16),
                  ),
                  PriceTextFormat(product: product),
                  Container(
                    margin: EdgeInsets.only(
                      left: avgDimension(10),
                    ),
                    child: SmallText(
                      text: product.description,
                      fontSize: avgDimension(12),
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
