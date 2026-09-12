import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/screens/modify_task_screen.dart';
import 'package:steady_just_study/screens/study_screen.dart';

class Mytasks extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return tasks.when(
      data: (list) {
        final incompleteTasks = list
            .where((t) => t.completion_status == false)
            .toList();
        if (incompleteTasks.isEmpty) {
          return Column(
            children: [
              Text(
                "No tasks remaining ! Well done!",
                style: TextStyle(fontFamily: "Kode Mono", fontSize: 40),
              ),
            ],
          );
        }
        //build the task display
        return ListView.separated(
          itemBuilder: (ctx, i) {
            final item = incompleteTasks[i];
            return ListTile(
              onTap: () {
                debugPrint("Navigate to study screen");
                Navigator.of(
                  context,
                ).pushNamed(Study_screen.routeName, arguments: item);
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.name, style: TextStyle(fontFamily: "Kode Mono")),
                  SizedBox(width: 10),
                  Text("${(item.progress).toDouble()}%"),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.projectName,
                    style: TextStyle(fontFamily: "Kode Mono"),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Due: ${item.dueDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontFamily: "Kode Mono"),
                  ),
                ],
              ),

              trailing: IconButton(
                icon: Icon(Icons.edit_square),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamed(ModifyTaskScreen.routeName, arguments: item);
                },
              ),
            );
          },
          separatorBuilder: (ctx, i) {
            return const Divider(height: 3, color: Color(0xFF908C8C));
          },
          itemCount: incompleteTasks.length,
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error loading tasks: $e'),
    );
  }
}
