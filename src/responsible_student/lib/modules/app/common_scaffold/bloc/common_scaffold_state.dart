part of 'common_scaffold_bloc.dart';

abstract class CommonScaffoldState {
  final String email;
  final bool wasLoaded;
  const CommonScaffoldState({this.email = '', this.wasLoaded = true});
}

class CommonScaffoldInitialState extends CommonScaffoldState {
  const CommonScaffoldInitialState();
}
