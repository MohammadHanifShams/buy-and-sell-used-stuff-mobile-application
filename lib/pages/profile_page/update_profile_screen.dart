import 'dart:io';
import 'package:buy_and_sell_used_stuff_mobile_application/resources/authentication_methods.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/utils.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/customized_actionChip_button.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/text_field_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  late String userId = user?.uid ?? '';
  bool _obscured = true;
  String photoUrl = '';
  String displayName = '';
  String email = '';
  User? _currentUser;

  Future<void> _loadCurrentUser() async {
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

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
  void initState() {
    super.initState();
    _loadCurrentUser();
    if (user != null) {
      setState(() {
        displayName = user!.displayName ?? "";
        email = user!.email ?? "";
        photoUrl = user!.photoURL ?? "assets/image/default_avatar.png";
      });
    }
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  void dispose() {
    super.dispose();
    displayNameController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = SizeConfig().getScreenSize(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(avgDimension(20.0)),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: avgDimension(120),
                    height: avgDimension(120),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(avgDimension(100)),
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
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => ClipRRect(
                          borderRadius:
                              BorderRadius.circular(avgDimension(100)),
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
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('دوربین'),
                                onTap: () => pickImage(ImageSource.camera),
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('گالری تصاویر'),
                                onTap: () => pickImage(ImageSource.gallery),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: avgDimension(30),
                        height: avgDimension(30),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(avgDimension(100)),
                          color: AppColors.iconColor2,
                        ),
                        child: Icon(
                          LineAwesomeIcons.camera,
                          size: avgDimension(25),
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: avgDimension(20),
              ),
              Form(
                child: Column(
                  children: [
                    TextFieldWidget(
                      title: "نام کامل",
                      hintText:
                          // _currentUser?.displayName ??
                          "نام و نام خانوادگی خود را وارد نمایید",
                      suffixIcon: const Icon(LineAwesomeIcons.user),
                      obscureText: false,
                      controller: displayNameController,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: avgDimension(15),
                    ),
                    TextFieldWidget(
                      title: "ایمیل",
                      hintText: "ایمیل خود را وارد نمایید",
                      suffixIcon: const Icon(LineAwesomeIcons.envelope_1),
                      obscureText: false,
                      controller: emailController,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: avgDimension(15),
                    ),
                    TextFieldWidget(
                      title: "شماره تماس",
                      hintText: "شماره تماس خود را وارد نمایید",
                      suffixIcon: const Icon(LineAwesomeIcons.phone),
                      obscureText: false,
                      controller: phoneController,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: avgDimension(15),
                    ),
                    TextFieldWidget(
                      title: "آدرس",
                      hintText: "آدرس خود را وارد نمایید",
                      suffixIcon: const Icon(LineAwesomeIcons.home),
                      obscureText: false,
                      controller: addressController,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: avgDimension(15),
                    ),
                    TextFieldWidget(
                      title: "پسورد",
                      hintText: "رمز عبور خود را وارد نمایید",
                      controller: passwordController,
                      maxLines: 1,
                      suffixIcon: const Icon(LineAwesomeIcons.lock),
                      prefixIcon: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? LineAwesomeIcons.eye
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                      obscureText: _obscured,
                    ),
                    SizedBox(
                      height: avgDimension(15),
                    ),
                    TextFieldWidget(
                      title: "تائید پسورد",
                      hintText: "رمز عبور خود دوباره وارد نمایید",
                      controller: confirmPasswordController,
                      maxLines: 1,
                      suffixIcon: const Icon(LineAwesomeIcons.lock),
                      prefixIcon: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? LineAwesomeIcons.eye
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                      obscureText: _obscured,
                    ),
                    SizedBox(
                      height: avgDimension(30),
                    ),
                    CustomizedButton(
                      fixedSize: Size(
                        screenSize.width * avgDimension(0.4),
                        avgDimension(40),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String output =
                            await authenticationMethods.updateUserProfile(
                          displayName: displayNameController.text,
                          address: addressController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          confirmPassword: confirmPasswordController.text,
                          phone: phoneController.text,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (output == "Success") {
                          Navigator.pop(context);
                        } else {
                          //error feedback
                          Utils()
                              .showSnackBar(context: context, content: output);
                        }
                      },
                      color: AppColors.mainColor,
                      isLoading: isLoading,
                      child: const Text(
                        "ذخیره",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
