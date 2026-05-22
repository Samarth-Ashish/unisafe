import 'package:flutter/material.dart';
import 'package:flutter_unisafe/models/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedbackPage extends StatefulWidget {
  final ValueNotifier userCredential;
  const FeedbackPage({super.key, required this.userCredential});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final Email email = Email(
        body:
            'Feedback:\n ${_feedbackController.text} \n\n- Contact email: ${_emailController.text}\n- Contact number: ${_phoneController.text}',
        subject:
            'Feedback by ${_nameController.text}', //- (${widget.userCredential.value.user!.email!.toString()})',
        recipients: ['unisafelpu@gmail.com'],
        // attachmentPaths: attachments,
        isHTML: false,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        print(error);
        platformResponse = error.toString();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(platformResponse),
        ),
      );
    }
  }

  // void send(String emailAddress) async {
  //   final Email email = Email(
  //     body: 'Hello World',
  //     subject: 'Testing email on flutter',
  //     recipients: [emailAddress],
  //     //cc: ['cc@example.com'],
  //     //bcc: ['bcc@example.com'],
  //     //attachmentPaths: ['/path/to/attachment.zip'],
  //     isHTML: false,
  //   );
  // }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().isDark
            ? Colors.grey.shade900
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 5,
              ),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\+?1?\d{9,15}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _feedbackController,
                label: 'Feedback',
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _submitFeedback,
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.watch<ThemeProvider>().isDark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
