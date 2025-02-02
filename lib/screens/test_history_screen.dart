import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mob4/screens/create_new_test_screen.dart';
import 'package:mob4/utils/app_data.dart';
import 'package:mob4/utils/helpers.dart';
import '../models/candidate.dart';
import '../models/personal_info.dart';
import '../models/test_models.dart';
import '../services/firestore_service.dart';
import '../services/pdf_generator.dart';
import '../utils/box_config.dart';

class TestDetailsPage extends StatefulWidget {
  final String candidateId;

  const TestDetailsPage({super.key, required this.candidateId});

  @override
  State<TestDetailsPage> createState() => _TestDetailsPageState();
}

class _TestDetailsPageState extends State<TestDetailsPage> {
  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);
  final boxCandidates = Hive.box<Candidate>(BoxName.boxCandidates);
  final boxTests = Hive.box<Test>(BoxName.boxTests);
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  late bool canTakeANewTest = true;
  late List<Test> tests = [];

  final List<Vehicle> _vehicles = AppData.vehicles;
  final List<Remark> _remarks = AppData.remarks;

  late bool isLoading = false;
  late bool isDownloading = false;

  Vehicle? _fetchVehicle(int vehicleId) {
    return _vehicles.firstWhere((vehicle) => vehicle.vehicleId == vehicleId);
  }

  @override
  void initState() {
    super.initState();

    List<Test> listTest = [];
    bool localCanTakeANewTest = true;

    if (kDebugMode) {
      print("ID: ${widget.candidateId}");
    }

    for(var item in boxTests.values){
      if(item.candidateId == widget.candidateId){
        listTest.add(item);
        if(item.remarks.length <= AppData.maxNumberOfRemarksForLoosing){
          localCanTakeANewTest = false; //Test passed
        }
      }
    }

    setState(() {
      isLoading = false;
      canTakeANewTest = localCanTakeANewTest;
      tests = listTest.isNotEmpty ? [...listTest] : [];
    });

  }

  void _showTestDetails(BuildContext context, String testId) {
    final test = tests.firstWhere((test) => test.testId == testId);
    final remarks = _remarks.where((remark) => test.remarks.contains(remark.remarkId)).toList();

    final vehicle = _fetchVehicle(test.vehicleId);

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
              Text('Vehicle Type: ${vehicle?.description}'),
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
                var candidate = boxCandidates.values.firstWhere((element) => element.email == widget.candidateId);
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

  Future<void> refreshTestList() async {
    if(boxAuthInfo.isNotEmpty){
      var token = boxAuthInfo.values.first.idToken;
      if(token != null){
        UserService userService = UserService();
        if (kDebugMode) {
          print("Candidat: ${widget.candidateId}");
        }
        await userService.getTests(widget.candidateId).then((value) async {

          List<Test> iterable = [];
          for (var element in value) {
            Test test = Test.fromMap(element);
            iterable.add(test);

            if(test.remarks.length <= AppData.maxNumberOfRemarksForLoosing){
              setState(() {
                canTakeANewTest = false;
              });//Test passed
            }
          }

          setState(() {
            isLoading = false;
            tests = [...iterable];
          });

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Candidate? candidateUser = boxCandidates.values.where((element) => element.email == widget.candidateId).first;
    return Scaffold(
      appBar: AppBar(
        title: Text('Test History ${candidateUser.lastName} ${candidateUser.otherNames}'),
        actions: [
          IconButton(onPressed: (){
            if(canTakeANewTest){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormPage(candidateId: widget.candidateId),
                ),
              );
            }else{
              Helper.scaffoldMessenger(context, "This person has already passed the test.");
            }
          }, icon: Icon(Icons.add, color: canTakeANewTest ? Colors.green : Colors.grey.withOpacity(0.4),)),
        ],
      ),
      body: isLoading ?
          const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(strokeWidth: 8,),)) : RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await refreshTestList();
            },
            child: tests.isEmpty ?
              InkWell(
                  onTap: () async {
                    await refreshTestList();
                  },
                  child: const Center(
                      child: Text('No test yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))) :
            ListView.builder(
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Test Date: ${test.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: test.remarks.length > AppData.maxNumberOfRemarksForLoosing ? const Icon(Icons.remove_circle_sharp, color: Colors.redAccent,) : const Icon(Icons.check_circle, color: Colors.green,),
                      onTap: () => _showTestDetails(context, test.testId),
                    ),
                  );
                },
            ),
          ),
    );
  }
}
