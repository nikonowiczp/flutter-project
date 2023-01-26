import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
import 'package:responsible_student/modules/auth/auth_service/service/firebase_auth_service.dart';
import 'package:responsible_student/modules/auth/signup/bloc/signup_bloc.dart';
import 'package:responsible_student/modules/auth/signup/view/signup_view.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => SignupBloc(
        authService: context.read<AuthService>(),
      ),
      child: const SignUpView(),
    );
  }
}
