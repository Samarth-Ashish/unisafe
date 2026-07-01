import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/theme_provider.dart';
import 'package:unisafe/core/user_info_extensions.dart';
import 'package:unisafe/view_model/report_viewmodel.dart';

class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({super.key});

  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _reportController = TextEditingController();
  final _registrationIdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _reportController.dispose();
    _registrationIdController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<int>> get _dropDownItems => [
        for (int i = 1; i <= 56; i++)
          DropdownMenuItem(value: i, child: Text('Block $i')),
      ];

  Future<void> _submit(ReportViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await vm.submitReport(
      reportedFromEmail: context.read<AuthSession>().user.emailOrEmpty,
      name: _nameController.text,
      email: _emailController.text,
      registrationId: _registrationIdController.text,
      reportDescription: _reportController.text,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${vm.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange.withValues(alpha: 0.7),
        title: const Text('Report Incident'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      _buildTextField(
                        controller: _registrationIdController,
                        label: 'Registration ID',
                        keyboardType: TextInputType.number,
                        isDark: isDark,
                        validator: (v) => (v == null || v.isEmpty) ? 'Please enter the registration ID' : null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        keyboardType: TextInputType.text,
                        isDark: isDark,
                        validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter your email';
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(v)) {
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
                        isDark: isDark,
                        maxLines: 5,
                        validator: (v) => (v == null || v.isEmpty) ? 'Please enter the incident details' : null,
                      ),
                      const SizedBox(height: 10),
                      _buildDropdown(vm, isDark),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        title: const Text('Physical Bullying'),
                        value: vm.physicalBully,
                        onChanged: (v) => vm.toggleBully('physical', v!),
                      ),
                      CheckboxListTile(
                        title: const Text('Verbal Bullying'),
                        value: vm.verbalBully,
                        onChanged: (v) => vm.toggleBully('verbal', v!),
                      ),
                      CheckboxListTile(
                        title: const Text('Cyber Bullying'),
                        value: vm.cyberBully,
                        onChanged: (v) => vm.toggleBully('cyber', v!),
                      ),
                      CheckboxListTile(
                        title: const Text('Social Bullying'),
                        value: vm.socialBully,
                        onChanged: (v) => vm.toggleBully('social', v!),
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
                      backgroundColor: WidgetStateProperty.all(Colors.deepOrange.withValues(alpha: 0.8)),
                    ),
                    onPressed: vm.isLoading ? null : () => _submit(vm),
                    child: vm.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text('Save & Submit', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.deepOrange.withValues(alpha: 0.8)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
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
    required bool isDark,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.deepOrange.withValues(alpha: 0.3), spreadRadius: 3, blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdown(ReportViewModel vm, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.deepOrange.withValues(alpha: 0.3), spreadRadius: 3, blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: DropdownButtonFormField<int>(
        initialValue: vm.block,
        items: _dropDownItems,
        onChanged: (v) => vm.setBlock(v),
        decoration: InputDecoration(
          labelText: 'Block',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(10.0),
        ),
        validator: (v) => v == null ? 'Please select a block' : null,
      ),
    );
  }
}