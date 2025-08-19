import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String taskTitle;
  final bool isCompleted;
  final ValueChanged<bool?> onChanged;

  const TaskTile({
    super.key,
    required this.taskTitle,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: onChanged, // ✅ uses global theme colors
        ),
        title: Text(
          taskTitle,
          style: TextStyle(
            decoration:
                isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
