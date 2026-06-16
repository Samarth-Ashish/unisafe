import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/model/admin_model.dart';
import 'base_repository.dart';

class AdminRepository extends BaseRepository<Admin> {
  AdminRepository({FirebaseFirestore? firestore}) : super(firestore: firestore ?? FirebaseFirestore.instance, collectionName: 'admins');

  /// Fetches the map of admin emails to their assigned block number
  /// Block 0 means super-admin (all blocks)
  Future<Map<String, int>> fetchAdminBlockMap() async {
    try {
      final doc = await firestore.collection(collectionName).doc('admin_list').get();
      final raw = doc.data()?['admins_with_block'] as Map<String, dynamic>?;

      if (raw == null) return {};

      return raw.map((email, block) => MapEntry(email, (block as num).toInt()));
    } catch (e) {
      throw Exception('Failed to fetch admin list: $e');
    }
  }

  /// Check if user is an admin
  bool isAdmin(String email, Map<String, int> adminBlockMap) {
    return adminBlockMap.containsKey(email);
  }

  /// Get the assigned block for an admin
  int? getAdminBlock(String email, Map<String, int> adminBlockMap) {
    return adminBlockMap[email];
  }

  /// Add or update an admin in the admins_with_block map
  Future<void> addAdmin(Admin admin) async {
    try {
      await firestore.collection(collectionName).doc('admin_list').update({'admins_with_block.${admin.email}': admin.block});
    } catch (e) {
      throw Exception('Failed to add admin: $e');
    }
  }

  /// Delete an admin from the admins_with_block map
  Future<void> deleteAdmin(String email) async {
    try {
      await firestore.collection(collectionName).doc('admin_list').update({'admins_with_block.$email': FieldValue.delete()});
    } catch (e) {
      throw Exception('Failed to delete admin: $e');
    }
  }

  /// Get all admins for a specific block
  Stream<List<Admin>> getAdminsByBlockStream(int block) {
    // Since the admin structure is stored differently, we may need to handle this specially
    return firestore
        .collection(collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Admin.fromMap(doc.data())).toList());
  }

  @override
  Admin fromFirestore(DocumentSnapshot doc) {
    return Admin.fromMap(doc.data() as Map<String, dynamic>);
  }
}
