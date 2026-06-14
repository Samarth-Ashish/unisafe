import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/pages/student/report_widgets.dart';
import 'package:unisafe/utils/user_helpers.dart';

class AllReportsPage extends StatefulWidget {
  final ValueNotifier<UserCredential?> userCredential;
  const AllReportsPage({super.key, required this.userCredential});

  @override
  State<AllReportsPage> createState() => _AllReportsPageState();
}

class _AllReportsPageState extends State<AllReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 115, 0).withValues(alpha: 0.7),
        centerTitle: true,
        title: const Text('All Reports'),
      ),
      body: _buildReportsStream(),
    );
  }

  Widget _buildReportsStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .where('reportedFromEmail', isEqualTo: getUserEmail(widget.userCredential.value))
          .orderBy('submittedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return buildReportCard(context, data);
            },
          );
        }
        return const Center(child: Text('No reports found'));
      },
    );
  }
}
