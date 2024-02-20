import 'package:buy_and_sell_used_stuff_mobile_application/model/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFireStoreMethod {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');


  Future<void> uploaddisplayNameAndAddressToDatabase(
        {required UserDetailsModel user, required String displayName, required String address, required String password}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await userCollection.doc(user.uid).set({
        'displayName': displayName,
        'address': address,
        'email': user.email,
        'password': password,
      }, SetOptions(merge: true));
    }
  }
  Future<UserDetailsModel?> getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await userCollection.doc(user.uid).get();
      if (doc.exists) {
        return UserDetailsModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }


  updatedisplayNameAndAddressToDatabase({required UserDetailsModel user}) async {
    await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .update(user.getJson());
  }
}
