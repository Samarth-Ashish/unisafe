import 'package:flutter/material.dart';
import 'package:unisafe/model/admin_model.dart';
import 'package:unisafe/service/admin_service.dart';

class AdminViewModel extends ChangeNotifier {
  final AdminService _service;

  AdminViewModel(this._service);

  bool isLoading = false;
  String? error;
  String? successMessage;

  // selected block on admin dashboard
  int? selectedBlock;

  void setSelectedBlock(int? val) {
    selectedBlock = val;
    notifyListeners();
  }

  Future<bool> addAdmin(String email, int block) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();

    try {
      await _service.addAdmin(Admin(email: email, block: block));
      successMessage = 'Admin added successfully';
      return true;
    } catch (e) {
      error = 'Failed to add admin: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAdmin(String email) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();

    try {
      await _service.deleteAdmin(email);
      successMessage = 'Admin deleted successfully';
      return true;
    } catch (e) {
      error = 'Failed to delete admin: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, int>> fetchAdminBlockMap() async {
    return _service.fetchAdminBlockMap();
  }
}
