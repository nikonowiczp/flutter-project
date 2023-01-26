import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/app/common_scaffold/bloc/common_scaffold_bloc.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
import 'package:responsible_student/modules/auth/login/bloc/login_bloc.dart';
import 'package:responsible_student/modules/auth/login/view/login_page.dart';
import 'package:responsible_student/modules/user_data/bloc/user_data_bloc.dart';

class UserHeaderView extends StatelessWidget {
  const UserHeaderView({super.key, required this.child, required this.title});
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: ((context, state) => Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: state.entity.email == ''
                  ? <Widget>[
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<UserDataBloc>(context)
                              .add(const UserDataSetShouldLogInEvent());
                          Navigator.of(context).push(LoginPage.route());
                        },
                        child: const Text('Log in'),
                      )
                    ]
                  : <Widget>[
                      Center(
                        child: Text(state.entity.email),
                      ),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<UserDataBloc>(context)
                              .add(const UserDataLoggedOutEvent());
                          Navigator.of(context)
                              .pushReplacement(LoginPage.route());
                        },
                        child: const Text('Log out'),
                      )
                    ],
              flexibleSpace: Container(
                color: Colors.orange,
              ),
            ),
            body: child,
          )),
    );
  }
}
