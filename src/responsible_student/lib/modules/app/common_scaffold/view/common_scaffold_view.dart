import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/app/common_scaffold/bloc/common_scaffold_bloc.dart';
import 'package:responsible_student/modules/auth/login/bloc/login_bloc.dart';
import 'package:responsible_student/modules/auth/login/view/login_page.dart';

class UserHeaderView extends StatelessWidget {
  const UserHeaderView({super.key, required this.child, required this.title});
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommomScaffoldBloc, CommonScaffoldState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions:
              BlocProvider.of<CommomScaffoldBloc>(context).state.email == ''
                  ? <Widget>[
                      TextButton(
                        onPressed: () {
                          // context
                          //     .read<CommomScaffoldBloc>()
                          //     .add(const UserLogInButtonPressedEvent());
                        },
                        child: const Text('Log in'),
                      )
                    ]
                  : <Widget>[
                      Center(
                        child: Text(BlocProvider.of<CommomScaffoldBloc>(context)
                            .state
                            .email),
                      ),
                      TextButton(
                        onPressed: () {
                          // BlocProvider.of<CommomScaffoldBloc>(context)
                          //     .add(const UserLogOutButtonPressedEvent());
                        },
                        child: const Text('Log out'),
                      )
                    ],
          flexibleSpace: Container(
            color: Colors.orange,
          ),
        ),
        body: child,
      ),
    );
  }
}
