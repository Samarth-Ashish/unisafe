import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String? selectedBlock;
  Map<String, String>? contacts;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange.withOpacity(0.7),
        title: const Text('Select Block'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('contacts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            Map<String, dynamic> data =
                snapshot.data!.docs[0].data() as Map<String, dynamic>;
            contacts =
                data.map((key, value) => MapEntry(key, value.toString()));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text(
                          'Select a Block',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        value: selectedBlock,
                        onChanged: (newValue) {
                          setState(() {
                            selectedBlock = newValue;
                            email = data[newValue!] ??
                                'No data found for Block $newValue';
                          });
                        },
                        items: List.generate(56, (index) {
                          String blockNumber = (index + 1).toString();
                          return DropdownMenuItem<String>(
                            value: blockNumber,
                            child: Text('Block $blockNumber'),
                          );
                        }),
                      ),
                    ),
                  ),
                  if (selectedBlock != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                        shadowColor: Colors.blue.shade700,
                        child: ListTile(
                          title: Text(
                            // 'Block $selectedBlock',

                            'HOD',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          subtitle: Text(
                            email!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          leading: const Icon(
                            Icons.location_city,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
            //
          }

          return const Center(
            child: Text('No data found'),
          );
        },
      ),
    );
  }
}
