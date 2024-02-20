import 'package:cloud_firestore/cloud_firestore.dart';

class ClickEvent {
  final String documentId;

  ClickEvent({required this.documentId});

  void onProductClick() async {
    final DocumentReference docProduct = FirebaseFirestore.instance
        .collection("products")
        .doc(documentId);

    DocumentSnapshot doc = await docProduct.get();

    int clickCount = doc.exists ? (doc.get('clickCount') ?? 0) + 1 : 1;

    docProduct.update({'clickCount': clickCount}).then((_) {
      print('Click count updated successfully');
    }).catchError((error) {
      print('Failed to update click count: $error');
    });
  }
}
