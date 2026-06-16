import 'package:cloud_firestore/cloud_firestore.dart';

/// Base service for Firestore operations
abstract class FirestoreService {
  final FirebaseFirestore firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// Helper to handle Firestore exceptions uniformly
  Future<T> handleFirestoreCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: e.message ?? 'Firestore error occurred',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException(
        message: e.toString(),
        code: 'unknown',
      );
    }
  }

  /// Helper for stream operations with error handling
  Stream<T> handleFirestoreStream<T>(Stream<T> Function() call) {
    try {
      return call();
    } catch (e) {
      return Stream.error(
        FirestoreException(
          message: e.toString(),
          code: 'stream_error',
        ),
      );
    }
  }
}

class FirestoreException implements Exception {
  final String message;
  final String code;

  FirestoreException({
    required this.message,
    required this.code,
  });

  @override
  String toString() => 'FirestoreException: [$code] $message';
}
