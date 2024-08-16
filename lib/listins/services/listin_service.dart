import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_listin/products/model/product.dart';
import 'package:flutter_listin/products/services/product_service.dart';
import 'package:uuid/uuid.dart';

import '../models/listin.dart';

class ListinService {
  late String uid;
  late FirebaseFirestore firestore;

  ListinService({String? uid, FirebaseFirestore? firestore}) {
    this.uid = uid ?? FirebaseAuth.instance.currentUser!.uid;
    this.firestore = firestore ?? FirebaseFirestore.instance;
  }

  Future<void> upinsertListin({required Listin listin}) async {
    // Insere ou atualiza o Lisitn com base no id
    return firestore.collection(uid).doc(listin.id).set(listin.toMap());
  }

  Future<List<Listin>> getListins() async {
    // Cria-se uma lista vazia que abrigará os Listins
    List<Listin> listListinResult = [];

    // Verifica-se o resultado o Snapshot na coleção do usuário
    QuerySnapshot<Map<String, dynamic>> listinsSnapshot =
        await firestore.collection(uid).get();

    // Adiciona-se os listins a lista
    for (var doc in listinsSnapshot.docs) {
      listListinResult.add(Listin.fromMap(doc.data()));
    }

    // Ordena-se por data de atualização (mais recentes, mais pra cima)
    listListinResult.sort(
      (a, b) {
        return b.dateUpdate.compareTo(a.dateUpdate);
      },
    );

    // Retorna-se a lista
    return listListinResult;
  }

  Future<void> duplicateListin({
    required String listinId,
    required bool isNeedMoveToPlan,
  }) async {
    // Resgatar informações sobre o listin a ser duplicado
    DocumentSnapshot<Map<String, dynamic>> oldListinSnapshot =
        await firestore.collection(uid).doc(listinId).get();

    // Caso não haja o listin a ser duplicado, finaliza o método
    if (oldListinSnapshot.data() == null) return;

    // Instanciar o antigo Listin
    Listin oldListin = Listin.fromMap(oldListinSnapshot.data()!);

    // ID do novo Listin
    String newListinId = const Uuid().v4();

    // Criar o novo Listin
    Listin newListin = Listin(
      id: newListinId,
      name: "${oldListin.name} (Cópia)",
      obs: oldListin.obs,
      dateCreate: DateTime.now(),
      dateUpdate: DateTime.now(),
    );

    await upinsertListin(listin: newListin);

    // Conseguir produtos do Listin antigo
    QuerySnapshot<Map<String, dynamic>> oldProductsSnapshot = await firestore
        .collection(uid)
        .doc(listinId)
        .collection("produtos")
        .get();

    // Caso não haja produtos, encerramos por aqui
    if (oldProductsSnapshot.docs.isEmpty) return;

    // Se houver, vamos criar os produtos
    for (var doc in oldProductsSnapshot.docs) {
      Product oldProduct = Product.fromMap(doc.data());

      Product newProduct = Product(
        id: const Uuid().v4(),
        name: oldProduct.name,
        obs: oldProduct.obs,
        category: oldProduct.category,
        isKilograms: oldProduct.isKilograms,
        isPurchased: (isNeedMoveToPlan) ? false : oldProduct.isPurchased,
      );

      await ProductService().upinsertProduct(
        listinId: newListinId,
        produto: newProduct,
      );
    }
  }

  Future<void> deleteListin({required String listinId}) async {
    // Remove-se o Listin com o Id passado
    return firestore.collection(uid).doc(listinId).delete();
  }
}
