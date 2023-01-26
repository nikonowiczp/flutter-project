import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsible_student/modules/app/home_page/home_page_view.dart';
import 'package:responsible_student/modules/tasks/edit/bloc/task_edit_bloc.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';
import 'package:responsible_student/modules/user_data/bloc/user_data_bloc.dart';

class TaskEditView extends StatelessWidget {
  const TaskEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskEditBloc, TaskEditState>(
        listener: (context, state) {},
        child:
            BlocBuilder<TaskEditBloc, TaskEditState>(builder: (context, state) {
          bool isTaskModified = BlocProvider.of<UserDataBloc>(context)
              .state
              .tasks
              .containsKey(state.id);
          List<Widget> actions = List.empty(growable: true);
          if (isTaskModified) {
            actions.add(ElevatedButton(
                onPressed: () {
                  BlocProvider.of<UserDataBloc>(context)
                      .add(UserDataDeleteTask(state.getTask()));
                  Navigator.pushReplacement(context, HomePage.route());
                },
                child: const Text('Delete')));
          }
          actions.addAll([
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, HomePage.route());
                },
                child: const Text('Back')),
            ElevatedButton(
                onPressed: state.canSubmit()
                    ? () {
                        BlocProvider.of<UserDataBloc>(context)
                            .add(UserDataAddOrUpdateTask(state.getTask()));
                        Navigator.pushReplacement(context, HomePage.route());
                      }
                    : null,
                child: const Text('Save')),
          ]);

          return Scaffold(
            body: Scaffold(
                appBar: AppBar(
                  title: Text('Modify task'),
                  actions: actions,
                ),
                body: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                  child: ListView(
                    children: [
                      _nameInput(
                          bloc: BlocProvider.of<TaskEditBloc>(context),
                          error: state.nameError),
                      _deadlineInput(
                          bloc: BlocProvider.of<TaskEditBloc>(context),
                          error: state.deadlineError),
                      _nextReminderInput(
                          bloc: BlocProvider.of<TaskEditBloc>(context),
                          error: state.nextReminderError),
                      _hoursInput(
                          bloc: BlocProvider.of<TaskEditBloc>(context),
                          error: state.hoursError),
                      _hoursDoneInput(
                          bloc: BlocProvider.of<TaskEditBloc>(context),
                          error: state.hoursDoneError),
                      _hoursPerReminderDoneInput(
                          bloc: BlocProvider.of<TaskEditBloc>(context),
                          error: state.hoursPerReminderError),
                    ],
                  ),
                )),
          );
        }));
  }
}

class _deadlineInput extends StatelessWidget {
  _deadlineInput({super.key, required this.bloc, required this.error});
  final String error;
  bool _hasError() {
    return error != '';
  }

  final TaskEditBloc bloc;
  @override
  Widget build(BuildContext context) {
    print(error);
    return Column(children: [
      TextField(
        controller: bloc.deadline,
        decoration: InputDecoration(
            hintText: 'Deadline',
            labelStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            hintStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            enabledBorder: _renderBorder(_hasError()),
            focusedBorder: _renderBorder(_hasError()),
            icon: const Icon(Icons.calendar_today),
            labelText: "Enter deadline date"),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateFormat.yMd().parse(bloc.deadline.text),
              firstDate: DateTime(1950),
              lastDate: DateTime(2100));
          if (pickedDate != null) {
            String formattedDate = DateFormat.yMd().format(pickedDate);
            bloc.add(TaskEditDeadlineChanged(pickedDate));
          } else {}
        },
      ),
      if (_hasError()) ...[
        const SizedBox(height: 5),
        Text(
          error,
          style: const TextStyle(color: Colors.red),
        ),
      ],
      const SizedBox(height: 30),
    ]);
  }
}

class _nextReminderInput extends StatelessWidget {
  _nextReminderInput({super.key, required this.bloc, required this.error});
  final String error;
  bool _hasError() {
    return error != '';
  }

  final TaskEditBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        controller: bloc.nextReminder,
        decoration: InputDecoration(
            hintText: 'Next reminder',
            labelStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            hintStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            enabledBorder: _renderBorder(_hasError()),
            focusedBorder: _renderBorder(_hasError()),
            icon: const Icon(Icons.calendar_today),
            labelText: "Enter next reminder date"),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateFormat.yMd().parse(bloc.nextReminder.text),
              firstDate: DateTime(1950),
              lastDate: DateTime(2100));
          if (pickedDate != null) {
            String formattedDate = DateFormat.yMd().format(pickedDate);
            bloc.add(TaskEditNextReminderChanged(pickedDate));
          } else {}
        },
      ),
      if (_hasError()) ...[
        const SizedBox(height: 5),
        Text(
          error,
          style: const TextStyle(color: Colors.red),
        ),
      ],
      const SizedBox(height: 30),
    ]);
  }
}

class _hoursInput extends StatelessWidget {
  _hoursInput({super.key, required this.bloc, required this.error});
  final String error;
  bool _hasError() {
    return error != '';
  }

  final TaskEditBloc bloc;
  @override
  Widget build(BuildContext context) {
    print(error);
    return Column(children: [
      TextField(
        controller: bloc.hours,
        onChanged: (value) {
          print(value);
          bloc.add(TaskEditHoursChanged(double.parse(value)));
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {}
            return oldValue;
          }),
        ],
        decoration: InputDecoration(
            hintText: 'Total hours',
            labelStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            hintStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            enabledBorder: _renderBorder(_hasError()),
            focusedBorder: _renderBorder(_hasError()),
            labelText: "Enter total hours"),
      ),
      if (_hasError()) ...[
        const SizedBox(height: 5),
        Text(
          error,
          style: const TextStyle(color: Colors.red),
        ),
      ],
      const SizedBox(height: 30),
    ]);
  }
}

class _hoursDoneInput extends StatelessWidget {
  _hoursDoneInput({super.key, required this.bloc, required this.error});
  final String error;
  bool _hasError() {
    return error != '';
  }

  final TaskEditBloc bloc;
  @override
  Widget build(BuildContext context) {
    print(error);
    return Column(children: [
      TextField(
        controller: bloc.hoursDone,
        onChanged: (value) {
          print(value);
          bloc.add(TaskEditHoursDoneChanged(double.parse(value)));
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {}
            return oldValue;
          }),
        ],
        decoration: InputDecoration(
            hintText: 'Hours done',
            labelStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            hintStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            enabledBorder: _renderBorder(_hasError()),
            focusedBorder: _renderBorder(_hasError()),
            labelText: "Enter hours already done"),
      ),
      if (_hasError()) ...[
        const SizedBox(height: 5),
        Text(
          error,
          style: const TextStyle(color: Colors.red),
        ),
      ],
      const SizedBox(height: 30),
    ]);
  }
}

class _hoursPerReminderDoneInput extends StatelessWidget {
  _hoursPerReminderDoneInput(
      {super.key, required this.bloc, required this.error});
  final String error;
  bool _hasError() {
    return error != '';
  }

  final TaskEditBloc bloc;
  @override
  Widget build(BuildContext context) {
    print(error);
    return Column(children: [
      TextField(
        controller: bloc.hoursPerReminder,
        onChanged: (value) {
          print(value);
          bloc.add(TaskEditHoursPerReminderChanged(double.parse(value)));
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {}
            return oldValue;
          }),
        ],
        decoration: InputDecoration(
            hintText: 'Hours per reminder',
            labelStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            hintStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            enabledBorder: _renderBorder(_hasError()),
            focusedBorder: _renderBorder(_hasError()),
            labelText: "Enter hours per reminder"),
      ),
      if (_hasError()) ...[
        const SizedBox(height: 5),
        Text(
          error,
          style: const TextStyle(color: Colors.red),
        ),
      ],
      const SizedBox(height: 30),
    ]);
  }
}

class _nameInput extends StatelessWidget {
  _nameInput({super.key, required this.bloc, required this.error});
  final String error;
  bool _hasError() {
    return error != '';
  }

  final TaskEditBloc bloc;
  @override
  Widget build(BuildContext context) {
    print(error);
    return Column(children: [
      TextField(
        controller: bloc.name,
        onChanged: (value) {
          bloc.add(TaskEditNameChanged(value));
        },
        decoration: InputDecoration(
            hintText: 'Task name',
            labelStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            hintStyle: TextStyle(
              color: _hasError() ? Colors.red : Colors.black,
            ),
            enabledBorder: _renderBorder(_hasError()),
            focusedBorder: _renderBorder(_hasError()),
            labelText: "Enter task name"),
      ),
      if (_hasError()) ...[
        const SizedBox(height: 5),
        Text(
          error,
          style: const TextStyle(color: Colors.red),
        ),
      ],
      const SizedBox(height: 30),
    ]);
  }
}

UnderlineInputBorder _renderBorder(bool hasError) => UnderlineInputBorder(
      borderSide:
          BorderSide(color: hasError ? Colors.red : Colors.black, width: 1),
    );
