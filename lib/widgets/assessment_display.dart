import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';

class AssessmentDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessments = ref.watch(assessmentListProvider);

    //check if the user has created any assessments
    if (assessments.isEmpty) {
      return const Text(
        "No assessments yet",
        style: TextStyle(fontFamily: "Kode Mono"),
      );
    }

    //display the assessments based on the tasks the users have created
    return Column(
      children: assessments.map((key) {
        final progress = ref.watch(assessmentProgressProvider(key));
        //to help determine if the assessment is completed
        final isComplete = progress >= 1.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${key.module} - ${key.projectName} ",
                    style: const TextStyle(fontFamily: "Kode Mono"),
                  ),

                  Icon(
                    //change the completion color and display depending on if completed
                    isComplete
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isComplete ? Colors.green : Colors.grey,
                  ),
                ],
              ),
              Text(
                "Progress : ${(progress * 100).round()}% - Due Date : ${DateFormat('dd/M/yyyy').format(key.dueDate)}",
                style: const TextStyle(fontFamily: "Kode Mono"),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
