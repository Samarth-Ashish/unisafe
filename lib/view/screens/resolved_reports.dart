import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/user_info_extensions.dart';
import 'package:unisafe/model/report_model.dart';
import 'package:unisafe/service/report_service.dart';
import 'package:unisafe/view/widgets/report_widgets.dart';
import 'package:unisafe/view_model/report_viewmodel.dart';

class ResolvedReportsPage extends StatelessWidget {
  const ResolvedReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ReportViewModel(ReportService()), child: const _ResolvedReportsView());
  }
}

class _ResolvedReportsView extends StatelessWidget {
  const _ResolvedReportsView();

  @override
  Widget build(BuildContext context) {
    final userEmail = context.watch<AuthSession>().user.emailOrEmpty;
    final vm = context.read<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(centerTitle: true, backgroundColor: Colors.deepOrange.withValues(alpha: 0.7), title: const Text('Resolved Reports')),
      body: StreamBuilder<List<Report>>(
        stream: vm.getResolvedReports(userEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final reports = snapshot.data ?? [];
          if (reports.isEmpty) return const Center(child: Text('No resolved reports found'));
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) => buildReportCard(context, reports[index].toMap()),
          );
        },
      ),
    );
  }
}
