import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/theme_provider.dart';
import 'package:unisafe/model/report_model.dart';
import 'package:unisafe/service/report_service.dart';
import 'package:unisafe/view_model/report_viewmodel.dart';

class StudentReportPage extends StatelessWidget {
  final int block;
  const StudentReportPage({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportViewModel(ReportService()),
      child: _StudentReportView(block: block),
    );
  }
}

class _StudentReportView extends StatelessWidget {
  final int block;
  const _StudentReportView({required this.block});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(centerTitle: true, backgroundColor: Colors.orange.withValues(alpha: 0.7), title: const Text('Student Reports')),
      body: StreamBuilder<List<Report>>(
        stream: vm.getPendingReports(blockFilter: block),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final reports = snapshot.data ?? [];
          if (reports.isEmpty) return const Center(child: Text('No reports found'));

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 8,
                shadowColor: Colors.orange.withValues(alpha: 0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(context, 'Name', report.name),
                      _buildInfoRow(context, 'Email', report.email),
                      _buildInfoRow(context, 'Registration ID', report.registrationId),
                      _buildInfoRow(context, 'Incident', report.reportDescription),
                      _buildInfoRow(context, 'Bullying Type', _getBullyingTypes(report).join(', ')),
                      _buildInfoRow(context, 'Block', report.block?.toString() ?? '-'),
                      _buildInfoRow(context, 'Submitted At', _formatDate(report.submittedAt)),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              context.watch<ThemeProvider>().isDark ? Colors.purple.shade900 : Colors.purple.shade100,
                            ),
                          ),
                          onPressed: () => context.read<ReportViewModel>().resolveReport(report.id!),
                          child: const Text('Resolve'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<String> _getBullyingTypes(Report r) {
    final types = <String>[];
    if (r.physicalBullying) types.add('Physical');
    if (r.verbalBullying) types.add('Verbal');
    if (r.socialBullying) types.add('Social');
    if (r.cyberBullying) types.add('Cyber');
    return types.isEmpty ? ['No Bullying'] : types;
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}';

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(fontSize: 16, color: context.watch<ThemeProvider>().isDark ? Colors.white : Colors.black),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
