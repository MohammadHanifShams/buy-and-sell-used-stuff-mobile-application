import 'package:buy_and_sell_used_stuff_mobile_application/model/phone_model.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/price_text_format.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoriteListPage extends StatelessWidget {
  final String userId;

  const FavoriteListPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: avgDimension(70),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'لیست علاقه‌مندی‌ها',
            style: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('لیست علاقه‌مندی‌ها خالی است'),
              );
            }
            return MasonryGridView.builder(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final favoriteDoc = snapshot.data!.docs[index];
                final String productId = favoriteDoc['documentId'];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(productId)
                      .get(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        !productSnapshot.hasData ||
                        productSnapshot.data!.data() == null) {
                      return Container(
                        height: 100,
                      );
                    } else {
                      final productData =
                          productSnapshot.data!.data()! as Map<String, dynamic>;
                      String productName = productData['title'];
                      String productDescription = productData['description'];
                      List<dynamic> imageList = productData['images'];
                      String imageUrl =
                          imageList.isNotEmpty ? imageList.first : '';
                      return ProductTile(
                        imageUrl: imageUrl,
                        productName: productName,
                        productDescription: productDescription,
                        product: Product.fromFirestore( productSnapshot.data! ),
                        placeholderColor: AppColors.placeholderColors[index],
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productDescription;
  final Product product;
  final Color placeholderColor;

  const ProductTile({
    required this.imageUrl,
    required this.productName,
    required this.productDescription,
    required this.product,
    required this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackgroundColor
          : AppColors.lightBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.titleDarkThemeColor
                        : AppColors.titleLightThemeColor,
                    fontSize: avgDimension(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                PriceTextFormat(product: product),
                phoneGestureDetector(product, context),
                Text(
                  productDescription,
                  style: const TextStyle(
                    color: AppColors.smallTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
