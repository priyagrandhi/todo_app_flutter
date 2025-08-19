import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final Box _tasksBox = Hive.box('tasksBox');

  void _addTask(String task) {
    if (task.isNotEmpty) {
      _tasksBox.add({'title': task, 'completed': false});
      _controller.clear();
    }
  }

  void _toggleTask(int index, bool? value) {
    var task = _tasksBox.getAt(index);
    _tasksBox.putAt(
        index, {'title': task['title'], 'completed': value ?? false});
  }

  void _deleteTask(int index) {
    _tasksBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'To-Do List',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          Tooltip(
            message: 'View Completed Tasks', // ✅ Tooltip added
            child: IconButton(
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, '/completed'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Input row aligned center
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a task',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: Colors.white,

                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blueGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blueGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                    onSubmitted: _addTask,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTask(_controller.text),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 350,
                  child: ValueListenableBuilder(
                    valueListenable: _tasksBox.listenable(),
                    builder: (context, box, _) {
                      if (box.isEmpty) {
                        return const Center(child: Text('No tasks yet'));
                      }
                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          var task = box.getAt(index);
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _deleteTask(index),
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                  flex: 1,
                                  spacing: 0, // reduce extra space
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7), // shrink width
                                ),
                              ],
                            ),
                            child: Card(
                              child: ListTile(
                                leading: Checkbox(
                                  value: task['completed'],
                                  activeColor: Colors.blueGrey, 
                                  onChanged: (value) =>
                                      _toggleTask(index, value),
                                ),
                                title: Text(
                                  task['title'],
                                  style: TextStyle(
                                    decoration: task['completed']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
