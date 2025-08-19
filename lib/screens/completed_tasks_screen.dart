import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box tasksBox = Hive.box('tasksBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Completed Tasks',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: SizedBox(
          width: 350, 
          child: ValueListenableBuilder(
            valueListenable: tasksBox.listenable(),
            builder: (context, box, _) {
              var completedTasks = [];
              for (int i = 0; i < box.length; i++) {
                var task = box.getAt(i);
                if (task['completed']) {
                  completedTasks.add(task);
                }
              }
              if (completedTasks.isEmpty) {
                return const Center(child: Text('No completed tasks'));
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 20), //  Added top padding
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  var task = completedTasks[index];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task['completed'],
                        onChanged: (value) {
                          // update task back to incomplete if user unchecks
                          tasksBox.putAt(
                            index,
                            {'title': task['title'], 'completed': value},
                          );
                        },
                        activeColor: Colors.blueGrey, // checkbox color
                        checkColor: Colors.white,     // tick color
                        shape: RoundedRectangleBorder( // square box
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      title: Text(
                        task['title'],
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
