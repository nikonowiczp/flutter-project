import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/tasks/edit/bloc/task_edit_bloc.dart';
import 'package:responsible_student/modules/tasks/edit/view/task_edit_view.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';

class TaskEditPage extends StatelessWidget {
  const TaskEditPage({Key? key, required this.task}) : super(key: key);
  final Task task;
  static Route route(Task task) {
    return MaterialPageRoute(
      builder: (context) => TaskEditPage(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => TaskEditBloc(task),
      child: TaskEditView(),
    );
  }
}
