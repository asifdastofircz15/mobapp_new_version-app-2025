import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mob4/models/candidate.dart';

import '../models/test_models.dart';

class UserService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference testsCollection = FirebaseFirestore.instance.collection('tests');

  Future<List<Map<String, dynamic>>> getCandidates() async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where('role', isEqualTo: 'candidate')
          .get();

      List<Map<String, dynamic>> candidates = querySnapshot.docs
          .map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();

      return candidates;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des candidats : $e');
      }
      return [];
    }
  }

  Future<Candidate?> getUserRoleByEmail(String email) async {
    try {
      var querySnapshot = await usersCollection
        .where('email', isEqualTo: email).get();

      var userDoc = querySnapshot.docs.first;

      if (userDoc.exists) {
        return Candidate.fromMap({
          'id': userDoc.id,
          ...userDoc.data() as Map<String, dynamic>,
        });
      } else {
        if (kDebugMode) {
          print('Utilisateur non trouvé dans Firestore.');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du rôle getUserRoleByEmail: $e');
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getTests(String candidateId) async {
    try {
      QuerySnapshot querySnapshot = await testsCollection
          .where('candidate_id', isEqualTo: candidateId)
          .get();

      List<Map<String, dynamic>> tests = querySnapshot.docs
          .map((doc) => {
        'testId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
      return tests;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des candidats : $e');
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllTests() async {
    try {
      QuerySnapshot querySnapshot = await testsCollection.get();

      List<Map<String, dynamic>> tests = querySnapshot.docs
          .map((doc) => {
        'testId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
      return tests;
    } catch (e) {
      if (kDebugMode) {
        print('Error while retrieving candidates. : $e');
      }
      return [];
    }
  }

  Future<Candidate?> getUserById(String email) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.first.exists) {
        var userDoc = snapshot.docs.first;
        return Candidate.fromMap( {
          'id': userDoc.id,
          ...userDoc.data(),
        });
      } else {
        if (kDebugMode) {
          print('Utilisateur non trouvé dans Firestore.');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du User : $e');
      }
      return null;
    }
  }

  Future<ResponseMessage> addTestToFirestore(Test test) async {
    try {
      // Convertir l'objet Test en Map
      Map<String, dynamic> testMap = test.toMap();
      // Ajouter le document à la collection avec un ID unique généré par Firestore
      await testsCollection.doc(test.testId).set(testMap);
      return ResponseMessage(success: true, message: "Success");
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'ajout du test: $e');
      }
      return ResponseMessage(success: false, message: "Erreur lors de l'ajout du test");
    }
  }

  Future<bool> loginWithTemporaryPassword(String email, String tempPassword) async {
    var querySnapshot = await usersCollection
        .where('email', isEqualTo: email)
        .where('temp_password', isEqualTo: tempPassword)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> updateUserId(String email, String newUserId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;

        await userDoc.reference.update({
          'user_id': newUserId,
        });

        if (kDebugMode) {
          print("User ID updated successfully.");
        }
      } else {
        if (kDebugMode) {
          print("User not found.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating user ID: $e");
      }
    }
  }

}

class ResponseMessage {
  bool success;
  String? message;
  List<Map<String, dynamic>>? data;


  ResponseMessage({required this.success, this.message, this.data});

}