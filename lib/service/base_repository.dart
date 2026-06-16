import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepository<T> {
  final FirebaseFirestore firestore;
  final String collectionName;

  BaseRepository({
    required this.firestore,
    required this.collectionName,
  });

  Future<void> add(Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionName).add(data);
    } catch (e) {
      throw Exception('Failed to add document: $e');
    }
  }

  Future<void> update(String docId, Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionName).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  Future<void> delete(String docId) async {
    try {
      await firestore.collection(collectionName).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  Stream<QuerySnapshot> getStream({
    List<QueryConstraint>? constraints,
    List<OrderByConstraint>? orderBy,
  }) {
    Query query = firestore.collection(collectionName);

    if (constraints != null) {
      for (var constraint in constraints) {
        query = constraint.apply(query);
      }
    }

    if (orderBy != null) {
      for (var order in orderBy) {
        query = order.apply(query);
      }
    }

    return query.snapshots();
  }

  Future<List<T>> getList({
    List<QueryConstraint>? constraints,
    List<OrderByConstraint>? orderBy,
  }) async {
    try {
      Query query = firestore.collection(collectionName);

      if (constraints != null) {
        for (var constraint in constraints) {
          query = constraint.apply(query);
        }
      }

      if (orderBy != null) {
        for (var order in orderBy) {
          query = order.apply(query);
        }
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  T fromFirestore(DocumentSnapshot doc);
}

class QueryConstraint {
  final String field;
  final dynamic value;
  final String operator;

  QueryConstraint({
    required this.field,
    required this.value,
    this.operator = '==',
  });

  Query apply(Query query) {
    switch (operator) {
      case '==':
        return query.where(field, isEqualTo: value);
      case '<':
        return query.where(field, isLessThan: value);
      case '<=':
        return query.where(field, isLessThanOrEqualTo: value);
      case '>':
        return query.where(field, isGreaterThan: value);
      case '>=':
        return query.where(field, isGreaterThanOrEqualTo: value);
      case '!=':
        return query.where(field, isNotEqualTo: value);
      case 'in':
        return query.where(field, whereIn: value);
      case 'array-contains':
        return query.where(field, arrayContains: value);
      default:
        return query;
    }
  }
}

class OrderByConstraint {
  final String field;
  final bool descending;

  OrderByConstraint({
    required this.field,
    this.descending = false,
  });

  Query apply(Query query) {
    return query.orderBy(field, descending: descending);
  }
}
