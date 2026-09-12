import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String name;
  DateTime dueDate;
  String module;
  String projectName;
  double progress;
  bool reminderOn;
  bool completion_status;
  //maybe add reminder
  Task({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.module,
    required this.projectName,
    required this.progress,
    required this.reminderOn,
    required this.completion_status,
  });

  static Task fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Task(
      id: doc.id,
      name: data['name'] ?? '',
      dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      module: data['module'] ?? '',
      projectName: data['projectName'] ?? '',
      progress: (data['progress'] as num).toDouble(),
      reminderOn: data['reminderOn'] as bool? ?? false,
      completion_status: data['completion_status'] as bool? ?? false,
    );
  }
}
