import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/enum_order.dart';
import '../model/product.dart';

class ProductService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  upinsertProduct({required String listinId, required Product produto}) {
    firestore
        .collection(uid)
        .doc(listinId)
        .collection("produtos")
        .doc(produto.id)
        .set(produto.toMap());
  }

  Future<List<Product>> getProducts(
      {required String listinId,
      required ProductOrder ordem,
      required bool isDecrescente,
      QuerySnapshot<Map<String, dynamic>>? snapshot}) async {
    List<Product> temp = [];

    snapshot ??= await firestore
        .collection(uid)
        .doc(listinId)
        .collection("produtos")
        // .where("isComprado", isEqualTo: isComprado)
        .orderBy(ordem.name, descending: isDecrescente)
        .get();

    for (var doc in snapshot.docs) {
      Product produto = Product.fromMap(doc.data());
      temp.add(produto);
    }

    return temp;
  }

  togglePurchased({required Product produto, required String listinId}) async {
    produto.isPurchased = !produto.isPurchased;

    await firestore
        .collection(uid)
        .doc(listinId)
        .collection("produtos")
        .doc(produto.id)
        .update({"isComprado": produto.isPurchased});
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> connectStream({
    required Function onChange,
    required String listinId,
    required ProductOrder ordem,
    required bool isDecrescente,
  }) {
    return firestore
        .collection(uid)
        .doc(listinId)
        .collection("produtos")
        .orderBy(ordem.name, descending: isDecrescente)
        .snapshots()
        .listen(
      (snapshot) {
        onChange(snapshot: snapshot);
      },
    );
  }

  Future<void> removeProduct(
      {required Product produto, required String listinId}) async {
    return await firestore
        .collection(uid)
        .doc(listinId)
        .collection("produtos")
        .doc(produto.id)
        .delete();
  }
}
