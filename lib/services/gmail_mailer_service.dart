import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../emailConfig.dart';

class GmailMailerService {
  late SmtpServer smtpServer;

  MailerService(){
    smtpServer = gmail(EmailConfig.gmailEmail, EmailConfig.gmailPassword);
  }

  Future<void> sendTestResultEmail({
    required String candidateEmail,
    required String candidatePassword,
    required String subject,
    required String content
  }) async {

    final message = Message()
      ..from = Address(candidateEmail, 'Driving license manager')
      ..recipients.add(candidateEmail)
      ..subject = subject
      ..text = content;

    try {
      await send(message, smtpServer);
      if (kDebugMode) {
        print('Email successfully sent to $candidateEmail');
      }
    } catch (e) {
      if (kDebugMode) {
        print('"Error while sending the email" : $e');
      }
    }
  }

}
