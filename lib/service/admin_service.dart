import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/model/admin_model.dart';
import 'package:unisafe/service/admin_repository.dart';
import 'firestore_service.dart';

/// Service layer for Admin operations
/// Handles business logic and admin directory lookups
class AdminService extends FirestoreService {
  late final AdminRepository _repository;

  AdminService({FirebaseFirestore? firestore}) : super(firestore: firestore) {
    _repository = AdminRepository(firestore: firestore);
  }

  /// Fetch the admin block map (email -> block assignment)
  /// Block 0 means super-admin with access to all blocks
  Future<Map<String, int>> fetchAdminBlockMap() async {
    return handleFirestoreCall(() => _repository.fetchAdminBlockMap());
  }

  /// Check if a user is an admin
  bool isAdmin(String email, Map<String, int> adminBlockMap) {
    return _repository.isAdmin(email, adminBlockMap);
  }

  /// Get the block assigned to an admin
  /// Returns null if not an admin
  int? getAdminBlock(String email, Map<String, int> adminBlockMap) {
    return _repository.getAdminBlock(email, adminBlockMap);
  }

  /// Check if user is super-admin (block 0)
  bool isSuperAdmin(String email, Map<String, int> adminBlockMap) {
    return _repository.isAdmin(email, adminBlockMap) && (_repository.getAdminBlock(email, adminBlockMap) ?? -1) == 0;
  }

  /// Check if user can access a specific block
  bool canAccessBlock(String email, int requestedBlock, Map<String, int> adminBlockMap) {
    if (!isAdmin(email, adminBlockMap)) return false;

    final userBlock = getAdminBlock(email, adminBlockMap) ?? -1;
    // Super-admin (block 0) or matching block
    return userBlock == 0 || userBlock == requestedBlock;
  }

  /// Add a new admin
  Future<void> addAdmin(Admin admin) async {
    return handleFirestoreCall(() => _repository.addAdmin(admin));
  }

  /// Delete an admin
  Future<void> deleteAdmin(String email) async {
    return handleFirestoreCall(() => _repository.deleteAdmin(email));
  }

  /// Get admins for a specific block
  Stream<List<Admin>> getAdminsByBlock(int block) {
    return handleFirestoreStream(() => _repository.getAdminsByBlockStream(block));
  }

  /// Get total admin count
  Future<int> getAdminCount() async {
    return handleFirestoreCall(() async {
      final query = await firestore.collection('admins').count().get();
      return query.count ?? 0;
    });
  }
}
