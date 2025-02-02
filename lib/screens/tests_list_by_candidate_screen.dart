import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mob4/models/candidate.dart';
import 'package:mob4/models/personal_info.dart';
import 'package:mob4/services/firestore_service.dart';
import 'package:mob4/utils/app_data.dart';
import 'package:mob4/utils/helpers.dart';
import '../models/test_models.dart';
import '../services/pdf_generator.dart';
import '../utils/box_config.dart';

class TestsByCandidatePage extends StatefulWidget {
  String candidateId;

  TestsByCandidatePage({super.key, required this.candidateId});

  @override
  State<TestsByCandidatePage> createState() => _TestsByCandidatePageState();
}

class _TestsByCandidatePageState extends State<TestsByCandidatePage> {

  late bool isLoading = false;
  late bool isDownloading = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final boxCandidates = Hive.box<Candidate>(BoxName.boxCandidates);
  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);
  late List<Test> _tests = [];

  static final List<Vehicle> _vehicles = AppData.vehicles;
  static final List<Remark> _remarks = AppData.remarks;
  late Candidate? connectedCandidate;

  Future<void> _fetchTests() async {
    List<Test> tests = [];

    await UserService().getTests(widget.candidateId).then((items) {
      for(var item in items){
        tests.add(Test.fromMap(item));
      }
    });

    setState(() {
      _tests = tests;
    });

  }

  Future<Candidate?> _getConnectedUser() async {
    return UserService().getUserById(widget.candidateId).then((value) => value);
  }

  Vehicle _fetchVehicle(int vehicleId) {
    return _vehicles.firstWhere((vehicle) => vehicle.vehicleId == vehicleId);
  }

  void _showTestDetails(BuildContext context, String testId, int vehicleId) async {
    final test = _tests.firstWhere((test) => test.testId == testId);
    final remarks = _remarks.where((remark) => test.remarks.contains(remark.remarkId)).toList();
    final vehicle = _fetchVehicle(vehicleId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Test Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Test NO: ${test.testNo}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Date: ${test.date}'),
              const SizedBox(height: 8),
              Text('Licence NO: ${test.licenceNo}'),
              const SizedBox(height: 8),
              Text('Vehicle NO: ${test.vehicleNo}'),
              const SizedBox(height: 8),
              Text('Test Route: ${test.route}'),
              const SizedBox(height: 8),
              Text('Start: ${test.startTime}'),
              const SizedBox(height: 8),
              Text('Finish: ${test.endTime}'),
              const SizedBox(height: 8),
              Text('Vehicle Type: ${vehicle.description}'),
              const SizedBox(height: 8),
              Text('Note: ${test.note}'),
              const SizedBox(height: 8),
              const Text('Remarks:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...List<Widget>.generate(remarks.length, (index) {
                final remark = remarks[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('- ${remark.text}'),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () async {
                var candidate = await _getConnectedUser();
                if(candidate != null){
                  GenerateTestPdf
                      .generatePdf(candidate, test)
                      .then((value){
                    setState(() {
                      isDownloading = false;
                    });
                    Navigator.pop(context);
                  }).catchError((onError) {
                    setState(() {
                      isDownloading = false;
                    });
                    Navigator.pop(context);
                  });
                }else{
                  Helper.scaffoldMessenger(context, "Error, retry later");
                }
              },
              child: const Text(
                'Export as pdf',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test list'),
        leading: IconButton(onPressed: (){
          if (kDebugMode) {
            print("Logout");
          }
          FirebaseAuth.instance.signOut();
          boxCandidates.clear();
          boxAuthInfo.clear();
        }, icon: const Icon(Icons.logout, color: Colors.red,)),
      ),
      body: isLoading ?
      const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(strokeWidth: 8,),)) :
      RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await _fetchTests();
        },
        child: _tests.isEmpty ?
        Center(
            child: InkWell(
              onTap: () async {
                await _fetchTests();
              },
              child: const Text('No test yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )) :
        ListView.builder(
          itemCount: _tests.length,
          itemBuilder: (context, index) {
            final test = _tests[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text('Test Date: ${test.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: test.remarks.length > AppData.maxNumberOfRemarksForLoosing ? const Icon(Icons.remove_circle_sharp, color: Colors.redAccent,) : const Icon(Icons.check_circle, color: Colors.green,),
                onTap: () => _showTestDetails(context, test.testId, test.vehicleId),
              ),
            );
          },
        ),
      ),
    );
  }
}
