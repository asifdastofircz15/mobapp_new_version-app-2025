import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../emailConfig.dart';
import '../models/candidate.dart';
import '../services/mailer_service.dart';
import '../utils/FormValidator.dart';
import '../utils/box_config.dart';
import '../utils/helpers.dart';

class CreateCandidatePage extends StatefulWidget {
  const CreateCandidatePage({super.key});

  @override
  _CreateCandidatePageState createState() => _CreateCandidatePageState();
}

class _CreateCandidatePageState extends State<CreateCandidatePage> {
  final _lastNameController = TextEditingController();
  final _otherNamesController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final boxCandidates = Hive.box<Candidate>(BoxName.boxCandidates);
  late bool isLoading;

  Future<void> _createAccount() async {
    setState(() {
      isLoading = true;
    });
    final lastName = _lastNameController.text.trim();
    final otherNames = _otherNamesController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nic = _nicController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();


    if (email.isEmpty || password.isEmpty || lastName.isEmpty || otherNames.isEmpty || nic.isEmpty || address.isEmpty || phone.isEmpty) {
      _showErrorDialog('Please fill all fields');
      return;
    }

    try {

      var uid = const Uuid().v4();

      _firestore.collection('users').doc(uid).set({
        'lastName': lastName,
        'otherNames': otherNames,
        'email': email,
        'temp_password': password,
        'nic': nic,
        'address': address,
        'phone': phone,
        'role': 'candidate'
      }).then((value) async {
        boxCandidates.put(uid,
            Candidate(
                id: uid,
                lastName: lastName,
                otherNames: otherNames,
                email: email,
                nic: nic,
                address: address,
                phone: phone,
                role: 'candidate'
            ));
            await MailerService().sendEmail(
                recipient: email,
                subject: EmailConfig.subjectAccountCreated,
                body: EmailConfig.contentMailAccountCreated(email, password)
            ).then((value) {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context);
            }).catchError((onError){
              setState(() {
                isLoading = false;
              });
              Helper.scaffoldMessenger(context, "Error with MailerService: $onError");
              if (kDebugMode) {
                print("Error with MailerService: $onError");
              }
              Navigator.pop(context);
            });
      }).catchError((onError){
        setState(() {
          isLoading = false;
        });
        Helper.scaffoldMessenger(context, onError ?? 'An error occurred');
      });

    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(e.message ?? 'An error occurred');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: FormValidator.validateName,
            ),
            TextFormField(
              controller: _otherNamesController,
              decoration: const InputDecoration(labelText: 'Other Names'),
              validator: FormValidator.validateName,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: FormValidator.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: FormValidator.validatePassword,
            ),
            TextFormField(
              controller: _nicController,
              decoration: const InputDecoration(labelText: 'NIC'),
              validator: FormValidator.validateNic,
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: FormValidator.validatePhone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAccount,
              child: Row(
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
                  const Text('Create Account'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
