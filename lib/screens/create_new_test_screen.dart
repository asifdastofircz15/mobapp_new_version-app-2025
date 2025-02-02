import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mob4/models/personal_info.dart';
import 'package:mob4/models/test_models.dart';
import 'package:mob4/services/firestore_service.dart';
import 'package:mob4/utils/FormValidator.dart';
import 'package:mob4/utils/app_data.dart';
import 'package:mob4/utils/box_config.dart';
import 'package:mob4/utils/helpers.dart';

import '../emailConfig.dart';
import '../models/candidate.dart';
import '../services/mailer_service.dart';

class FormPage extends StatefulWidget {
  String candidateId;
  FormPage({required this.candidateId, super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DRIVING TEST REPORT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MyForm(candidateId: widget.candidateId),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  String candidateId;
  MyForm({required this.candidateId, super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final boxCandidates = Hive.box<Candidate>(BoxName.boxCandidates);
  final boxTests = Hive.box<Test>(BoxName.boxTests);
  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);

  final _textNoController = TextEditingController();
  final _examinerController = TextEditingController();
  final _dateController = TextEditingController();
  final _candidateController = TextEditingController();
  final startTimeController = TextEditingController();
  final _licenceController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _noteController = TextEditingController();
  int? _selectedVehicleId;

  List<Vehicle> vehicles = [];
  int selectedRemarksCount = 0;
  List<int> selectedRemarkIds = [];
  Candidate? examiner;
  String examinerName = "";
  String? _selectedRoute;
  late Candidate selectedCandidate;
  late bool isLoading;

  final List<String> routes = [
    'Route 1',
    'Route 2',
    'Route 3',
    'Route 4',
    'Route 5',
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
    _loadSelectedCandidate();
    _loadVehicles();
    _loadExaminer();
  }

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      String testNo = _textNoController.text;
      String date = _dateController.text;
      String time = startTimeController.text;
      String licenceNo = _licenceController.text;
      String vehicleNo = _vehicleController.text;
      String candidateId = selectedCandidate.email;
      String examinerId = boxAuthInfo.values.first.uid;
      String note = _noteController.text;
      int vehicleId = _selectedVehicleId ?? 0;

      var now = DateTime.now();
      var endTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      Test test = Test(
        testId: testNo,
        examinerId: examinerId,
        candidateId: candidateId,
        date: date,
        route: _selectedRoute!,
        startTime: time,
        endTime: endTime,
        testNo: testNo,
        licenceNo: licenceNo,
        vehicleNo: vehicleNo,
        vehicleId: vehicleId,
        remarks: selectedRemarkIds,
        note: note
      );

      if (kDebugMode) {
        print('Test instance created:');
        print('Examiner ID: ${test.examinerId}');
        print('Candidate ID: ${test.candidateId}');
        print('Date: ${test.date}');
        print('Route: ${test.route.toString()}');
        print('Start Time: ${test.startTime}');
        print('End Time: ${test.endTime}');
        print('Test No: ${test.testNo}');
        print('Licence No: ${test.licenceNo}');
        print('Vehicle No: ${test.vehicleNo}');
        print('Vehicle ID: ${test.vehicleId}');
        print('Note: ${test.note}');
        print('selectedRemarkIds: [${test.remarks.join(",")}]');
      }

      UserService().addTestToFirestore(test).then((response) async {
        if(response.success){
          boxTests.put(test.testId, test);

          await MailerService().sendEmail(
              recipient: selectedCandidate.email,
              subject: EmailConfig.testAvailable,
              body: EmailConfig.contentMailTestCreated
          ).then((message) {
            setState(() {
              isLoading = false;
            });
            Helper.scaffoldMessenger(context, message);
            Navigator.pop(context);
          }).catchError((message){
            setState(() {
              isLoading = false;
            });
            Helper.scaffoldMessenger(context, message);
            if (kDebugMode) {
              print("Error with MailerService: $message");
            }
            Navigator.pop(context);
          });

        }else{
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Issue"),
              content: Text("${response.message}"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }).catchError((onError){
        setState(() {
          isLoading = false;
        });
        if (kDebugMode) {
          print(onError);
        }
      });
    }
  }

  Future<void> _loadExaminer() async {
    var email = boxAuthInfo.values.first.email;
    examiner = await UserService().getUserById(email!);

    if (examiner != null){
      examinerName = "${examiner!.lastName} ${examiner!.otherNames}";
      _examinerController.text = examinerName;

      var now = DateTime.now();
      startTimeController.text = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      _dateController.text = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _loadSelectedCandidate() async {
    var candidate = boxCandidates.values.where((element) => element.email == widget.candidateId).first;
    _candidateController.text = "${candidate.lastName} ${candidate.otherNames}";
    setState(() {
      selectedCandidate = candidate;
    });
  }

  void _loadVehicles() {
    setState(() {
      vehicles = [
        {'vehicle_id': 1, 'description': 'Car'},
        {'vehicle_id': 2, 'description': 'Motorbike'},
      ].map((vehicle) => Vehicle.fromMap(vehicle)).toList();
    });
  }

  void _navigateToRemarksSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemarksSelectionPage(selectedRemarkIds: selectedRemarkIds),
      ),
    );

    if (result != null) {
      setState(() {
        selectedRemarkIds = result;
        selectedRemarksCount = selectedRemarkIds.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _textNoController,
                    decoration: const InputDecoration(labelText: 'Test NO:'),
                    keyboardType: TextInputType.number,
                    validator: FormValidator.validateTestNo,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'DATE'),
                    readOnly: true,
                    enabled: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _dateController.text = date.toString().split(' ')[0];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: startTimeController,
                    decoration: const InputDecoration(labelText: 'Test Start Time'),
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          startTimeController.text = time.format(context);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Route'),
                    value: _selectedRoute,
                    icon: Container(), // Removes the default dropdown arrow
                    items: routes.map((route) {
                      return DropdownMenuItem<String>(
                        value: route,
                        child: Text(route),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRoute = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a route';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Name of Candidate',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[300]),
                    controller: _candidateController,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _licenceController,
                    decoration: const InputDecoration(labelText: 'Licence NO:'),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(labelText: 'Vehicle NO:'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Type Of Vehicle'),
                    value: _selectedVehicleId,
                    icon: Container(), // Removes the default dropdown arrow
                    items: vehicles.map((vehicle) {
                      return DropdownMenuItem<int>(
                        value: vehicle.vehicleId,
                        child: Text(vehicle.description),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicleId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a vehicle';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Name Of Examiner',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[300]),
                    controller: _examinerController,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                        labelText: 'Examiner note:',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _navigateToRemarksSelection(context),
                        child: Text('Remarks ($selectedRemarksCount)'),
                      ),
                      const SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: isLoading ? null : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _submitForm();
                          }
                        },
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(isLoading)...[
                              const SizedBox(
                                width: 8,  // width of the indicator
                                height: 8, // height of the indicator
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                ),
                              )
                            ],
                            const SizedBox(width: 10,),
                            const Text('Submit'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}

class RemarksSelectionPage extends StatefulWidget {
  final List<int> selectedRemarkIds;

  const RemarksSelectionPage({super.key, required this.selectedRemarkIds});

  @override
  _RemarksSelectionPageState createState() => _RemarksSelectionPageState();
}

class _RemarksSelectionPageState extends State<RemarksSelectionPage> {
  List<Remark> remarks = AppData.remarks;
  List<int> selectedIds = [];

  @override
  void initState() {
    super.initState();
    selectedIds = List.from(widget.selectedRemarkIds);
    _loadRemarks();
  }
  // final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _loadRemarks() async {
    setState(() {
      remarks = AppData.remarks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Remarks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: remarks.length,
                itemBuilder: (context, index) {
                  final remark = remarks[index];
                  return CheckboxListTile(
                    title: Text(remark.text),
                    value: selectedIds.contains(remark.remarkId),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedIds.add(remark.remarkId);
                        } else {
                          selectedIds.remove(remark.remarkId);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedIds);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}





