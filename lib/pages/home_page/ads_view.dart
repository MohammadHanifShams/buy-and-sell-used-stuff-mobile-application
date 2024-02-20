import 'dart:async';

import 'package:buy_and_sell_used_stuff_mobile_application/model/ads.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/big_text.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/small_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsView extends StatefulWidget {
  const AdsView({super.key});

  @override
  State<AdsView> createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
    );
    _timer = Timer.periodic(
      const Duration(seconds: 7),
      (timer) {
        if (_currentPage < 4) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: avgDimension(240), // ارتفاع کارت
          child: Card(
            color: AppColors.mainColor,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: avgDimension(5), // فاصله متن
                    right: avgDimension(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          TitleText(
                            text: "تبلیغات",
                            fontSize: avgDimension(25),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: avgDimension(180),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return buildAdsList(index);
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAdsList(int index) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('ads').snapshots(),
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
        Uri adUrl = Uri.parse(documents[index].get('adUrl'));

        return GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print('Ads URL: $adUrl');
            }
            launchUrl(adUrl);
          },
          child: AdsListItems(
            imageUrl: imageUrl,
            title: imageTitle,
            description: descriptionText,
            ads: Ads.fromFirestore(snapshot.data!.docs[index]),
          ),
        );
      },
    );
  }
}

class AdsListItems extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Ads ads;

  const AdsListItems({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.ads,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: avgDimension(10),
        right: avgDimension(10),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              radius(
                avgDimension(10),
              ),
            ),
            child: Container(
              height: avgDimension(180), //ارتفاع تصویر
              width: avgDimension(344),
              decoration: BoxDecoration(
                color: Colors.black54,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(ads.images.first),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: avgDimension(0),
            child: Container(
              height: avgDimension(70), // ارتفاع متن
              width: avgDimension(344),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(radius(avgDimension(10))),
                  bottomLeft: Radius.circular(radius(avgDimension(10))),
                ),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Container(
                margin: EdgeInsets.only(
                  top: avgDimension(5),
                  right: avgDimension(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      text: ads.title,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: avgDimension(14),
                    ),
                    SmallText(
                      text: ads.description,
                      fontSize: 12,
                      color: AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
