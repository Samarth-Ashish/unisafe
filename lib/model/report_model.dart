import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String? id;
  final String reportedFromEmail;
  final String name;
  final String email;
  final String registrationId;
  final String reportDescription;
  final bool physicalBullying;
  final bool verbalBullying;
  final bool cyberBullying;
  final bool socialBullying;
  final bool decisionPending;
  final int? block;
  final DateTime submittedAt;

  Report({
    this.id,
    required this.reportedFromEmail,
    required this.name,
    required this.email,
    required this.registrationId,
    required this.reportDescription,
    required this.physicalBullying,
    required this.verbalBullying,
    required this.cyberBullying,
    required this.socialBullying,
    required this.decisionPending,
    required this.block,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reportedFromEmail': reportedFromEmail,
      'name': name,
      'email': email,
      'registrationId': registrationId,
      'reportIncident': reportDescription,
      'physicalBullying': physicalBullying,
      'verbalBullying': verbalBullying,
      'cyberBullying': cyberBullying,
      'socialBullying': socialBullying,
      'decisionPending': decisionPending,
      'block': block,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map, {String? id}) {
    return Report(
      id: id,
      reportedFromEmail: map['reportedFromEmail'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      registrationId: map['registrationId'] ?? '',
      reportDescription: map['reportIncident'] ?? '',
      physicalBullying: map['physicalBullying'] ?? false,
      verbalBullying: map['verbalBullying'] ?? false,
      cyberBullying: map['cyberBullying'] ?? false,
      socialBullying: map['socialBullying'] ?? false,
      decisionPending: map['decisionPending'] ?? true,
      block: map['block'],
      submittedAt: (map['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory Report.fromFirestore(DocumentSnapshot doc) {
    return Report.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
  }

  Report copyWith({
    String? id,
    String? reportedFromEmail,
    String? name,
    String? email,
    String? registrationId,
    String? reportDescription,
    bool? physicalBullying,
    bool? verbalBullying,
    bool? cyberBullying,
    bool? socialBullying,
    bool? decisionPending,
    int? block,
    DateTime? submittedAt,
  }) {
    return Report(
      id: id ?? this.id,
      reportedFromEmail: reportedFromEmail ?? this.reportedFromEmail,
      name: name ?? this.name,
      email: email ?? this.email,
      registrationId: registrationId ?? this.registrationId,
      reportDescription: reportDescription ?? this.reportDescription,
      physicalBullying: physicalBullying ?? this.physicalBullying,
      verbalBullying: verbalBullying ?? this.verbalBullying,
      cyberBullying: cyberBullying ?? this.cyberBullying,
      socialBullying: socialBullying ?? this.socialBullying,
      decisionPending: decisionPending ?? this.decisionPending,
      block: block ?? this.block,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}
