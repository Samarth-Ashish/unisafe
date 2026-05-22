import 'package:flutter/material.dart';

class AdminObligationsPage extends StatelessWidget {
  const AdminObligationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final obligations = [
      'Ensure timely resolution of all student complaints.',
      'Maintain a record of all complaints and resolutions.',
      'Coordinate with relevant departments for complaint resolution.',
      'Provide feedback to students on the status of their complaints.',
      'Implement measures to prevent future occurrences of common complaints.',
      'Ensure confidentiality and privacy of student complaints.',
      'Provide training to staff on handling student complaints.',
      'Review and improve the complaint resolution process regularly.',
      'Ensure compliance with institutional policies and regulations.',
      'Report on complaint resolution status to higher authorities.',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Obligations'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: obligations.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              shadowColor: Colors.green.withOpacity(0.8),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                // title: Text(
                //   'Obligation ${index + 1}',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                subtitle: Text(obligations[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}


