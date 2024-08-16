import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_listin/listins/models/listin.dart';
import 'package:flutter_listin/listins/services/listin_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listin_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<QuerySnapshot>(),
  MockSpec<CollectionReference>(),
  MockSpec<QueryDocumentSnapshot>(),
])
void main() {
  late String uid;
  late MockFirebaseFirestore mockFirebaseFirestore;
  setUp(
    () {
      mockFirebaseFirestore = MockFirebaseFirestore();

      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      final mockCollection = MockCollectionReference<Map<String, dynamic>>();

      final mockDoc001 = MockQueryDocumentSnapshot<Map<String, dynamic>>();
      final mockDoc002 = MockQueryDocumentSnapshot<Map<String, dynamic>>();

      uid = 'MEUID';

      final listin1 = Listin(
        id: "ID001",
        name: "name",
        obs: "obs",
        dateCreate: DateTime.now().subtract(const Duration(days: 32)),
        dateUpdate: DateTime.now().subtract(const Duration(days: 32)),
      );
      final listin2 = Listin(
        id: "ID002",
        name: "name",
        obs: "obs",
        dateCreate: DateTime.now().subtract(const Duration(days: 32)),
        dateUpdate: DateTime.now().subtract(const Duration(days: 32)),
      );

      when(mockDoc001.data()).thenReturn(listin1.toMap());
      when(mockDoc002.data()).thenReturn(listin2.toMap());

      when(mockSnapshot.docs).thenReturn([mockDoc001, mockDoc002]);

      when(mockCollection.get()).thenAnswer((_) async => mockSnapshot);

      when(mockFirebaseFirestore.collection(uid)).thenReturn(mockCollection);
    },
  );

  test('busca a lista do firebase', () async {
    final listinService = ListinService(
      uid: uid,
      firestore: mockFirebaseFirestore,
    );

    final result = await listinService.getListins();

    expect(result.length, 2);
  });
}
