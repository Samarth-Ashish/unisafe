import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/view/widgets/report_widgets.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/user_info_extensions.dart';

class RecentReportsPage extends StatefulWidget {
  const RecentReportsPage({super.key});

  @override
  State<RecentReportsPage> createState() => _RecentReportsPageState();
}

class _RecentReportsPageState extends State<RecentReportsPage> {
  String _formatTimestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTimestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) {
      hour = 12;
    }

    String formattedHour = hour.toString().padLeft(2, '0');
    String formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = context.watch<AuthSession>().user.emailOrEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 115, 0).withValues(alpha: 0.7),
        centerTitle: true,
        title: const Text('Recent Reports'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('reportedFromEmail', isEqualTo: userEmail)
            .orderBy('submittedAt', descending: true)
            .limit(1) // Get only the first document (latest)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final reportData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
            return reportData.isNotEmpty ? buildReportCard(context, reportData) : const Center(child: Text('No reports found'));
          }

          return const Center(child: Text('No reports found'));
        },
      ),
    );
  }
}
