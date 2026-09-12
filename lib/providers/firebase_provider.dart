import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:steady_just_study/models/tasks.dart';
import '../services/firebase_service.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

//to only retrieve the tasks that are from the user logged in
final taskProvider = StreamProvider<List<Task>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (User) {
      if (User == null) return Stream.value([]);
      return FirebaseFirestore.instance
          .collection('tasks')
          .where('email', isEqualTo: User.email)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
          );
    },
    loading: () => Stream.value([]),
    error: (e, _) => Stream.value([]),
  );
});

//to help display the tasks on a given day
final calendarTaskProvider = Provider.family<List<Task>, DateTime>((
  ref,
  selectedDate,
) {
  final allTasksAsync = ref.watch(taskProvider);

  return allTasksAsync.when(
    data: (tasks) {
      return tasks.where((task) {
        return task.dueDate.year == selectedDate.year &&
            task.dueDate.month == selectedDate.month &&
            task.dueDate.day == selectedDate.day;
      }).toList();
    },
    loading: () => [],
    error: (e, _) => [],
  );
});

//  Distinct assessments that actually exist, derived from real tasks
final assessmentListProvider = Provider<List<AssessmentKey>>((ref) {
  final allTasksAsync = ref.watch(taskProvider);

  return allTasksAsync.when(
    data: (tasks) {
      final seen = <AssessmentKey>{};
      for (final t in tasks) {
        seen.add(AssessmentKey(t.module, t.projectName, t.dueDate));
      }
      return seen.toList();
    },
    loading: () => [],
    error: (e, _) => [],
  );
});

//  Tasks belonging to one specific assessment
final assessmentTaskProvider = Provider.family<List<Task>, AssessmentKey>((
  ref,
  key,
) {
  final allTasksAsync = ref.watch(taskProvider);

  return allTasksAsync.when(
    data: (tasks) => tasks
        .where(
          (t) => t.module == key.module && t.projectName == key.projectName,
        )
        .toList(),
    loading: () => [],
    error: (e, _) => [],
  );
});

//  Completion fraction for one assessment (0.0–1.0)
final assessmentProgressProvider = Provider.family<double, AssessmentKey>((
  ref,
  key,
) {
  final tasks = ref.watch(assessmentTaskProvider(key));
  if (tasks.isEmpty) return 0.0;
  return tasks.where((t) => t.completion_status).length / tasks.length;
});
