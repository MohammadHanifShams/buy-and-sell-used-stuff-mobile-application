import 'dart:ui';
import 'package:buy_and_sell_used_stuff_mobile_application/model/phone_model.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/price_text_format.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/app_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  const ProductDetailsScreen(this.productId, {super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkBackgroundColor
                      : AppColors.lightBackgroundColor,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (snapshot.hasData) {
              Product product = Product.fromFirestore(snapshot.data!);
              return ListView(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Wrap(
                            children: product.images.map<Widget>((image) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(avgDimension(30)),
                                  bottomRight: Radius.circular(avgDimension(30)),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: CachedNetworkImage(
                                    imageUrl: image,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          buttonArrow(context),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(avgDimension(25)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: avgDimension(5),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                bottom: avgDimension(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .brightness ==
                                          Brightness.dark
                                          ? AppColors.titleDarkThemeColor
                                          : AppColors
                                          .titleLightThemeColor,
                                      fontSize: avgDimension(20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: avgDimension(10),
                                  ),
                                  PriceTextFormat(product: product),
                                  SizedBox(
                                    height: avgDimension(10),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          "آدرس: ${product.address!}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: avgDimension(18),
                                            color: Theme.of(context)
                                                .brightness ==
                                                Brightness.dark
                                                ? AppColors
                                                .addressAndPhoneDarkThemeColor
                                                : AppColors
                                                .addressAndPhoneLightThemeColor,
                                          ),
                                        ),
                                      ),
                                      //TODO: phone
                                      phoneGestureDetector(product, context),
                                      SizedBox(
                                        height: avgDimension(10),
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: avgDimension(300),
                                          child: const Divider(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        height: avgDimension(10),
                                      ),
                                      Text(
                                        product.description,
                                        style: const TextStyle(
                                            color: AppColors.smallTextColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        avgDimension(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: avgDimension(35),
          width: avgDimension(35),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
            avgDimension(25),
          )),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: avgDimension(10),
              sigmaY: avgDimension(10),
            ),
            child: Container(
              height: avgDimension(35),
              width: avgDimension(35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  avgDimension(25),
                ),
              ),
              child: const BackIcon(
                icon: Icons.arrow_back_ios,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
