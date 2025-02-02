import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mob4/models/test_models.dart';
import 'package:mob4/screens/create_candidate_screen.dart';
import 'package:mob4/screens/test_history_screen.dart';
import 'package:mob4/utils/helpers.dart';
import '../models/candidate.dart';
import '../models/personal_info.dart';
import '../services/firestore_service.dart';
import '../utils/box_config.dart';

class CandidatesListScreen extends StatefulWidget {


  const CandidatesListScreen({super.key});

  @override
  State<CandidatesListScreen> createState() => _CandidatesListScreenState();
}

class _CandidatesListScreenState extends State<CandidatesListScreen> {
  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);
  final boxCandidates = Hive.box<Candidate>(BoxName.boxCandidates);
  final boxTests = Hive.box<Test>(BoxName.boxTests);
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshCandidateList();
    refreshTestsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates list'),
        leading: IconButton(onPressed: (){
          if (kDebugMode) {
            print("Logout");
          }
          FirebaseAuth.instance.signOut();
          boxCandidates.clear();
          boxAuthInfo.clear();
        }, icon: const Icon(Icons.logout, color: Colors.red,)),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateCandidatePage(),
              ),
            );
            }, icon: const Icon(Icons.add, color: Colors.green,)),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: boxCandidates.listenable(),
        builder: (context, box, child){
          return RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await refreshCandidateList();
            },
            child: box.values.isEmpty ? const Center(child: Text("Not yet candidate"),) : ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                final candidate = box.getAt(index);
                return candidate == null ? Container() : Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(candidate.lastName[0] + candidate.otherNames[0]),
                    ),
                    title: Text('${candidate.lastName} ${candidate.otherNames}'),
                    subtitle: Text(candidate.email),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestDetailsPage(candidateId: candidate.email),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      ),
    );
  }

  refreshCandidateList() async {
    if(boxAuthInfo.isNotEmpty){
      var token = boxAuthInfo.values.first.idToken;
      if(token != null){
        UserService().getCandidates().then((value) {

          if(boxCandidates.values.length > value.length){
            boxCandidates.clear();
          }

          for (var element in value) {

            Candidate candidate = Candidate.fromMap(element);
            boxCandidates.put(candidate.id, candidate);

          }

          Helper.scaffoldMessenger(context, 'List of candidates successfully updated.');
        });
      }
    }
  }

  Future<void> refreshTestsList() async {
    if(boxAuthInfo.isNotEmpty){
      var token = boxAuthInfo.values.first.idToken;
      if(token != null){
        UserService userService = UserService();
        await userService.getAllTests().then((value) async {
          
          await boxTests.clear();
          for (var element in value) {
            Test test = Test.fromMap(element);
            boxTests.put(test.testId, test);
          }

          if (kDebugMode) {
            print("Liste des tests rechargé ${boxTests.values.length}");
          }

        });
      }
    }
  }
}

class CandidateDetailsPage extends StatelessWidget {
  final Candidate candidate;

  const CandidateDetailsPage({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${candidate.lastName} ${candidate.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${candidate.otherNames}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Last Name: ${candidate.lastName}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: ${candidate.email}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
