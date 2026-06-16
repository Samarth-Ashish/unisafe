import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/model/report_model.dart';
import 'package:unisafe/service/report_repository.dart';
import 'firestore_service.dart';

/// Service layer for Report operations
/// Handles business logic and coordinates between UI and data layer
class ReportService extends FirestoreService {
  late final ReportRepository _repository;

  ReportService({FirebaseFirestore? firestore})
      : super(firestore: firestore) {
    _repository = ReportRepository(firestore: firestore);
  }

  /// Submit a new report
  Future<void> submitReport(Report report) async {
    return handleFirestoreCall(() => _repository.submitReport(report));
  }

  /// Get all reports for current user
  Stream<List<Report>> getUserReports(String userEmail) {
    return handleFirestoreStream(() => _repository.getUserReportsStream(userEmail));
  }

  /// Get resolved reports for current user
  Stream<List<Report>> getResolvedReports(String userEmail) {
    return handleFirestoreStream(() => _repository.getResolvedReportsStream(userEmail));
  }

  /// Get recent reports (limit 10)
  Stream<List<Report>> getRecentReports(String userEmail) {
    return handleFirestoreStream(() => _repository.getRecentReportsStream(userEmail));
  }

  /// Get pending reports for admin
  Stream<List<Report>> getPendingReports({int? blockFilter}) {
    return handleFirestoreStream(
      () => _repository.getPendingReportsStream(blockFilter: blockFilter),
    );
  }

  /// Update report decision status
  Future<void> updateReportStatus(String reportId, bool decisionPending) async {
    return handleFirestoreCall(() => _repository.update(
          reportId,
          {'decisionPending': decisionPending},
        ));
  }

  /// Get report count for a user
  Future<int> getUserReportCount(String userEmail) async {
    return handleFirestoreCall(() async {
      final query = await firestore
          .collection('reports')
          .where('reportedFromEmail', isEqualTo: userEmail)
          .count()
          .get();
      return query.count ?? 0;
    });
  }

  /// Get pending report count
  Future<int> getPendingReportCount({int? blockFilter}) async {
    return handleFirestoreCall(() async {
      Query query = firestore.collection('reports').where('decisionPending', isEqualTo: true);

      if (blockFilter != null && blockFilter != 0) {
        query = query.where('block', isEqualTo: blockFilter);
      }

      final countQuery = await query.count().get();
      return countQuery.count ?? 0;
    });
  }
}
