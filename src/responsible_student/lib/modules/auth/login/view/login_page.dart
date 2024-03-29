import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
import 'package:responsible_student/modules/auth/login/bloc/login_bloc.dart';
import 'package:responsible_student/modules/auth/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => LoginBloc(
        authService: RepositoryProvider.of<AuthService>(context),
      ),
      child: const LoginView(),
    );
  }
}
