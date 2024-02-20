import 'package:buy_and_sell_used_stuff_mobile_application/firestore_service/firestore_service.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/big_text.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/small_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  final String userId;
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ProductsScreen({super.key, required this.userId});


  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'پست ها',
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: firestoreService.streamProducts(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              List<Product> products = snapshot.data!;

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];

                  return Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkBackgroundColor
                        : AppColors.lightBackgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: product.images[0],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: avgDimension(10),
                            left: avgDimension(10),
                            bottom: avgDimension(10),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(avgDimension(20)),
                              bottomRight: Radius.circular(avgDimension(20)),
                            ),
                          ),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleText(
                                  text: product.title,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.titleDarkThemeColor
                                      : AppColors.titleLightThemeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: avgDimension(16),
                                ),
                                SmallText(
                                  text: product.description,
                                  fontSize: avgDimension(12),
                                  color: AppColors.smallTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          child: const Text('حذف'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('حذف محصول'),
                                  content: const Text(
                                    'آیا مطمئن هستید که می‌خواهید این محصول را حذف کنید؟',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('لغو'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('حذف'),
                                      onPressed: () {
                                        final productId = products[index].id;
                                        firestoreService
                                            .getDocumentId(productId)
                                            .then((documentId) {
                                            if (kDebugMode) {
                                              print(documentId);
                                            }

                                            final docProduct = _firestore
                                                .collection('products')
                                                .doc(documentId);
                                            docProduct.delete();
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
