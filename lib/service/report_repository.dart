import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/model/report_model.dart';
import 'base_repository.dart';

class ReportRepository extends BaseRepository<Report> {
  ReportRepository({FirebaseFirestore? firestore})
      : super(
          firestore: firestore ?? FirebaseFirestore.instance,
          collectionName: 'reports',
        );

  Future<void> submitReport(Report report) async {
    await add(report.toMap());
  }

  Stream<List<Report>> getUserReportsStream(String userEmail) {
    return firestore
        .collection(collectionName)
        .where('reportedFromEmail', isEqualTo: userEmail)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());
  }

  Stream<List<Report>> getResolvedReportsStream(String userEmail) {
    return firestore
        .collection(collectionName)
        .where('reportedFromEmail', isEqualTo: userEmail)
        .where('decisionPending', isEqualTo: false)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());
  }

  Stream<List<Report>> getRecentReportsStream(String userEmail) {
    return firestore
        .collection(collectionName)
        .where('reportedFromEmail', isEqualTo: userEmail)
        .orderBy('submittedAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());
  }

  Stream<List<Report>> getPendingReportsStream({int? blockFilter}) {
    Query query = firestore.collection(collectionName).where('decisionPending', isEqualTo: true);

    if (blockFilter != null && blockFilter != 0) {
      query = query.where('block', isEqualTo: blockFilter);
    }

    return query.orderBy('submittedAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList(),
        );
  }

  @override
  Report fromFirestore(DocumentSnapshot doc) {
    return Report.fromFirestore(doc);
  }
}
