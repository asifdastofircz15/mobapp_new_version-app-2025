import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mob4/models/candidate.dart';
import 'package:mob4/models/credential.dart';
import 'package:mob4/models/test_models.dart';
import 'package:mob4/screens/home_screen.dart';
import 'package:mob4/utils/box_config.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'models/personal_info.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(AuthInfoAdapter());
  Hive.registerAdapter(AuthCredentialModelAdapter());
  Hive.registerAdapter(CandidateAdapter());
  Hive.registerAdapter(TestAdapter());
  Hive.registerAdapter(VehicleAdapter());
  Hive.registerAdapter(RemarkAdapter());

  await Hive.openBox<AuthInfo>(BoxName.boxAuthInfo);
  await Hive.openBox<AuthCredentialModel>(BoxName.boxAuthCredential);
  await Hive.openBox<Candidate>(BoxName.boxCandidates);

  await Hive.openBox<Test>(BoxName.boxTests);
  await Hive.openBox<Vehicle>(BoxName.boxVehicles);
  await Hive.openBox<Remark>(BoxName.boxRemarks);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);
  final boxCandidates = Hive.box<Candidate>(BoxName.boxCandidates);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MOB4',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.green,
              );
            } else if (snapshot.hasData) {
              return HomePage(snapshot.data!);
            } else {
              return const LoginPage();
            }
          }
      )
    );
  }
}
