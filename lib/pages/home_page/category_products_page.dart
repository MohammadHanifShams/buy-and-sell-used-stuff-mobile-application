import 'dart:async';
import 'package:buy_and_sell_used_stuff_mobile_application/model/phone_model.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/price_text_format.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product_click_event.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/connectivity_service.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProductsPage extends StatefulWidget {
  final String category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  StreamSubscription<QuerySnapshot>? _productStream;
  bool isDisposed = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  late String userId;
  List<Product> products = [];
  final ScrollController _scrollController = ScrollController();

  Future<String> getDocumentIdByProductId(String productId) async {
    String documentId = '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: productId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      documentId = querySnapshot.docs.first.id;
    }

    return documentId;
  }

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';

    _connectivityService.onConnectivityChanged
        .listen((ConnectivityResult result) {});
  }

  @override
  void dispose() {
    isDisposed = true;
    _productStream?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isDisposed) {
      _productStream = FirebaseFirestore.instance
          .collection('products')
          .where('categories', arrayContains: widget.category)
          .snapshots()
          .listen((snapshot) {
        if (!isDisposed) {
          setState(() {
            products =
                snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: avgDimension(10),
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () async {
              String productId = product.id;
              String documentId = await getDocumentIdByProductId(productId);
              ClickEvent(
                documentId: documentId,
              ).onProductClick();
            },
            child: ProductListItem(
              product: product,
              userId: userId,
              toggleFavorite: () async {
                DocumentReference favoriteRef = FirebaseFirestore.instance
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
                      'imageUrl':
                          product.images.isNotEmpty ? product.images.first : '',
                      'title': product.title,
                      'description': product.description,
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;
  final String userId;
  final VoidCallback toggleFavorite;
  const ProductListItem({
    super.key,
    required this.product,
    required this.userId,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: product.images.first,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: Text(
                    product.title,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.titleDarkThemeColor
                          : AppColors.titleLightThemeColor,
                      fontSize: avgDimension(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceTextFormat(product: product),
                          IconButton(
                            icon: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection('favorites')
                                  .doc(product.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  return const Icon(
                                    Icons.favorite,
                                    color: AppColors.favoriteIconColor,
                                    size: 25,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.favorite_border,
                                    color: AppColors.favoriteIconColor,
                                  );
                                }
                              },
                            ),
                            onPressed: toggleFavorite,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "آدرس: ${product.address!}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: avgDimension(18),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.addressAndPhoneDarkThemeColor
                                  : AppColors.addressAndPhoneLightThemeColor,
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
