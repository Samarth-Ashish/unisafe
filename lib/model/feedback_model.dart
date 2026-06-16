import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String feedbackText;
  final DateTime? submittedAt;

  Feedback({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.feedbackText,
    this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'feedbackText': feedbackText,
      'submittedAt': submittedAt != null ? Timestamp.fromDate(submittedAt!) : FieldValue.serverTimestamp(),
    };
  }

  factory Feedback.fromMap(Map<String, dynamic> map, {String? id}) {
    return Feedback(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      feedbackText: map['feedbackText'] ?? '',
      submittedAt: (map['submittedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Feedback.fromFirestore(DocumentSnapshot doc) {
    return Feedback.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
  }

  Feedback copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? feedbackText,
    DateTime? submittedAt,
  }) {
    return Feedback(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      feedbackText: feedbackText ?? this.feedbackText,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}
