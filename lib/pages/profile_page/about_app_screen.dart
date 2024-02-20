import 'package:buy_and_sell_used_stuff_mobile_application/pages/sign_in_page/social_card.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('درباره اپلیکیشن'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('about')
            .doc('app_info')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(
                avgDimension(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: avgDimension(20),
                  ),
                  Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            launchUrl(
                              data['social_media_link'],
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              avgDimension(100),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: data['creator_image'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: avgDimension(100),
                                height: avgDimension(100),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x12ffe0a1),
                                      blurRadius: avgDimension(50),
                                      spreadRadius: avgDimension(10),
                                      offset: Offset(
                                        avgDimension(0),
                                        avgDimension(1),
                                      ),
                                    )
                                  ],
                                  border: Border.all(
                                    color: Colors.orange,
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: avgDimension(10),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: avgDimension(10),
                  ),
                  Card(
                    margin: EdgeInsets.only(
                      right: avgDimension(20),
                      left: avgDimension(20),
                    ),
                    elevation: 10,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkBackgroundColor
                        : AppColors.lightBackgroundColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: avgDimension(10),
                        bottom: avgDimension(10),
                        right: avgDimension(20),
                        left: avgDimension(20),
                      ),
                      child: Text(
                        data['description'].replaceAll(
                          '\\n',
                          '\n\t',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: avgDimension(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialCard(
                        icon: "assets/icons/linkedin.svg",
                        press: () {
                          launchUrlString(
                            data['social_media_link'][0],
                          );
                        },
                      ),
                      SocialCard(
                        icon: "assets/icons/instagram.svg",
                        press: () {
                          launchUrlString(
                            data['social_media_link'][1],
                          );
                        },
                      ),
                      SocialCard(
                        icon: "assets/icons/telegram.svg",
                        press: () {
                          launchUrlString(
                            data['social_media_link'][2],
                          );
                        },
                      ),
                      SocialCard(
                        icon: "assets/icons/github.svg",
                        press: () {
                          launchUrlString(
                            data['social_media_link'][3],
                          );
                        },
                      ),
                      SocialCard(
                        icon: "assets/icons/whatsapp.svg",
                        press: () {
                          launchUrlString(
                            data['social_media_link'][4],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
