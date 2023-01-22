import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/auth/auth_cubit.dart';
import 'package:responsible_student/modules/auth/authorized_page.dart';
import 'package:responsible_student/modules/auth/unauthorized_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return state is SignedInState
            ? const AuthorizedPage()
            : const UnauthorizedPage();
      },
    );
  }
}
