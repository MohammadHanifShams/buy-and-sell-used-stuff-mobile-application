import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product_click_event.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/product_details_page/product_details_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tile extends StatelessWidget {
  final int index;

  const Tile({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: AppColors.placeholderColors[index],
          );
        }
        var products = snapshot.data!.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList();
        // var product = products[index % products.length];
        var product = products[index];
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
          child: Stack(
            children: [
              Container(
                color: AppColors.placeholderColors[index],
                width: double.infinity,
                height: 100,
              ),
              Visibility(
                visible: product.images[0].isNotEmpty,
                child: CachedNetworkImage(
                  imageUrl: product.images[0],
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
