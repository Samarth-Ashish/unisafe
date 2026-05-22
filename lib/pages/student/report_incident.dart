import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_unisafe/models/theme_provider.dart';
import 'package:provider/provider.dart';

class FileReportPage extends StatefulWidget {
  final ValueNotifier userCredential;
  const FileReportPage({super.key, required this.userCredential});

  @override
  State<FileReportPage> createState() => _FileReportPageState();
}

class _FileReportPageState extends State<FileReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  final TextEditingController _registrationIdController =
      TextEditingController();
  bool _physicalBully = false;
  bool _verbalBully = false;
  bool _cyberBully = false;
  bool _socialBully = false;
  int? _block;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _reportController.dispose();
    _registrationIdController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<int>> get _dropDownItems {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 1; i <= 56; i++) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text('Block $i'),
        ),
      );
    }
    return items;
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'reportedFromEmail':
            widget.userCredential.value.user!.email!.toString(),
        'name': _nameController.text,
        'email': _emailController.text,
        'reportIncident': _reportController.text,
        'registrationId': _registrationIdController.text,
        'physicalBullying': _physicalBully,
        'verbalBullying': _verbalBully,
        'cyberBullying': _cyberBully,
        'socialBullying': _socialBully,
        'decisionPending': true,
        'block': _block,
        'submittedAt': Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance.collection('reports').add(data);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report submitted successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit report: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange.withOpacity(0.7),
        title: const Text('Report Incident'),
      ),
      body: Container(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8),

        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      _buildTextField(
                        controller: _registrationIdController,
                        label: 'Registration ID',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the registration ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          String pattern =
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _reportController,
                        label: 'Report Incident',
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the incident details';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownField(),
                      const SizedBox(height: 10),
                      _buildCheckboxListTile(
                        title: 'Physical Bullying',
                        value: _physicalBully,
                        onChanged: (bool? value) {
                          setState(() {
                            _physicalBully = value!;
                          });
                        },
                      ),
                      _buildCheckboxListTile(
                        title: 'Verbal Bullying',
                        value: _verbalBully,
                        onChanged: (bool? value) {
                          setState(() {
                            _verbalBully = value!;
                          });
                        },
                      ),
                      _buildCheckboxListTile(
                        title: 'Cyber Bullying',
                        value: _cyberBully,
                        onChanged: (bool? value) {
                          setState(() {
                            _cyberBully = value!;
                          });
                        },
                      ),
                      _buildCheckboxListTile(
                        title: 'Social Bullying',
                        value: _socialBully,
                        onChanged: (bool? value) {
                          setState(() {
                            _socialBully = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                      Colors.deepOrange.withOpacity(0.8),
                    )),
                    onPressed: _submitReport,
                    child: Text(
                      'Save & Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.watch<ThemeProvider>().isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                      Colors.deepOrange.withOpacity(0.8),
                    )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.watch<ThemeProvider>().isDark
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
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

  Widget _buildDropdownField() {
    return Container(
      // margin: const EdgeInsets.only(bottom: 4),
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
      child: DropdownButtonFormField<int>(
        initialValue: _block,
        items: _dropDownItems,
        onChanged: (int? value) {
          setState(() {
            _block = value!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Block',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(10.0),
        ),
        validator: (value) {
          if (value == null) {
            return 'Please select a block';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCheckboxListTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
