import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailerService {
  final String username;
  final String password;

  MailerService({required this.username, required this.password});

  Future<void> sendEmail(String recipient, String subject, String text,
      List<String> attachments) async {
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Cabinet Medical')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = text
      ..attachments
          .addAll(attachments.map((path) => FileAttachment(File(path))));

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      Exception(e);
    }
  }
}
