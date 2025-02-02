import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/progress_circular.dart';

class Helper {

  static Widget progressBar() {
    return const ProgressIndicatorCircle();
  }

  static String handleFirebaseAuthException(FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case 'invalid-email':
        errorMessage = "The email address you entered is not valid.";
        break;
      case 'user-not-found':
        errorMessage = "No user found with this email address.";
        break;
      case 'too-many-requests':
        errorMessage = "Too many attempts. Please try again later.";
        break;
      case 'operation-not-allowed':
        errorMessage = "Password reset operation is not enabled.";
        break;
      case 'network-request-failed':
        errorMessage = "Request failed due to a network error.";
        break;
      default:
        errorMessage = "An unknown error occurred.";
    }


    return errorMessage;
  }

  static void showSignUpDialogBox(BuildContext context, String title, String content,
      {int type = 0}) {
    // flutter defined function
    showDialog<void>(
      context: context,
      barrierDismissible: type == 1 ? false : true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                child: const Text(
                  "Ok",
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
                onPressed: () {
                  type == 0 ?  Navigator.pop(context):  Navigator.pop(context); //*clearSignUpData(context*//*);
                }),
          ],
        );
      },
    );
  }

  static void scaffoldMessenger(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}