import 'dart:math';

import 'package:buy_and_sell_used_stuff_mobile_application/model/phone_model.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/price_text_format.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/model/product_click_event.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/search_screen/tile_for_search.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/connectivity_service.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/app_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

Future<int> getTotalImageCount() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();
  return querySnapshot.docs.length;
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final FocusNode _focusNode = FocusNode();
  bool _isSearchFieldFocused = false;

  final ConnectivityService _connectivityService = ConnectivityService();
  late String userId;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';

    _focusNode.addListener(() {
      setState(() {
        _isSearchFieldFocused = _focusNode.hasFocus;
      });
    });

    _connectivityService.onConnectivityChanged.listen(
      (ConnectivityResult result) {},
    );
    FirebaseFirestore.instance.collection('products').snapshots().listen(
      (snapshot) {
        if (mounted) {
          if (snapshot.docs.isNotEmpty) {
            setState(() {
              products = snapshot.docs
                  .map((doc) => Product.fromFirestore(doc))
                  .toList();
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  List<Product> searchResults = [];
  TextEditingController searchController = TextEditingController();

  _ProductSearchPageState() {
    productsCollection
        .withConverter<Product>(
          fromFirestore: (snapshots, _) => Product.fromFirestore(snapshots),
          toFirestore: (product, _) => product.toFirestore(),
        )
        .get(const GetOptions(source: Source.cache))
        .then(
      (QuerySnapshot<Product> querySnapshot) {
        products = querySnapshot.docs.map((doc) => doc.data()).toList();
        setState(() {
          searchResults = List.from(products);
        });
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print('Error getting cached products: $error');
        }
      },
    );
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          searchResults = List.from(products);
        });
      } else {
        setState(() {
          searchResults = products
              .where((product) => product.title
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: avgDimension(25),
            ),
            child: Text(
              "بگرد، پیدا کن، لذت ببر",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: avgDimension(25),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: avgDimension(25),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: avgDimension(25),
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: searchController,
              cursorColor: Colors.orange[700],
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.orange[700],
                ),
                hintText: "جستجو...",
                hintStyle: TextStyle(
                  color: Colors.orange[700],
                  fontSize: avgDimension(13),
                  fontWeight: FontWeight.bold,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.mainColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: avgDimension(25),
          ),
          _isSearchFieldFocused
              ? ListViewSearchItems(
                  searchResults: searchResults,
                )
              : const MasonryGView()
        ],
      ),
    );
  }
}

class MasonryGView extends StatelessWidget {
  const MasonryGView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getTotalImageCount(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: AppColors.placeholderColors[Random().nextInt(5)],
          );
        } else {
          if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
            );
          } else {
            var products = snapshot.data;
            return Expanded(
              child: MasonryGridView.builder(
                // physics: const BouncingScrollPhysics(),
                mainAxisSpacing: avgDimension(10),
                crossAxisSpacing: avgDimension(10),
                padding: EdgeInsets.all(avgDimension(8)),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data,
                itemBuilder: (context, index) {
                  return Tile(index: index);
                },
              ),
            );
          }
        }
      },
    );
  }
}

class ListViewSearchItems extends StatelessWidget {
  const ListViewSearchItems({
    super.key,
    required this.searchResults,
  });

  final List<Product> searchResults;

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
  Widget build(BuildContext context) {
    return Expanded(
      child: searchResults.isEmpty
          ? const Center(
              child: Text('موردی یافت نشد'),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return Container(
                  height: avgDimension(50),
                  margin: EdgeInsets.all(
                    avgDimension(8),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      avgDimension(10),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: avgDimension(30),
                      backgroundImage: CachedNetworkImageProvider(
                          searchResults[index].images[0]),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(searchResults[index].title),
                    onTap: () async {
                      String productId = searchResults[index].id;
                      String documentId =
                          await getDocumentIdByProductId(productId);
                      ClickEvent(
                        documentId: documentId,
                      ).onProductClick();

                      showMyDialog(context, index);
                    },
                  ),
                );
              },
            ),
    );
  }

  void showMyDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: IntrinsicHeight(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    searchResults[index].title,
                    style: TextStyle(
                      color: Theme.of(context).brightness ==
                          Brightness.dark
                          ? AppColors.titleDarkThemeColor
                          : AppColors.titleLightThemeColor,
                      fontSize: avgDimension(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          width: double.maxFinite,
                          child: CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: searchResults[index]
                                .images[0],
                            placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                            const Icon(
                              Icons.error,
                            ),
                          ),
                        ),
                        Positioned(
                          top: avgDimension(20),
                          left: avgDimension(20),
                          right: avgDimension(20),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const BackIcon(
                                  icon: Icons.arrow_back_ios,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      PriceTextFormat(
                        product: searchResults[index],
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 3,
                            "آدرس: ${searchResults[index].address}",
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
                          phoneGestureDetector(
                            searchResults[index],
                            context,
                          ),
                          SizedBox(
                            height: avgDimension(10),
                          ),
                          Center(
                            child: SizedBox(
                              width: avgDimension(250),
                              child: const Divider(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: avgDimension(10),
                          ),
                          Text(
                            searchResults[index].description,
                            style: const TextStyle(
                              color: AppColors.smallTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
