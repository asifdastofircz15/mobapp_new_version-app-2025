import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mob4/emailConfig.dart';

class MailerService {
  Future<String> sendEmail(
      {
        required String recipient,
        required String subject,
        required String body
      }) async {

    final url = Uri.parse('https://api.brevo.com/v3/smtp/email');
    final payload = {
      "name":"Campaign sent via the API",
      "sender": {"name": "License Driving App", "email": "driving.license2025@gmail.com"},
      "type":"classic",
      "to": [{"email": recipient}],
      "subject": subject,
      "htmlContent": body
    };
    final response = await http.post(
      url,
      headers: {
        'api-key': EmailConfig.emailApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    var message = "";
    if (response.statusCode == 200 || response.statusCode == 201) {
      message = "Email successfully sent to $recipient";
      if (kDebugMode) {
        print('Email successfully sent to $recipient');
      }
    } else {
      message = 'Error while sending the email';
      if (kDebugMode) {
        print('Error while sending the email');
        print(response.body);
        print(response.statusCode);
        print(response.reasonPhrase);
      }
    }
    return message;
  }
}
