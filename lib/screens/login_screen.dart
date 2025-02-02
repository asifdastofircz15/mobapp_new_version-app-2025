import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mob4/screens/reset_password_screen.dart';
import 'package:mob4/services/firestore_service.dart';
import 'package:mob4/utils/box_config.dart';
import 'package:mob4/utils/helpers.dart';
import '../models/credential.dart';
import '../models/personal_info.dart';
import 'home_screen.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);
  final boxAuthCredential = Hive.box<AuthCredentialModel>(BoxName.boxAuthCredential);
  bool isLoading = false;

  Future<User?> _candidateLogin(BuildContext context,String email,String password) async {

    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    UserCredential authResult = await _auth.signInWithCredential(credential);
    //
    // setState(() {
    //   isLoading = false;
    // });
    //
    // _user = authResult.user!;
    // assert(!_user.isAnonymous);
    // assert(await _user.getIdToken() != null);
    // User? currentUser = _auth.currentUser;
    //
    // assert(_user.uid == currentUser?.uid);
    //
    // boxAuthCredential.put(_user.email, AuthCredentialModel.fromAuthCredential(credential));
    //
    // String? idToken = await _user.getIdToken();
    // String role = await UserService().getUserRole(_user.email!) ?? 'candidate';
    // var idRefresh = _user.refreshToken;
    //
    // var authInfo = AuthInfo(_user.email, idToken, idRefresh, DateTime.now(), role, _user.uid);
    // boxAuthInfo.put(_user.uid,authInfo);

    return authResult.user;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          User user = snapshot.data!;
          return HomePage(user);
        } else {
          return loginScreen();
        }
      }
    );
  }

  Widget loginScreen(){
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/images.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                          setState(() {
                            isLoading = true;
                          });

                          String email = _emailController.text;
                          String password = _passwordController.text;


                          if(email.isEmpty || password.isEmpty){
                            Helper.showSignUpDialogBox(context, "Alert", "Email and password are required");
                          }else{
                            _candidateLogin(context, email, password).then((User? user) async {

                              setState(() {
                                isLoading = false;
                              });

                              if(user == null){
                                Helper.showSignUpDialogBox(context, "Alert", "Email or password incorrect...");
                              }
                            }).catchError((onError) {
                              if (kDebugMode) {
                                print("Error $onError");
                              }
                              UserService().loginWithTemporaryPassword(email,password).then((existAnyWay){
                                if(existAnyWay){
                                  _auth.createUserWithEmailAndPassword(email: email, password: password).then((auth) async {

                                    setState(() {
                                      isLoading = false;
                                    });

                                    if(auth.user == null){
                                      Helper.showSignUpDialogBox(context, "Alert", "Email or password incorrect...");
                                    }else{
                                      var user = auth.user;
                                      await UserService().updateUserId(email, user!.uid);
                                    }
                                  }).catchError((onError){
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Helper.showSignUpDialogBox(context, "Alert", "Email or password incorrect.\n$onError");
                                  });
                                }else{
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Helper.showSignUpDialogBox(context, "Alert", "Email or password incorrect.");
                                }
                              }).catchError((onError){
                                setState(() {
                                  isLoading = false;
                                });
                                Helper.showSignUpDialogBox(context, "Alert", "Email or password incorrect.");
                              });

                            });
                          }
                        },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(isLoading)...[
                            const SizedBox(
                              width: 20,  // width of the indicator
                              height: 20, // height of the indicator
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                              ),
                            )
                          ],
                          const SizedBox(width: 10,),
                          const Text('Login'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Password forgot ?',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
