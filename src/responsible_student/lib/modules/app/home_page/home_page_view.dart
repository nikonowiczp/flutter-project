// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/app/common_scaffold/view/common_scaffold_view.dart';
import 'package:responsible_student/modules/tasks/edit/view/task_edit_page.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';
import 'package:responsible_student/modules/tasks/view/task_preview.dart';
import 'package:responsible_student/modules/user_data/bloc/user_data_bloc.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        var tasks =
            state.tasks.entries.map((e) => TaskPreview(task: e.value)).toList();
        List<Widget> widgets = List.empty(growable: true);
        widgets.add(_addNewTaskButton());
        widgets.addAll(tasks);
        return UserHeaderView(
          title: 'Your tasks',
          child: ListView(children: widgets),
        );
      },
    );
  }
}

class _addNewTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, TaskEditPage.route(Task.newTask()));
        },
        child: Text('Add new task'),
      ),
    );
  }
}
