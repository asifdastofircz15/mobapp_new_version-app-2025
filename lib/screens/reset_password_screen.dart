import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mob4/utils/box_config.dart';
import 'package:mob4/utils/helpers.dart';
import '../models/credential.dart';
import '../models/personal_info.dart';

class ResetPasswordScreen extends StatefulWidget{
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>{

  final GlobalKey<FormState> _userResetPasswordScreenFormKey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final boxAuthInfo = Hive.box<AuthInfo>(BoxName.boxAuthInfo);
  final boxAuthCredential = Hive.box<AuthCredentialModel>(BoxName.boxAuthCredential);

  bool isSignIn =false;
  bool google =false;

  late String emailTextField = "";

  final TextEditingController _emailCtrl = TextEditingController();

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: Stack(
        children: <Widget>[

          Container(
            height: height/2,
            width: width,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(1.0),
                bottomRight: Radius.circular(360),
              ),
            ),
          ),

          SingleChildScrollView(
            child:Column(
              children: <Widget>[
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white,),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: height/3,
                  width: width/3,
                ),

                Form(
                  key: _userResetPasswordScreenFormKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top:1.0,bottom:15,left: 10,right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text("Forgot password",style:TextStyle(fontWeight: FontWeight.w800,fontSize: 25),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:15.0,right: 14,left: 14,bottom: 8),
                            child: TextFormField(
                              controller: _emailCtrl,
                              style: const TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: 15),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius
                                      .all(
                                      Radius.circular(15)),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(fontSize: 15) ,
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              ),
                              cursorColor:Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value){
                                setState(() {
                                  emailTextField = value.toLowerCase();
                                });
                              },
                            ),),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: (emailTextField == "") ? (){} : () {

                              setState(() {
                                isLoading = true;
                              });

                              _auth.sendPasswordResetEmail(email: emailTextField).then((value){

                                setState(() {
                                  isLoading = false;
                                  emailTextField = "";
                                  _emailCtrl.text = "";
                                });

                                var message = "An email containing the link to reset your password will be sent to you if an account corresponding to this email exists.";
                                Helper.showSignUpDialogBox(context, "Success!", message);

                              }).catchError((error){

                                setState(() {
                                  isLoading = false;
                                });

                                if (kDebugMode) {
                                  print(error.message);
                                }

                                var message = Helper.handleFirebaseAuthException(error);
                                Helper.showSignUpDialogBox(context, "Error!", message);

                              });
                            },
                            child: Container(
                                width: width/2,
                                height: height/18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (emailTextField == "") ? Colors.grey : Colors.blueAccent
                                ),
                                child: const Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text('Submit',
                                          style: TextStyle(
                                              fontSize: 12*1.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                      ],
                                    )
                                )
                            ),
                          ),
                          const SizedBox(height: 16,),
                        ],),
                    ),),
                ),
              ],),
          ),

          isLoading
              ? Helper.progressBar()
              : Container(),
        ],
      ),

    );
  }

  Column backgroundContainer(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 3*height/5,
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(1.0),
              bottomRight: Radius.circular(360),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print("Exit");
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: width/2,
                    height: 50,
                    alignment: AlignmentDirectional.topStart,
                    decoration: const BoxDecoration(
                        color: Colors.deepOrange
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> signInWithEmailPassword() async {

    setState(() {
      isLoading = true;
    });



    setState(() {
      isLoading = true;
    });

  }

}
