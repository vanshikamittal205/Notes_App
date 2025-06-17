import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Toggles the isDone status of a task
  Future<void> toggleTaskDone({
    required String taskId,
    required bool currentStatus,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('todos')
          .doc(taskId)
          .update({'done': !currentStatus});
    } catch (e) {
      print('Error toggling task done status: $e');
      rethrow;
    }
  }
}
