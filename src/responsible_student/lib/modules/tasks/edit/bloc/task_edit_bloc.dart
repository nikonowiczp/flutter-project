// ignore_for_file: unused_import

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsible_student/modules/tasks/models/task.dart';
import 'package:tuple/tuple.dart';

part 'task_edit_state.dart';
part 'task_edit_event.dart';

class TaskEditBloc extends Bloc<TaskEditEvent, TaskEditState> {
  TaskEditBloc(Task task)
      : super(
          TaskEditState(
              id: task.id,
              deadline: task.deadline,
              hours: task.hours,
              hoursDone: task.hoursDone,
              hoursPerReminder: task.hoursPerReminder,
              name: task.name,
              nextReminder: task.nextReminder),
        ) {
    on<TaskEditDeadlineChanged>(_onDeadlineChanged);
    on<TaskEditHoursChanged>(_onHoursChanged);
    on<TaskEditHoursDoneChanged>(_onHoursDoneChanged);
    on<TaskEditHoursPerReminderChanged>(_onHoursPerReminderChanged);
    on<TaskEditNameChanged>(_onNameChanged);
    on<TaskEditNextReminderChanged>(_onNextReminderChanged);
    on<TaskEditCheckAllErrors>(_onTaskEditCheckAllErrors);

    add(TaskEditCheckAllErrors());
    deadline.text = DateFormat.yMd().format(task.deadline);
    hours.text = task.hours.toString();
    hoursDone.text = task.hoursDone.toString();
    hoursPerReminder.text = task.hoursPerReminder.toString();
    name.text = task.name;
    nextReminder.text = DateFormat.yMd().format(task.nextReminder);
  }
  final deadline = TextEditingController();
  final hours = TextEditingController();
  final hoursDone = TextEditingController();
  final hoursPerReminder = TextEditingController();
  final name = TextEditingController();
  final nextReminder = TextEditingController();

  _onDeadlineChanged(
      TaskEditDeadlineChanged event, Emitter<TaskEditState> emit) {
    deadline.text = DateFormat.yMd().format(event.deadline);
    var calculatedNextReminder = _calculateNextReminder(
        event.deadline, state.hours, state.hoursDone, state.hoursPerReminder);
    if (calculatedNextReminder.item2.isEmpty) {
      nextReminder.text = DateFormat.yMd().format(calculatedNextReminder.item1);
    }
    emit(
      state.copyWith(
          deadline: event.deadline,
          deadlineError: _getDeadlineError(event.deadline, state.nextReminder),
          nextReminder: calculatedNextReminder.item2.isEmpty
              ? calculatedNextReminder.item1
              : null,
          nextReminderError: calculatedNextReminder.item2.isEmpty
              ? _getNextReminderError(
                  calculatedNextReminder.item1, event.deadline)
              : null,
          hoursPerReminderError: calculatedNextReminder.item2),
    );
  }

  _onHoursChanged(TaskEditHoursChanged event, Emitter<TaskEditState> emit) {
    var calculatedNextReminder = _calculateNextReminder(
        state.deadline, event.hours, state.hoursDone, state.hoursPerReminder);
    if (calculatedNextReminder.item2.isEmpty) {
      nextReminder.text = DateFormat.yMd().format(calculatedNextReminder.item1);
    }
    emit(state.copyWith(
        hours: event.hours,
        hoursError: _getHoursError(event.hours, state.hoursDone),
        hoursDoneError: _getHoursDoneError(state.hoursDone, event.hours),
        nextReminder: calculatedNextReminder.item2.isEmpty
            ? calculatedNextReminder.item1
            : null,
        nextReminderError: calculatedNextReminder.item2.isEmpty
            ? _getNextReminderError(
                calculatedNextReminder.item1, state.deadline)
            : null,
        hoursPerReminderError: calculatedNextReminder.item2));
  }

  _onHoursDoneChanged(
      TaskEditHoursDoneChanged event, Emitter<TaskEditState> emit) {
    var calculatedNextReminder = _calculateNextReminder(
        state.deadline, state.hours, event.hoursDone, state.hoursPerReminder);
    if (calculatedNextReminder.item2.isEmpty) {
      nextReminder.text = DateFormat.yMd().format(calculatedNextReminder.item1);
    }

    emit(state.copyWith(
        hoursDone: event.hoursDone,
        hoursDoneError: _getHoursDoneError(event.hoursDone, state.hours),
        hoursError: _getHoursError(state.hours, event.hoursDone),
        nextReminder: calculatedNextReminder.item2.isEmpty
            ? calculatedNextReminder.item1
            : null,
        nextReminderError: calculatedNextReminder.item2.isEmpty
            ? _getNextReminderError(
                calculatedNextReminder.item1, state.deadline)
            : null,
        hoursPerReminderError: calculatedNextReminder.item2));
  }

  _onHoursPerReminderChanged(
      TaskEditHoursPerReminderChanged event, Emitter<TaskEditState> emit) {
    var calculatedNextReminder = _calculateNextReminder(
        state.deadline, state.hours, state.hoursDone, event.hoursPerReminder);
    String hoursPerReminderError =
        _getHoursPerReminderError(event.hoursPerReminder, state.hours);
    if (hoursPerReminderError.isEmpty) {
      hoursPerReminderError = calculatedNextReminder.item2;
    }
    emit(state.copyWith(
      hoursPerReminder: event.hoursPerReminder,
      hoursPerReminderError: hoursPerReminderError,
      hoursDoneError: _getHoursDoneError(state.hoursDone, state.hours),
      nextReminder: calculatedNextReminder.item1,
      nextReminderError:
          _getNextReminderError(calculatedNextReminder.item1, state.deadline),
    ));
  }

  _onNameChanged(TaskEditNameChanged event, Emitter<TaskEditState> emit) {
    emit(
        state.copyWith(name: event.name, nameError: _getNameError(event.name)));
  }

  _onNextReminderChanged(
      TaskEditNextReminderChanged event, Emitter<TaskEditState> emit) {
    nextReminder.text = DateFormat.yMd().format(event.nextReminder);
    emit(state.copyWith(
      nextReminder: event.nextReminder,
      nextReminderError:
          _getNextReminderError(event.nextReminder, state.deadline),
      deadlineError: _getDeadlineError(state.deadline, event.nextReminder),
    ));
  }

  _onTaskEditCheckAllErrors(
      TaskEditCheckAllErrors event, Emitter<TaskEditState> emit) {
    emit((state.copyWith(
        deadlineError: _getDeadlineError(state.deadline, state.nextReminder),
        hoursError: _getHoursError(state.hours, state.hoursDone),
        hoursDoneError: _getHoursDoneError(state.hoursDone, state.hours),
        hoursPerReminderError:
            _getHoursPerReminderError(state.hoursPerReminder, state.hours),
        nameError: _getNameError(state.name),
        nextReminderError:
            _getNextReminderError(state.nextReminder, state.deadline))));
  }

// All of those should be static,
// so that there is no weird leftover state when checking for errors
  static String _getDeadlineError(DateTime deadline, DateTime nextReminder) {
    if (deadline.isBefore(DateTime.now()) &&
        // I am sincerely sorry for this.
        DateFormat.yMd().format(DateTime.now()) !=
            DateFormat.yMd().format(nextReminder)) {
      return 'Choose date in the future';
    }
    return '';
  }

  static String _getHoursError(double hours, double hoursDone) {
    if (hoursDone > hours) {
      return 'Total hours should be the same or greater than hours done';
    }
    return '';
  }

  static String _getHoursDoneError(double hoursDone, double hours) {
    if (hours < hoursDone) {
      return 'Hours done should be the same or lesser than total hours';
    }
    return '';
  }

  static String _getHoursPerReminderError(
      double hoursPerReminder, double hours) {
    if (hours < hoursPerReminder) {
      return 'Hours per reminder should be smaller that total hours';
    }
    return '';
  }

  static String _getNameError(String name) {
    if (name.length <= 3) {
      return 'Name should have 3 characters or more';
    }
    if (name.length >= 20) {
      return 'Name should have 20 characters or less';
    }
    return '';
  }

  static String _getNextReminderError(
      DateTime nextReminder, DateTime deadline) {
    if (!DateTime.now().isAfter(nextReminder) &&
        // I am sincerely sorry for this.
        DateFormat.yMd().format(DateTime.now()) !=
            DateFormat.yMd().format(nextReminder)) {
      return 'Choose date in the future';
    }
    if (nextReminder.isAfter(deadline) &&
        // I am sincerely sorry for this.
        DateFormat.yMd().format(deadline) !=
            DateFormat.yMd().format(nextReminder)) {
      return 'Next reminder can\'t occur after the deadline';
    }
    return '';
  }

  static Tuple2<DateTime, String> _calculateNextReminder(DateTime deadline,
      double hours, double hoursDone, double hoursPerReminder) {
    DateTime calculatedNextReminder = DateTime.now();
    String error = '';
    try {
      double hoursLeft = hours - hoursDone;
      // To get rid of time - maybe unnecessary
      DateTime nowOnlyDate =
          DateFormat.yMd().parse(DateFormat.yMd().format(DateTime.now()));
      int daysLeft = deadline.difference(DateTime.now()).inDays + 1;

      double daysOfWork = hoursLeft / hoursPerReminder;
      if (daysOfWork > daysLeft) {
        error = 'Not enough time before deadline';
        return Tuple2<DateTime, String>(calculatedNextReminder, error);
      }
      double daysBetweenDaysOfWork = daysLeft.toDouble() / daysOfWork;
      int daysUntilNextReminder = daysBetweenDaysOfWork.floor();

      calculatedNextReminder =
          nowOnlyDate.add(Duration(days: daysUntilNextReminder));
      return Tuple2<DateTime, String>(calculatedNextReminder, error);
      // ignore: empty_catches
    } catch (e) {}
    return Tuple2<DateTime, String>(calculatedNextReminder, error);
  }
}
