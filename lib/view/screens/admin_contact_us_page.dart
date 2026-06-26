import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminContactUsPage extends StatefulWidget {
  const AdminContactUsPage({super.key});

  @override
  State<AdminContactUsPage> createState() => _AdminContactUsPageState();
}

class _AdminContactUsPageState extends State<AdminContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us'), backgroundColor: Colors.orange.withValues(alpha: 0.7), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('We would love to hear from you!'),
            const SizedBox(height: 20),
            _buildContactRow(icon: Icons.email, label: 'Email: unisafelpu@gmail.com', copyText: 'unisafelpu@gmail.com'),
            const SizedBox(height: 20),
            _buildContactRow(icon: Icons.phone, label: 'Phone: +91 7699944765', copyText: '+91 7699944765'),
            const SizedBox(height: 40),
            _buildHeader('Address:'),
            const SizedBox(height: 10),
            _buildAddressText('Lovely Professional University\nPhagwara, Punjab\nIndia'),
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

  Widget _buildContactRow({required IconData icon, required String label, required String copyText}) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: copyText));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 18), overflow: TextOverflow.visible),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: Colors.blue),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copyText));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressText(String text) {
    return Text(text, style: const TextStyle(fontSize: 18));
  }
}
