import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsible_student/data/auth_service.dart';
import 'package:responsible_student/modules/auth/auth_cubit.dart';
import 'package:responsible_student/modules/auth/auth_gate.dart';

class WaterLogApp1 extends StatelessWidget {
  const WaterLogApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AuthService(
        firebaseAuth: FirebaseAuth.instance,
      ),
      child: BlocProvider(
        create: (ctx) => AuthCubit(
          authService: ctx.read(),
        ),
        child: MaterialApp(
          title: 'WaterLog',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('WaterLog'),
            ),
            body: const AuthGate(),
          ),
        ),
      ),
    );
  }
}
