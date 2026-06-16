import 'admin_service.dart';

/// Legacy wrapper for AdminService for backward compatibility
/// Prefer using AdminService directly in new code
class AdminDirectoryService {
  final AdminService _adminService;

  AdminDirectoryService({AdminService? adminService})
      : _adminService = adminService ?? AdminService();

  /// Fetches the map of admin emails to their assigned block number.
  /// Block `0` conventionally means "all blocks" (super-admin).
  Future<Map<String, int>> fetchAdminBlockMap() async {
    return _adminService.fetchAdminBlockMap();
  }

  /// Returns true if [email] is present in [adminBlockMap].
  bool isAdmin(String email, Map<String, int> adminBlockMap) {
    return _adminService.isAdmin(email, adminBlockMap);
  }

  /// Returns the block assigned to [email], or null if not an admin.
  int? blockFor(String email, Map<String, int> adminBlockMap) {
    return _adminService.getAdminBlock(email, adminBlockMap);
  }
}

