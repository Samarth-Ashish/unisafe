import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/model/report_model.dart';
import 'package:unisafe/service/report_repository.dart';
import 'firestore_service.dart';

/// Service layer for Report operations
/// Handles business logic and coordinates between UI and data layer
class ReportService extends FirestoreService {
  late final ReportRepository _repository;

  ReportService({FirebaseFirestore? firestore}) : super(firestore: firestore) {
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
    return handleFirestoreStream(() => _repository.getPendingReportsStream(blockFilter: blockFilter));
  }

  /// Update report decision status
  Future<void> updateReportStatus(String reportId, bool decisionPending) async {
    return handleFirestoreCall(() => _repository.update(reportId, {'decisionPending': decisionPending}));
  }

  Future<int> getUserReportCount(String userEmail) async {
    return handleFirestoreCall(() => _repository.getUserReportCount(userEmail));
  }

  Future<int> getPendingReportCount({int? blockFilter}) async {
    return handleFirestoreCall(() => _repository.getPendingReportCount(blockFilter: blockFilter));
  }

  Future<void> deleteReport(String reportId) async {
    return handleFirestoreCall(() => _repository.deleteReport(reportId));
  }

  Future<void> deleteAllUserReports(String userEmail) async {
    return handleFirestoreCall(() => _repository.deleteAllUserReports(userEmail));
  }
}
