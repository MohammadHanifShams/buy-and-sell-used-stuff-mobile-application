import 'package:buy_and_sell_used_stuff_mobile_application/model/users_model.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/resources/cloudfirestore_methods.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationMethods extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  CloudFireStoreMethod cloudFirestoreMethod = CloudFireStoreMethod();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<String> signUpUser({
    required BuildContext context,
    required String displayName,
    required String address,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    address.trim();
    email.trim();
    password.trim();
    confirmPassword.trim();
    String output = "مشکلی پیش آمد.";
    if (
        displayName != "" &&
        address != "" &&
        email != "" &&
        password != "" &&
        confirmPassword != "" &&
        password == confirmPassword) {
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserDetailsModel user = UserDetailsModel(
            displayName: displayName, email: email, password: password);
        await cloudFirestoreMethod.uploaddisplayNameAndAddressToDatabase(
            user: user, displayName: displayName, address: address, password: password);
        output = "ثبت نام با موفقیت انجام شد";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else if (password != confirmPassword) {
      output = "password does not match the confirm password";
    } else {
      output = "Please fill all the fields.";
    }
    Utils().showSnackBar(
      context: context,
      content: output,
    );
    return output;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    email.trim();
    password.trim();
    String output = "مشکلی پیش آمد.";
    if (email != "" && password != "") {
      try {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        output = "Success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill all the fields.";
    }
    return output;
  }

  Future<String> updateUserProfile({
    String? email,
    String? address,
    String? password,
    String? photoUrl,
    String? displayName,
    String? confirmPassword,
    String? phone,
    String? newName,
    String? newEmail,
    String? newPassword,
    String? newPhone,
    String? newAddress,
  }) async {
    email?.trim();
    password?.trim();
    confirmPassword?.trim();
    String output = "مشکلی پیش آمد.";
    try {
      UserDetailsModel user = UserDetailsModel(
          displayName: displayName,
          address: address,
          phone: phone,
          email: email,
          photoUrl: photoUrl,
          password: password);
      await cloudFirestoreMethod.updatedisplayNameAndAddressToDatabase(
          user: user);
      output = "Success";
    } on FirebaseAuthException catch (e) {
      output = e.message.toString();
    }
    if (password != confirmPassword) {
      output = "password does not match the confirm password";
    }
    return output;
  }
}
