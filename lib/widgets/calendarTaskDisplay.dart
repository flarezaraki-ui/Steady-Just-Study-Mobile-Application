import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/screens/modify_task_screen.dart';

class Calendartaskdisplay extends ConsumerWidget {
  final DateTime selectedDate;

  const Calendartaskdisplay({super.key, required this.selectedDate});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(calendarTaskProvider(selectedDate));
    if (tasks.isEmpty) {
      return const Column(
        children: [
          Text(
            "No tasks Today ! Well done!",
            style: TextStyle(fontFamily: "Kode Mono", fontSize: 20),
          ),
        ],
      );
    }
    //build the tasks that are for that specific day
    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (ctx, i) {
        return const Divider(height: 3, color: Color(0xFF908C8C));
      },
      itemBuilder: (ctx, i) {
        final item = tasks[i];
        return ListTile(
          onTap: () {
            debugPrint("Navigate to study screen");
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.name, style: const TextStyle(fontFamily: "Kode Mono")),
              const SizedBox(width: 10),
              Text("${(item.progress).toDouble()}%"),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.projectName,
                style: const TextStyle(fontFamily: "Kode Mono"),
              ),
              const SizedBox(width: 10),
              Text(
                'Due: ${item.dueDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontFamily: "Kode Mono"),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed(ModifyTaskScreen.routeName, arguments: item);
            },
          ),
        );
      },
    );
  }
}
