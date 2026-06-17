import 'package:flutter/material.dart';
import 'package:unisafe/model/report_model.dart';
import 'package:unisafe/service/report_service.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportService _service;

  ReportViewModel(this._service);

  // --- form state ---
  bool physicalBully = false;
  bool verbalBully = false;
  bool cyberBully = false;
  bool socialBully = false;
  int? block;

  // --- async state ---
  bool isLoading = false;
  String? error;

  void toggleBully(String type, bool val) {
    switch (type) {
      case 'physical':
        physicalBully = val;
        break;
      case 'verbal':
        verbalBully = val;
        break;
      case 'cyber':
        cyberBully = val;
        break;
      case 'social':
        socialBully = val;
        break;
    }
    notifyListeners();
  }

  void setBlock(int? val) {
    block = val;
    notifyListeners();
  }

  void resetForm() {
    physicalBully = verbalBully = cyberBully = socialBully = false;
    block = null;
    error = null;
    notifyListeners();
  }

  Future<bool> submitReport({
    required String reportedFromEmail,
    required String name,
    required String email,
    required String registrationId,
    required String reportDescription,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final report = Report(
        reportedFromEmail: reportedFromEmail,
        name: name,
        email: email,
        registrationId: registrationId,
        reportDescription: reportDescription,
        physicalBullying: physicalBully,
        verbalBullying: verbalBully,
        cyberBullying: cyberBully,
        socialBullying: socialBully,
        decisionPending: true,
        block: block,
        submittedAt: DateTime.now(),
      );
      await _service.submitReport(report);
      resetForm();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resolveReport(String reportId) async {
    try {
      await _service.updateReportStatus(reportId, false);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> deleteReport(String reportId) async {
    try {
      await _service.deleteReport(reportId);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAllUserReports(String userEmail) async {
    try {
      await _service.deleteAllUserReports(userEmail);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Stream<List<Report>> getUserReports(String email) => _service.getUserReports(email);

  Stream<List<Report>> getRecentReports(String email) => _service.getRecentReports(email);

  Stream<List<Report>> getResolvedReports(String email) => _service.getResolvedReports(email);

  Stream<List<Report>> getPendingReports({int? blockFilter}) => _service.getPendingReports(blockFilter: blockFilter);
}
