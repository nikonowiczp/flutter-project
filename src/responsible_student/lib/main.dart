import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsible_student/modules/app/home_page/home_page_view.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
import 'package:responsible_student/modules/auth/auth_service/service/firebase_auth_service.dart';
import 'package:responsible_student/modules/local_notification/bloc/local_notification_bloc.dart';
import 'package:responsible_student/modules/local_notification/service/local_notification_service.dart';
import 'package:responsible_student/modules/user_data/bloc/user_data_bloc.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNoticeService().setup();

  runApp(const ResponsibleStudentApp());
}

class ResponsibleStudentApp extends StatelessWidget {
  const ResponsibleStudentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthService>(
            lazy: false,
            create: (context) => FirebaseAuthService(
              authService: FirebaseAuth.instance,
            ),
          ),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<LocalNotificationBloc>(
                  lazy: false, create: (context) => LocalNotificationBloc()),
              BlocProvider<UserDataBloc>(
                  lazy: false,
                  create: (context) => UserDataBloc(
                      RepositoryProvider.of<AuthService>(context),
                      FirebaseFirestore.instance,
                      BlocProvider.of<LocalNotificationBloc>(context))),
            ],
            child: const MaterialApp(
              title: 'Responsible Student',
              home: HomePage(),
            )));
  }
}
