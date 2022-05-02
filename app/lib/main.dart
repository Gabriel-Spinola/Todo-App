import 'package:app/DataBase/db_provider.dart';
import 'package:app/Models/task_model.dart';
import 'package:flutter/material.dart';

void main() {
  var db = DBProvider().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  Color mainColor = const Color(0xFF0d0952);
  Color secondColor = const Color(0xFF212061);
  Color btnColor = const Color(0xFFff955b);
  Color editColor = const Color(0xFF4044cc);

  TextEditingController inputController = TextEditingController();
  String newTaskTxt = "";

  Future<List<Map<String, Object?>>> getTask() async {
    //final testTask = Task(id: 0, task: "TestTask", dateTime: DateTime(2022));

    // DBProvider.insertObject(testTask, 'tasks');

    final tasks = await DBProvider.getObjects('tasks');

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainColor,
        title: const Text('My To-Do!'),
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTask(),
              builder: (_, AsyncSnapshot<List<Map<String, Object?>>> taskData) {
                switch (taskData.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return const Center(child: CircularProgressIndicator());
                    }
                  case ConnectionState.done:
                    {
                      // NOTE: This might cause problems
                      if (taskData.data != null && taskData.data!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: taskData.data?.length,
                            itemBuilder: (context, index) {
                              var task =
                                  taskData.data![index]['task'] as String;

                              // Added the toString method to avoid null propagation
                              var day = DateTime.parse(
                                taskData.data![index]['creationDate'] as String,
                              ).day.toString();

                              print(index);

                              // Todo List Card
                              return Card(
                                color: secondColor,
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      // * Task Date
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          taskData.data!.length.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // * Task
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            task,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'You have now task today',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }
                    }
                  case ConnectionState.none:
                    break;
                  case ConnectionState.active:
                    break;
                }

                return Container();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              color: editColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Type a new Task',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                // * Separates the Text Field from the Elevated Button
                const SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: btnColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                    onPressed: () {
                      setState(() {
                        newTaskTxt = inputController.text.toString();
                        inputController.text = "";
                      });

                      Task newTask = Task(
                        task: newTaskTxt,
                        dateTime: DateTime.now(),
                      );

                      Task newTask2 = Task(
                        task: "$newTaskTxt 2",
                        dateTime: DateTime.now(),
                      );

                      var lastId = newTask.id;
                      lastId = newTask.id + 1;

                      DBProvider.insertObject(newTask, 'tasks');
                      DBProvider.insertObject(newTask2, 'tasks');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
