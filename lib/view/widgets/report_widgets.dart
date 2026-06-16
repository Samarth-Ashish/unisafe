import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget buildReportCard(BuildContext context, Map<String, dynamic> reportData) {
  return GestureDetector(
    onTap: () {
      showReportDialog(context, reportData);
    },
    child: Card(
      elevation: 6,
      // color: Colors.grey.withOpacity(0.9),
      shadowColor: reportData['decisionPending'] ? Colors.red : Colors.green,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Incident :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text('${reportData['reportIncident']}'),
            )
          ],
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reportData['decisionPending'] ? 'Unresolved' : 'Resolved',
              style: TextStyle(
                color:
                    reportData['decisionPending'] ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Submitted At'),
            Text(formatTimestampToDate(reportData['submittedAt'])),
            Text(formatTimestampToTime(reportData['submittedAt'])),
          ],
        ),
      ),
    ),
  );
}

void showReportDialog(BuildContext context, Map<String, dynamic> reportData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 30,
        shadowColor: reportData['decisionPending']
            ? Colors.red.withOpacity(0.3)
            : Colors.green.withOpacity(0.3),
        title: const Text('Report Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              buildReportDetailRow('Incident', reportData['reportIncident'],
                  columnFormat: true),
              const SizedBox(
                height: 10,
              ),
              buildReportDetailRow('Physical Bullying',
                  reportData['physicalBullying'] ? "Yes" : "No"),
              buildReportDetailRow('Verbal Bullying',
                  reportData['verbalBullying'] ? "Yes" : "No"),
              buildReportDetailRow(
                  'Cyber Bullying', reportData['cyberBullying'] ? "Yes" : "No"),
              buildReportDetailRow('Social Bullying',
                  reportData['socialBullying'] ? "Yes" : "No"),
              const SizedBox(
                height: 10,
              ),
              buildReportDetailRow('Name', reportData['name']),
              buildReportDetailRow('Email', reportData['email']),
              buildReportDetailRow(
                  'Registration ID', reportData['registrationId']),
              buildReportDetailRow('Block', reportData['block'].toString()),
              const SizedBox(
                height: 10,
              ),
              buildStatusRow(
                  'Status',
                  reportData['decisionPending'] ? "Unresolved" : "Resolved",
                  reportData['decisionPending']),
              buildReportDetailRow('Submitted At',
                  '${formatTimestampToDate(reportData['submittedAt'])} ${formatTimestampToTime(reportData['submittedAt'])}',
                  columnFormat: true),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget buildReportDetailRow(String title, String detail,
    {bool columnFormat = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: columnFormat
        ? Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontSize: 16,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(
                    // fontSize: 16,
                    ),
                overflow: TextOverflow.visible,
              ),
            ],
          )
        : Row(
            children: [
              Text(
                '$title : ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontSize: 18,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(
                    // fontSize: 18,
                    ),
              )
            ],
          ),
  );
}

Widget buildStatusRow(String title, String status, bool isPending) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Text(
          '$title : ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            // color: isPending ? Colors.red : Colors.green,
          ),
        ),
        Text(
          isPending ? 'Unresolved' : 'Resolved',
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: isPending ? Colors.red : Colors.green,
          ),
        )
      ],
    ),
  );
}

String formatTimestampToDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

String formatTimestampToTime(Timestamp timestamp) {
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
