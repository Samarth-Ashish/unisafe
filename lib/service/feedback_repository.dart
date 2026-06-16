import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisafe/model/feedback_model.dart';
import 'base_repository.dart';

class FeedbackRepository extends BaseRepository<Feedback> {
  FeedbackRepository({FirebaseFirestore? firestore})
      : super(
          firestore: firestore ?? FirebaseFirestore.instance,
          collectionName: 'feedback',
        );

  Future<void> submitFeedback(Feedback feedback) async {
    await add(feedback.toMap());
  }

  Stream<List<Feedback>> getAllFeedbackStream() {
    return firestore
        .collection(collectionName)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Feedback.fromFirestore(doc)).toList());
  }

  @override
  Feedback fromFirestore(DocumentSnapshot doc) {
    return Feedback.fromFirestore(doc);
  }
}
