import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/user_info_extensions.dart';
import 'package:unisafe/model/report_model.dart';
import 'package:unisafe/service/report_service.dart';
import 'package:unisafe/view_model/report_viewmodel.dart';

class StudentSettingsPage extends StatelessWidget {
  const StudentSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ReportViewModel(ReportService()), child: const _StudentSettingsView());
  }
}

class _StudentSettingsView extends StatelessWidget {
  const _StudentSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.withValues(alpha: 0.7), centerTitle: true, title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.orange),
              title: const Text('Delete a report', style: TextStyle(fontSize: 18)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () => _showDeleteSpecificReportDialog(context),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.orange),
              title: const Text('Delete All Reports', style: TextStyle(fontSize: 18)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () => _showDeleteAllReportsDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteSpecificReportDialog(BuildContext context) {
    final userEmail = context.read<AuthSession>().user.emailOrEmpty;
    final vm = context.read<ReportViewModel>();

    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<List<Report>>(
        future: vm.getUserReports(userEmail).first,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data ?? [];
          if (reports.isEmpty) {
            return AlertDialog(
              title: const Text('Delete a report'),
              content: const Text('No reports found.'),
              actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
            );
          }

          String? selectedReportId;
          return StatefulBuilder(
            builder: (ctx, setState) => AlertDialog(
              title: const Text('Delete a report'),
              content: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Select Report'),
                items: reports
                    .map(
                      (r) => DropdownMenuItem(
                        value: r.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.reportDescription, overflow: TextOverflow.visible),
                            Divider(color: Colors.grey.withValues(alpha: 0.2)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                selectedItemBuilder: (_) => reports.map<Widget>((r) => Text(r.reportDescription, overflow: TextOverflow.ellipsis)).toList(),
                onChanged: (v) => setState(() => selectedReportId = v),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                TextButton(
                  onPressed: () async {
                    if (selectedReportId != null) {
                      Navigator.of(ctx).pop();
                      final ok = await vm.deleteReport(selectedReportId!);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Report deleted' : (vm.error ?? 'Failed'))));
                      }
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteAllReportsDialog(BuildContext context) {
    final userEmail = context.read<AuthSession>().user.emailOrEmpty;
    final vm = context.read<ReportViewModel>();

    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<List<Report>>(
        future: vm.getUserReports(userEmail).first,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data ?? [];
          if (reports.isEmpty) {
            return AlertDialog(
              title: const Text('Delete All Reports'),
              content: const Text('No reports found.'),
              actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
            );
          }
          return AlertDialog(
            title: const Text('Delete All Reports'),
            content: const Text('Are you sure you want to delete all your reports? This action cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final ok = await vm.deleteAllUserReports(userEmail);
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(ok ? 'All reports deleted' : (vm.error ?? 'Failed'))));
                  }
                },
                child: const Text('Delete All'),
              ),
            ],
          );
        },
      ),
    );
  }
}
