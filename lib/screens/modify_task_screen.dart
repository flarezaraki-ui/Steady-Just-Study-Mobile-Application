import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:steady_just_study/models/tasks.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/services/firebase_service.dart';

class ModifyTaskScreen extends ConsumerStatefulWidget {
  static String routeName = '/modify_task';

  @override
  ConsumerState<ModifyTaskScreen> createState() => _ModifyTaskScreenState();
}

class _ModifyTaskScreenState extends ConsumerState<ModifyTaskScreen> {
  var form = GlobalKey<FormState>();

  final Map<String, List<String>> moduleProjects = {
    'Mbap': ['MBAP Part 1', "MBAP Part 2", "MBAP Part 3"],
    'Cadv': ['CADV Part 1', "CADV Part 2", "CADV Part 3"],
    'Amdt': ['AMDT Part 1', "AMDT Part 2", "AMDT Part 3"],
    'Apsec': ['ASPEC Part 1', "APSEC Part 2", "APSEC Part 3"],
    'Ecomm': ['ECOMM Part 1', "ECOMM Part 2", "ECOMM Part 3"],
    'Innova': ['Planning assessment', "Individual Asessement"],
    'Gs': ['GS Part 1', "GS Part 2", "GS Part 3"],
    'Leadact': ['Planning assessment', "Individual Asessement"],
  };

  void showAlertDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              deleteTask(context, ref, id);
              Navigator.of(context).pushNamed("/");
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteTask(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    FirebaseService firebaseService = ref.read(firebaseServiceProvider);

    try {
      await firebaseService.deleteTask(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task deleted successfully!')));
      Navigator.of(context).pushNamed("/");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred while deleting the Task. Please try again.',
          ),
        ),
      );
    }
  }
  // bool reminderOn = false;

  // String? taskName;

  // String? module;

  // String? projectName;

  // DateTime? dueDate;

  Task? selectedTask;

  Future<void> presentDatePicker(BuildContext context) async {
    DateTime? value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 150)),
    );

    if (value != null) {
      setState(() {
        selectedTask!.dueDate = value;
      });
    }
  }

  Future<void> saveForm() async {
    bool isValid = form.currentState!.validate();

    // if (dueDate == null) {
    //   dueDate = DateTime.now();
    // }

    if (isValid) {
      form.currentState!.save();
      try {
        // debugPrint(module);
        // debugPrint(taskName);
        // debugPrint(projectName);
        // debugPrint(DateFormat('dd/MM/yyyy').format(dueDate!));
        // debugPrint("Reminder set to " + reminderOn.toString());

        // FocusScope.of(context).unfocus();

        // form.currentState!.reset();
        // dueDate = null;
        FirebaseService firebaseService = ref.read(firebaseServiceProvider);
        await firebaseService.updateTask(
          selectedTask!.id,
          selectedTask!.name,
          selectedTask!.dueDate,
          selectedTask!.module,
          selectedTask!.projectName,
          selectedTask!.progress,
          selectedTask!.reminderOn,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Task Modified successfully!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred while updating the task. Please try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedTask == null) {
      debugPrint("Getting Task items");
      selectedTask = ModalRoute.of(context)?.settings.arguments as Task;
    }
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Edit Task"))),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task Name", style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: selectedTask!.name,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF3D2D2),
                    label: Text(
                      'Task name',
                      style: TextStyle(fontFamily: "Kode Mono"),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  onSaved: (value) {
                    selectedTask!.name = value!;
                  },
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please provide a task name.';
                    } else if (value.length < 5) {
                      return 'Please enter a task name that is at least 5 characters.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10),
                Text("Progress Percentage", style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: selectedTask!.progress.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF3D2D2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    label: Text(
                      'Progress Percentage',
                      style: TextStyle(fontFamily: 'Kode Mono'),
                    ),
                  ),
                  onSaved: (value) {
                    selectedTask!.progress =
                        double.tryParse(value ?? '0') ?? 0.0;
                  },
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please provide a progress percentage.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10),
                Text("Module", style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  initialValue:
                      moduleProjects.keys.contains(selectedTask!.module)
                      ? selectedTask!.module
                      : null,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF3D2D2),
                    label: Text(
                      'Module',
                      style: TextStyle(fontFamily: "Kode Mono"),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  items: moduleProjects.keys
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTask!.module = value!;
                      selectedTask!.projectName = "";
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please provide a module.";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10),
                Text("Project Name", style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  initialValue:
                      (moduleProjects[selectedTask!.module] ?? []).contains(
                        selectedTask!.projectName,
                      )
                      ? selectedTask!.projectName
                      : null,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF3D2D2),
                    label: Text(
                      'Project name',
                      style: TextStyle(fontFamily: "Kode Mono"),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  items: (moduleProjects[selectedTask!.module] ?? [])
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTask!.projectName = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return 'Please provide a project name.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10),
                Text(
                  "Due date",
                  style: TextStyle(fontSize: 16.0, fontFamily: "Kode Mono"),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3D2D2), // Background color
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Due date:" +
                            DateFormat(
                              'dd/MM/yyyy',
                            ).format(selectedTask!.dueDate),
                      ),
                      TextButton(
                        child: Icon(Icons.calendar_month),
                        onPressed: () {
                          presentDatePicker(context);
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color(0xffF3D2D2),
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Reminder on"),
                            Switch(
                              value: selectedTask!.reminderOn,
                              onChanged: (bool newVal) {
                                setState(() {
                                  selectedTask!.reminderOn = newVal;
                                });
                              },
                              activeThumbColor: Color(0xff7BB1D2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 150),
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              saveForm();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              side: const BorderSide(
                                color: Color(0xff7BB1D2), // Border color
                                width: 2.0, // Border thickness
                              ),
                              fixedSize: const Size(180, 50),
                              backgroundColor: Color(0xffDEF3FC),
                            ),
                            label: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: "Kode Mono",
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              showAlertDialog(context, ref, selectedTask!.id);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              side: const BorderSide(
                                color: Color(0xffEA5353), // Border color
                                width: 2.0, // Border thickness
                              ),
                              fixedSize: const Size(180, 50),
                              backgroundColor: Color(0xffFCE0DE),
                            ),
                            label: Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: "Kode Mono",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
