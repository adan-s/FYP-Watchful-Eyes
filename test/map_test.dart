import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fyp/screens/map.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {

    // Initialize Firebase app
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBhcF3CgybYcpRRAk3TE-ZvgFlkJRagmgU',
        appId: '1:321253756082:web:9843f6a0837010ea788dab',
        messagingSenderId: '321253756082',
        projectId: 'watchfuleyes-c2a9d',
        authDomain: 'watchfuleyes-c2a9d.firebaseapp.com',
        databaseURL: 'https://watchfuleyes-c2a9d-default-rtdb.firebaseio.com',
        storageBucket: 'gs://watchfuleyes-c2a9d.appspot.com',
      ),
    );
  });

  test('_fetchAllCrimeData should return a list of CrimeData objects', () async {
    // Mocking Firestore
    final MockFirestore firestore = MockFirestore();
    final MockCollectionReference collectionReference = MockCollectionReference();
    final MockQuery query = MockQuery();
    final MockQuerySnapshot querySnapshot = MockQuerySnapshot();
    final MockQueryDocumentSnapshot documentSnapshot = MockQueryDocumentSnapshot();

    // Stubbing Firestore behavior
    when(firestore.collection(any as String)).thenReturn(collectionReference);
    when(collectionReference.get()).thenAnswer((_) async => querySnapshot);
    when(querySnapshot.docs).thenReturn([documentSnapshot]);
    when(documentSnapshot.data()).thenReturn({
      'location': {'latitude': 1.0, 'longitude': 2.0},
      'crimeType': 'Theft',
      'fullName': 'John Doe',
      'isAnonymous': true,
      'date': '2024-05-04',
      'time': '12:00 PM',
    });

    // Call the function under test
    final result = await _fetchAllCrimeData(firestore);

    // Assertion
    expect(result, isA<List<CrimeData>>());
    expect(result.length, equals(1));
    expect(result.first, isA<CrimeData>());
  });
}

Future<List<CrimeData>> _fetchAllCrimeData(FirebaseFirestore firestore) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await firestore.collection('crimeData').get();

    List<CrimeData> crimeDataList = querySnapshot.docs
        .map((doc) {
      Map<String, dynamic> crimeDataMap = doc.data();
      if (crimeDataMap.containsKey('location') &&
          crimeDataMap['location'] != null) {
        double latitude = crimeDataMap['location']['latitude'];
        double longitude = crimeDataMap['location']['longitude'];
        String? crimeType = crimeDataMap['crimeType'];
        String? fullName = crimeDataMap['fullName'];
        bool? isAnonymous = crimeDataMap['isAnonymous'] ?? false;
        String? date = crimeDataMap['date'];
        String? time = crimeDataMap['time'];

        return CrimeData(
          latitude: latitude,
          longitude: longitude,
          crimeType: crimeType ?? '',
          fullName: fullName ?? '',
          isAnonymous: isAnonymous ?? false,
          date: date ?? '',
          time: time ?? '',
        );
      } else {
        print("Warning: 'location' map is missing or null in crime data");
        return null;
      }
    })
        .where((crimeData) => crimeData != null)
        .map((crimeData) => crimeData!)
        .toList();

    return crimeDataList;
  } catch (e) {
    print("Error fetching all crime data: $e");
    return [];
  }
}
