import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/user_info_extensions.dart';

class StudentSettingsPage extends StatefulWidget {
  const StudentSettingsPage({super.key});

  @override
  State<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.withValues(alpha: 0.7), centerTitle: true, title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Account Settings'),
            const SizedBox(height: 20),
            _buildSettingOption(
              context,
              icon: Icons.delete,
              label: 'Delete a report',
              onTap: () => _showDeleteSpecificReportDialog(context),
            ),
            const SizedBox(height: 20),
            _buildSettingOption(
              context,
              icon: Icons.delete_forever,
              label: 'Delete All Reports',
              onTap: () => _showDeleteAllReportsDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
    );
  }

  Widget _buildSettingOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(label, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUserReports() async {
    final userEmail = context.read<AuthSession>().user.emailOrEmpty;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('reportedFromEmail', isEqualTo: userEmail)
        .orderBy('submittedAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  void _showDeleteSpecificReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchUserReports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return AlertDialog(
                title: const Text('Delete a report'),
                content: const Text('No reports found.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }

            List<Map<String, dynamic>> userReports = snapshot.data!;
            String? selectedReportId;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Delete a report'),
                  content: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Select Report'),
                    items: userReports.map((report) {
                      return DropdownMenuItem<String>(
                        value: report['id'],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(report['reportIncident'], overflow: TextOverflow.visible),
                            Divider(color: Colors.grey.withValues(alpha: 0.2)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReportId = value;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return userReports.map<Widget>((report) {
                        return Text(report['reportIncident'], overflow: TextOverflow.ellipsis);
                      }).toList();
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () async {
                        if (selectedReportId != null) {
                          await FirebaseFirestore.instance.collection('reports').doc(selectedReportId).delete();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report deleted')));
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteAllReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchUserReports(),
          builder: (context, snapshot) {
            //
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return AlertDialog(
                title: const Text('Delete All Reports'),
                content: const Text('No reports found.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }

            return AlertDialog(
              title: const Text('Delete All Reports'),
              content: const Text('Are you sure you want to delete all your reports? This action cannot be undone.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Delete All'),
                  onPressed: () async {
                    final userEmail = context.read<AuthSession>().user.emailOrEmpty;
                    QuerySnapshot reportsSnapshot = await FirebaseFirestore.instance
                        .collection('reports')
                        .where('reportedFromEmail', isEqualTo: userEmail)
                        .orderBy('submittedAt', descending: true)
                        .get();
                    for (DocumentSnapshot doc in reportsSnapshot.docs) {
                      await FirebaseFirestore.instance.collection('reports').doc(doc.id).delete();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All reports deleted')));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
