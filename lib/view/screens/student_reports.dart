//get_reports_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/core/theme_provider.dart';
import 'package:provider/provider.dart';

class StudentReportPage extends StatefulWidget {
  final int block;
  const StudentReportPage({super.key, required this.block});

  @override
  State<StudentReportPage> createState() => _StudentReportPageState();
}

class _StudentReportPageState extends State<StudentReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, backgroundColor: Colors.orange.withValues(alpha: 0.7), title: const Text('Student Reports')),
      body: StreamBuilder<QuerySnapshot>(
        // stream: FirebaseFirestore.instance.collection('reports').snapshots(),
        stream: (widget.block == 0)
            ? FirebaseFirestore.instance
                  .collection('reports')
                  .where('decisionPending', isEqualTo: true)
                  .orderBy('submittedAt', descending: true)
                  .snapshots()
            : FirebaseFirestore.instance
                  .collection('reports')
                  .where('block', isEqualTo: widget.block)
                  .where('decisionPending', isEqualTo: true)
                  .orderBy('submittedAt', descending: true)
                  .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reports found'));
          }

          // debugPrint('FETCHED-----');

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var report = snapshot.data!.docs[index];
              var data = report.data() as Map<String, dynamic>;
              List<String> bullyingTypes = _getBullyingTypes(data);
              Timestamp? submittedAt = data['submittedAt'];

              return Card(
                // color: Colors.grey.shade800,
                margin: const EdgeInsets.all(10),
                elevation: 8,
                shadowColor: Colors.orange.withValues(alpha: 0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Name', data['name']),
                      _buildInfoRow('Email', data['email']),
                      _buildInfoRow('Registration ID', data['registrationId']),
                      _buildInfoRow('Incident', data['reportIncident']),
                      _buildInfoRow('Bullying Type', bullyingTypes.join(', ')),
                      _buildInfoRow('Block', data['block']),
                      submittedAt != null ? _buildInfoRow('Submitted At', _formatTimestamp(submittedAt)) : Container(),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              context.watch<ThemeProvider>().isDark ? Colors.purple.shade900 : Colors.purple.shade100,
                            ),
                          ),
                          child: const Text('Resolve'),
                          // style: ElevatedButton.styleFrom(
                          //   primary: Colors.green, // Background color
                          // ),
                          onPressed: () async {
                            debugPrint("Resolved ${report.id.toString()}");
                            await FirebaseFirestore.instance.collection('reports').doc(report.id).update({'decisionPending': false});
                          },
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

  List<String> _getBullyingTypes(Map<String, dynamic> data) {
    List<String> types = [];
    if (data['physicalBullying'] == true) types.add('Physical');
    if (data['verbalBullying'] == true) types.add('Verbal');
    if (data['socialBullying'] == true) types.add('Social');
    if (data['cyberBullying'] == true) types.add('Cyber');
    return types.isEmpty ? ['No Bullying'] : types;
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
            color: context.watch<ThemeProvider>().isDark ? Colors.white : Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: value.toString(),
              style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
