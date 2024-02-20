// import 'package:buy_and_sell_used_stuff_mobile_application/model/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
//
//
// class Product {
//   var id;
//    String title, description;
//   final String? address, phone;
//   final List<String> images;
//   final List<String>? categories;
//   double rating, price;
//   final bool isFavorite, isPopular;
//   final String userId;
//   User? user;
//   int clickCount;
//
//
//   Product( {
//     required this.id,
//      this.address,
//      this.phone,
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.images,
//      this.categories,
//     required this.userId,
//     this.user,
//     this.rating = 0.0,
//     this.isFavorite = false,
//     this.isPopular = false,
//     this.clickCount = 0,
//   });
//
//   void updateClickCount(int newClickCount) {
//     DatabaseReference productsRef = FirebaseDatabase.instance.ref().child('products');
//     productsRef.child(id).update({
//       'clickCount': newClickCount,
//     });
//   }
//   factory Product.fromFirestore(DocumentSnapshot doc) {
//
//     Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
//     return Product(
//       id: json['id'] ?? '',
//       title: json['title'] ?? '',
//       price: (json['price'] as num).toDouble(),
//       description: json['description'] ?? '',
//       address: json['address'] ?? '',
//       phone: json['phone'] ?? '',
//       images: List<String>.from(json['images'] as List<dynamic>),
//       categories: json['categories'] != null ? List<String>.from(json['categories'] as List<dynamic>) : [],
//       rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
//       isFavorite: json['isFavorite'] as bool? ?? false,
//       isPopular: json['isPopular'] as bool? ?? false,
//       userId: json['userId'] ?? '',
//       clickCount: json['clickCount'] as int? ?? 0,
//     );
//   }
//
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'id': id,
//       'title': title,
//       'price': price,
//       'description': description,
//       'address': address,
//       'phone': phone,
//       'images': images,
//       'categories': categories,
//       'rating': rating,
//       'isFavorite': isFavorite,
//       'isPopular': isPopular,
//       'userId': userId,
//       'user': user,
//       'clickCount': clickCount,
//     };
//   }
// }


import 'package:buy_and_sell_used_stuff_mobile_application/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Product {
  var id;
  String title, description;
  final String? address, phone;
  final List<String> images;
  final List<String>? categories;
  double price;
  final String userId;
  User? user;
  var clickCount;
  final String? uploadDate;
  // double rating;
  // final bool isFavorite, isPopular;

  Product({
    required this.id,
    this.address,
    this.phone,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.categories,
    required this.userId,
    this.clickCount = 0,
    this.uploadDate,
    // this.user,
    // this.rating = 0.0,
    // this.isFavorite = false,
    // this.isPopular = false,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      // price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      images: List<String>.from(json['images'] as List<dynamic>),
      categories: json['categories'] != null ? List<String>.from(json['categories'] as List<dynamic>) : [],
      userId: json['userId'] ?? '',
      clickCount: json['clickCount'] as int? ?? 0,
      uploadDate: json['uploadDate'] ?? '',
      // rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      // isFavorite: json['isFavorite'] as bool? ?? false,
      // isPopular: json['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'address': address,
      'phone': phone,
      'images': images,
      'categories': categories,
      'userId': userId,
      'clickCount': clickCount,
      'uploadDate': uploadDate,
      // 'rating': rating,
      // 'isFavorite': isFavorite,
      // 'isPopular': isPopular,
    };
  }
}
