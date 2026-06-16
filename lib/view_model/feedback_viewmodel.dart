import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:unisafe/model/feedback_model.dart';
import 'package:unisafe/service/feedback_service.dart';

class FeedbackViewModel extends ChangeNotifier {
  final FeedbackService _service;

  FeedbackViewModel(this._service);

  bool isLoading = false;
  String? error;
  String? successMessage;

  Future<bool> submitFeedback({
    required String name,
    required String email,
    required String phone,
    required String feedbackText,
  }) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();

    try {
      // Send via email
      final emailMsg = Email(
        body: 'Feedback:\n $feedbackText \n\n- Contact email: $email\n- Contact number: $phone',
        subject: 'Feedback by $name',
        recipients: ['unisafelpu@gmail.com'],
        isHTML: false,
      );
      await FlutterEmailSender.send(emailMsg);

      // Also persist to Firestore
      await _service.submitFeedback(Feedback(
        name: name,
        email: email,
        phone: phone,
        feedbackText: feedbackText,
      ));

      successMessage = 'Feedback submitted successfully';
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}