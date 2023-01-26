// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/app/common_scaffold/view/common_scaffold_view.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';
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
    return const UserHeaderView(
      title: 'Home',
      child: Center(child: _AddRandomTaskButton()),
    );
  }
}

class _AddRandomTaskButton extends StatelessWidget {
  const _AddRandomTaskButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();

    return ElevatedButton(
      onPressed: () {
        Task task = Task(
            uuid.v1().toString(),
            DateTime.now().add(const Duration(days: 20)),
            20,
            0,
            2,
            "Random task",
            DateTime.now().add(const Duration(days: 3)));
        BlocProvider.of<UserDataBloc>(context)
            .add(UserDataAddTasksEvent([task]));
      },
      child: const Text('Add random task'),
    );
  }
}
