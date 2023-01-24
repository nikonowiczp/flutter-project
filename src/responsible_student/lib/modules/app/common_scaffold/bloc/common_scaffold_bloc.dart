import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';

part 'common_scaffold_event.dart';
part 'common_scaffold_state.dart';

class CommomScaffoldBloc
    extends Bloc<CommonScaffoldEvent, CommonScaffoldState> {
  CommomScaffoldBloc() : super(const CommonScaffoldInitialState()) {}
}
