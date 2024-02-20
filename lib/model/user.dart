import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? displayName;
  final String? phone;
  final String? address;
  final String? photoUrl;
  final String? email;
  final String? userId;

  User({
    this.address,
    this.email,
    this.photoUrl,
    this.displayName,
    this.phone,
    this.userId,
  });

  // static User fromFirestore(DocumentSnapshot doc) {
  //   if (doc.data() != null) {
  //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
  //     return User(
  //       phone: data['phone'],
  //       displayName: data['displayName'],
  //       address: data['address'],
  //       email: data['email'],
  //       photoUrl: data['photoUrl'],
  //     );
  //   } else {
  //     throw Exception('مقدار null در doc.data() وجود دارد');
  //   }
  // }

  factory User.fromFirestore(DocumentSnapshot doc) {

    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return User(
      phone: json['phone'] ?? '',
      displayName: json['displayName'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'address': address,
      'phone': phone,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
