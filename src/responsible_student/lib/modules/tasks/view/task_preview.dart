import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsible_student/modules/tasks/edit/view/task_edit_page.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';

class TaskPreview extends StatelessWidget {
  final Task task;

  const TaskPreview({super.key, required this.task});

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Text(task.name)),
          Expanded(child: Text(DateFormat.yMd().format(task.nextReminder))),
          Expanded(child: Text('${task.hours - task.hoursDone} hours left')),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, TaskEditPage.route(task));
                },
                child: Text('Details')),
          )
        ],
      ),
    );
  }
}
