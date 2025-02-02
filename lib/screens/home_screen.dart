import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mob4/services/firestore_service.dart';

import '../models/candidate.dart';
import '../models/personal_info.dart';
import 'tests_list_by_candidate_screen.dart';
import '../utils/box_config.dart';
import 'candidates_screen.dart';

class HomePage extends StatefulWidget {
  User user;

  HomePage(this.user, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);

  Future<Candidate?> getUser() async {
    if(boxAuthInfo.isEmpty){
      if (kDebugMode) {
        print("Vide");
      }
      User? user = widget.user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      String? idToken = await user.getIdToken();
      Candidate? candidate = await UserService().getUserRoleByEmail(user.email!);
      var role = candidate?.role ?? 'candidate';
      if (kDebugMode) {
        print("Role $role");
      }
      var idRefresh = user.refreshToken;

      var authInfo = AuthInfo(user.email, idToken, idRefresh, DateTime.now(), role, user.email!);
      boxAuthInfo.put(user.uid,authInfo);
      return Future(() => candidate);
    }
    if (kDebugMode) {
      print(boxAuthInfo.values.first.role);
      print(boxAuthInfo.values.first.email);
    }
    return UserService().getUserRoleByEmail(widget.user.email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Candidate?>(
        future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final candidate = snapshot.data;
            var role = candidate?.role ?? 'candidate';
            return role == 'examiner' ? const CandidatesListScreen() : TestsByCandidatePage(candidateId: candidate!.email);
        })

    );
  }

  Widget loaderWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loader circulaire
          const CircularProgressIndicator(
            color: Colors.blue, // Couleur du loader
            strokeWidth: 4.0, // Épaisseur de l'anneau
          ),
          const SizedBox(height: 20), // Espacement
          // Texte sous le loader
          Text(
            "Loading, please wait...", // Texte affiché
            style: TextStyle(
              fontSize: 16, // Taille de police
              fontWeight: FontWeight.w500, // Épaisseur du texte
              color: Colors.grey[700], // Couleur du texte
            ),
          ),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: LoadingPage(),
//   ));
// }
