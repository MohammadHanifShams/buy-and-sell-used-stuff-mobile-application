import 'package:cloud_firestore/cloud_firestore.dart';

class Ads {
  String id;
  String title;
  String description;
  final List<String> images;
  Ads({required this.id,
    required this.title,
    required this.description,
    required this.images,});

  factory Ads.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Ads(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] as List<dynamic>),
    );
  }
}