import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> streamProducts(String userId) {
    return _db
        .collection('products')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Product> retVal = [];
      for (var element in query.docs) {
        retVal.add(Product.fromFirestore(element));
      }
      return retVal;
    });
  }

  Future<void> deleteProduct(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .delete();
  }

  Future<void> updateProduct(product) {
    return _db
        .collection('products')
        .doc(product.id)
        .update(product.toFirestore());
  }

  // getProductId(productId) {
  //   return _db
  //       .collection('products')
  //       .where('id', isEqualTo: productId)
  //       .snapshots();
  // }

  Future<String> getDocumentId(String productId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: productId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return 'null'; // اگر Product ID پیدا نشد
    }
  }
}