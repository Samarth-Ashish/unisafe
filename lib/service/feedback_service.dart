import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/model/feedback_model.dart';
import 'package:unisafe/service/feedback_repository.dart';
import 'firestore_service.dart';

/// Service layer for Feedback operations
/// Handles business logic and coordinates between UI and data layer
class FeedbackService extends FirestoreService {
  late final FeedbackRepository _repository;

  FeedbackService({FirebaseFirestore? firestore})
      : super(firestore: firestore) {
    _repository = FeedbackRepository(firestore: firestore);
  }

  /// Submit feedback
  Future<void> submitFeedback(Feedback feedback) async {
    return handleFirestoreCall(() => _repository.submitFeedback(feedback));
  }

  /// Get all feedback (for admin)
  Stream<List<Feedback>> getAllFeedback() {
    return handleFirestoreStream(() => _repository.getAllFeedbackStream());
  }

  /// Get total feedback count
  Future<int> getFeedbackCount() async {
    return handleFirestoreCall(() async {
      final query = await firestore.collection('feedback').count().get();
      return query.count ?? 0;
    });
  }

  /// Delete feedback (for admin)
  Future<void> deleteFeedback(String feedbackId) async {
    return handleFirestoreCall(() => _repository.delete(feedbackId));
  }
}
