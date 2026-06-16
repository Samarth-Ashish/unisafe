import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/user_info_extensions.dart';
import 'package:unisafe/service/admin_service.dart';
import 'package:unisafe/view_model/admin_viewmodel.dart';

class AdminManagementPage extends StatelessWidget {
  const AdminManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminViewModel(AdminService()),
      child: const _AdminManagementView(),
    );
  }
}

class _AdminManagementView extends StatefulWidget {
  const _AdminManagementView();

  @override
  State<_AdminManagementView> createState() => _AdminManagementViewState();
}

class _AdminManagementViewState extends State<_AdminManagementView> {
  late Future<Map<String, int>> _adminMapFuture;

  @override
  void initState() {
    super.initState();
    _adminMapFuture = context.read<AdminViewModel>().fetchAdminBlockMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.withValues(alpha: 0.7),
        centerTitle: true,
        title: const Text('Admin Management'),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _adminMapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No admins found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildAdminList(snapshot.data!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAdminDialog(context),
        tooltip: 'Add Admin',
        backgroundColor: Colors.purple.withValues(alpha: 0.7),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _refresh() {
    setState(() {
      _adminMapFuture = context.read<AdminViewModel>().fetchAdminBlockMap();
    });
  }

  void _showAddAdminDialog(BuildContext context) {
    String email = '';
    int block = 0;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Admin'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => email = v,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your email';
                  final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!regex.hasMatch(v)) return 'Please enter a valid email address';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Block',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => block = int.tryParse(v) ?? 0,
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter a block' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop();
                final vm = context.read<AdminViewModel>();
                final ok = await vm.addAdmin(email, block);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'Admin added successfully' : (vm.error ?? 'Failed'))),
                  );
                  if (ok) _refresh();
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this admin?'),
            Text('Email: $email', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final vm = context.read<AdminViewModel>();
      final ok = await vm.deleteAdmin(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ok ? 'Admin deleted successfully' : (vm.error ?? 'Failed'))),
        );
        if (ok) _refresh();
      }
    }
  }

  Widget _buildAdminList(Map<String, int> adminMap) {
    final currentUserEmail = context.watch<AuthSession>().user.emailOrEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Admins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: adminMap.entries
                .where((e) => e.key != currentUserEmail)
                .map((e) => Card(
                      elevation: 6,
                      shadowColor: Colors.purple.withValues(alpha: 0.8),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(e.key),
                        subtitle: Text('Block: ${e.value}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red.withValues(alpha: 0.8),
                          onPressed: () => _showDeleteConfirmationDialog(e.key),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}