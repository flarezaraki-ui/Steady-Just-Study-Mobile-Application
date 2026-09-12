import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/services/firebase_service.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  static String routeName = '/add_task';

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
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

  bool reminderOn = false;

  String? taskName;

  String? module;

  double? progress;

  String? projectName;

  DateTime? dueDate;

  Future<void> presentDatePicker(BuildContext context) async {
    DateTime? value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 150)),
    );

    if (value != null) {
      setState(() {
        dueDate = value;
      });
    }
  }

  Future<void> saveForm() async {
    bool isValid = form.currentState!.validate();

    if (dueDate == null) {
      dueDate = DateTime.now();
    }

    if (isValid) {
      form.currentState!.save();
      debugPrint(module);
      debugPrint(taskName);
      debugPrint(progress.toString());
      debugPrint(projectName);
      debugPrint(DateFormat('dd/MM/yyyy').format(dueDate!));
      debugPrint("Reminder set to " + reminderOn.toString());

      try {
        FirebaseService firebaseService = ref.read(firebaseServiceProvider);
        await firebaseService.addTask(
          taskName!,
          dueDate!,
          module!,
          projectName!,
          progress!,
          reminderOn,
        );

        FocusScope.of(context).unfocus();

        form.currentState!.reset();
        dueDate = null;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Task added successfully!')));

        Navigator.of(context).pushReplacementNamed("/");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating Task. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Add Task", style: TextStyle(fontFamily: "Kode Mono")),
        ),
      ),
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
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF3D2D2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    label: Text(
                      'Task name',
                      style: TextStyle(fontFamily: 'Kode Mono', fontSize: 16.0),
                    ),
                  ),
                  onSaved: (value) {
                    taskName = value;
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
                    progress = double.tryParse(value ?? '0') ?? 0.0;
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
                      module = value;
                      projectName = null;
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
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF3D2D2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    label: Text(
                      'Project name',
                      style: TextStyle(fontFamily: 'Kode Mono'),
                    ),
                  ),
                  items: (moduleProjects[module] ?? [])
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      projectName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please provide a project name.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10),
                Text("Due date", style: TextStyle(fontSize: 16.0)),
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
                        dueDate == null
                            ? "No date chosen"
                            : "Due date:" +
                                  DateFormat('dd/MM/yyyy').format(dueDate!),
                        style: TextStyle(
                          fontFamily: 'Kode Mono',
                          fontSize: 16.0,
                        ),
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
                SizedBox(height: 60),
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
                            Text(
                              "Reminder on",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Switch(
                              value: reminderOn,
                              onChanged: (bool newVal) {
                                setState(() {
                                  reminderOn = newVal;
                                });
                              },
                              activeThumbColor: Color(0xff7BB1D2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                      ElevatedButton(
                        onPressed: () {
                          saveForm();
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xff7BB1D2), // Border color
                            width: 2.0, // Border thickness
                          ),
                          fixedSize: const Size(400, 50),
                          backgroundColor: Color(0xffDEF3FC),
                        ),
                        child: Text(
                          "Add Task",
                          style: TextStyle(
                            fontFamily: 'Kode Mono',
                            fontSize: 16.0,
                          ),
                        ),
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
