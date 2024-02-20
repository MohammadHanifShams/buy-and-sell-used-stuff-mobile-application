import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  final String? id;
  final String? email;
  final String? address;
  final String? password;
  final String? photoUrl;
  final String? displayName;
  final String? phone;

  UserDetailsModel({
    this.id,
    this.email,
    this.phone,
    this.address,
    this.password,
    this.photoUrl,
    this.displayName,
  });

  Map<String, dynamic> getJson() => {
        "email": email,
        "phone": phone,
        "address": address,
        "password": password,
        "photoUrl": photoUrl,
        "displayName": displayName,
      };

  factory UserDetailsModel.getModelFromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      password: json["password"],
      photoUrl: json["photoUrl"],
      displayName: json["displayName"],
    );
  }

  factory UserDetailsModel.fromMap(Map<String, dynamic> map) {
    return UserDetailsModel(
      displayName: map['displayName'],
      address: map['address'],
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      password: map['password'],
      id: map['id'],
    );
  }

  factory UserDetailsModel.fromDocument(DocumentSnapshot doc) {
    return UserDetailsModel(
      id: doc['id'],
      email: doc['email'],
      phone: doc['phone'],
      address: doc['address:'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
    );
  }

  factory UserDetailsModel.fromFirestore(DocumentSnapshot doc) {
    return UserDetailsModel(
      id: doc['id'],
      email: doc['email'],
      phone: doc['phone'],
      address: doc['address:'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
    );
  }

}
