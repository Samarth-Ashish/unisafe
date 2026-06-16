// tips.dart

import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange.withOpacity(0.7),
        title: const Text('Reporting Tips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTip('Choose Anonymity',
              'Users should opt for anonymity when reporting bullying incidents to ensure their identity remains confidential.'),
          _buildTip('Avoid Personal Details',
              'It is recommended to refrain from including any personal information, such as names or contact details, in the report to maintain anonymity.'),
          _buildTip('Use General Language',
              'Describe the incident using general language rather than specific details that could identify individuals involved.'),
          _buildTip('Protect Others',
              'Safeguard the anonymity of others by avoiding mention of their names or identifiable traits in the report.'),
          _buildTip('Use Secure Channels',
              'Utilize secure channels provided by the app to submit reports anonymously, ensuring the confidentiality of users\' information.'),
          _buildTip('Encrypt Communication',
              'Ensure that all communication between the user\'s device and the app\'s servers is encrypted to prevent unauthorized access to data.'),
          _buildTip('Trustworthy Platforms',
              'Users should only report bullying incidents through trusted and reputable platforms that prioritize user privacy and confidentiality.'),
          _buildTip('Verify Anonymity Features',
              'Before submitting a report, users should verify that the app\'s anonymity features are functional and reliable to protect their identity.'),
          _buildTip('Report Immediately',
              'Report bullying incidents promptly to prevent escalation while still maintaining anonymity.'),
          _buildTip('No Retaliation',
              'Users are advised not to retaliate against bullies or disclose their involvement in reports to maintain the integrity of the anonymous reporting process.'),
          _buildTip('Stay Informed',
              'Stay informed about the app\'s privacy policy and how user data is handled to ensure confidentiality at all times.'),
          _buildTip('Confidentiality Assurance',
              'Users should choose apps that provide assurance of confidentiality and outline clear policies for handling sensitive information.'),
          _buildTip('Encrypted Storage',
              'Ensure that any data stored by the app, including reports, is encrypted to protect it from unauthorized access.'),
          _buildTip('Regular Audits',
              'Opt for apps that undergo regular security audits to ensure compliance with privacy standards and maintain confidentiality.'),
          _buildTip('Feedback Mechanism',
              'Provide feedback to app developers regarding any concerns or issues related to anonymity and confidentiality to help improve the reporting process for all users.'),
        ],
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Card(
      elevation: 6, // Elevation for card shadow
      shadowColor: Colors.grey.shade700,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }
}
