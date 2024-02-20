import 'dart:io';
import 'package:buy_and_sell_used_stuff_mobile_application/model/users_model.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/profile_page/UploadProductPage/UploadProductPage.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/profile_page/about_app_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/profile_page/update_profile_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/profile_page/user_products.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/sign_in_page/Sign_in_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/resources/cloudfirestore_methods.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/customized_actionChip_button.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/profile_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  late String userId = user?.uid ?? '';
  String photoUrl = '';
  User? _currentUser;
  UserDetailsModel? userDetails;


  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    getUserDetailsFromFirestore();
    photoUrl = user!.photoURL ?? "assets/image/default_avatar.png";
  }

  Future<void> getUserDetailsFromFirestore() async {
    CloudFireStoreMethod firestoreMethod = CloudFireStoreMethod();
    await firestoreMethod.getUserDetails().then((userModel) {
      setState(() {
        userDetails = userModel;
      });
    });
  }

  String getUsernameFromEmail(String email) {
    String username = email.split('@')[0];
    username = username.replaceAll(RegExp(r'[0-9]'), '');
    return username;
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      try {
        File imageFile = File(image.path);
        String filePath =
            'profileImages/${firebaseAuth.currentUser!.uid}/${Path.basename(imageFile.path)}';
        UploadTask task =
            FirebaseStorage.instance.ref(filePath).putFile(imageFile);

        final TaskSnapshot snapshot = await task.whenComplete(() {});
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        await firebaseAuth.currentUser!.updatePhotoURL(downloadUrl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'photoUrl': downloadUrl,
        });

        setState(() {
          photoUrl = downloadUrl;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (Get.isDarkMode) {
                Get.changeTheme(ThemeData.light());
              } else {
                Get.changeTheme(ThemeData.dark());
              }
            },
            icon: Icon(
              Get.isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            avgDimension(20.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height: avgDimension(10),
              ),
              Stack(
                children: [
                  SizedBox(
                    width: avgDimension(150),
                    height: avgDimension(150),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        avgDimension(100),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: photoUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(
                            avgDimension(100),
                          ),
                          child: Image.asset(
                            "assets/image/default_avatar.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('دوربین'),
                                onTap: () => pickImage(ImageSource.camera),
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('گالری تصاویر'),
                                onTap: () => pickImage(ImageSource.gallery),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: avgDimension(40),
                        height: avgDimension(40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            avgDimension(100),
                          ),
                          color: AppColors.iconColor2,
                        ),
                        child: Icon(
                          LineAwesomeIcons.camera,
                          size: avgDimension(28),
                          color: AppColors.greyLight,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: avgDimension(5),
              ),
              SizedBox(height: avgDimension(100),
                child: Center(
                  child: userDetails != null
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: avgDimension(20),
                            ),
                            Text(
                              getUsernameFromEmail(
                                userDetails!.displayName ?? userDetails!.email!,
                              ),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(
                              height: avgDimension(10),
                            ),
                            Text(
                              '${userDetails!.email}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: avgDimension(10),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
              SizedBox(
                height: avgDimension(40),
                width: avgDimension(300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomizedButton(
                      onPressed: () => Get.to(
                        () => const UpdateProfileScreen(),
                      ),
                      color: AppColors.mainColor,
                      isLoading: isLoading,
                      child: const Text(
                        "ویرایش",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.to(
                        () => ProductsScreen(
                          userId: userId,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                      ),
                      child: const Text(
                        "محصولات",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                        ),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "پست",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => Get.to(
                          () => const UploadProductPage(),
                        ),
                        // icon: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: avgDimension(15),
              ),
              Card(
                margin: EdgeInsets.all(
                  avgDimension(10),
                ),
                color: AppColors.mainOrangeColor,
                shadowColor: Colors.blueGrey,
                elevation: avgDimension(10),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListTile(
                        title: Text(
                          "کاربر گرامی! ",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'خوش آمدید! این اپلیکیشن، یک پلتفرم آنلاین برای خرید و فروش محصولات دست دوم است.\n من بر این باورم که خرید و فروش محصولات دست دوم می‌تواند هم برای خود شما سودآور باشد و در عین حال به حفظ محیط زیست کمک کند.',
                          style: TextStyle(
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: avgDimension(20),
              ),
              Container(
                width: 250,
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: avgDimension(10),
              ),
              ProfileMenuWidget(
                title: 'درباره اپلیکیشن',
                textColor:  Theme.of(context).brightness == Brightness.dark
                    ? AppColors.titleDarkThemeColor
                    : AppColors.titleLightThemeColor,
                icon: LineAwesomeIcons.info_circle,
                onPress: () {
                  Get.to(() => const AboutAppScreen());
                },
              ),
              SizedBox(
                height: avgDimension(10),
              ),
              ProfileMenuWidget(
                title: 'خروج',
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: avgDimension(60),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
