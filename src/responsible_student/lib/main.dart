import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsible_student/modules/app/common_scaffold/bloc/common_scaffold_bloc.dart';
import 'package:responsible_student/modules/app/homePage/homePage_view.dart';
import 'package:responsible_student/modules/auth/auth_service/models/user_entity.dart';
import 'package:responsible_student/modules/auth/auth_service/service/auth_service.dart';
import 'package:responsible_student/modules/auth/auth_service/service/firebase_auth_service.dart';
import 'package:responsible_student/modules/auth/login/view/login_page.dart';
import 'package:responsible_student/modules/user_data/bloc/user_data_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ResponsibleStudentApp());
}

class ResponsibleStudentApp extends StatelessWidget {
  const ResponsibleStudentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return RepositoryProvider(
        create: (context) => FirebaseAuthService(
              authService: FirebaseAuth.instance,
            ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UserDataBloc>(create: (context) => UserDataBloc()),
            BlocProvider<CommomScaffoldBloc>(
              create: (context) => CommomScaffoldBloc(),
              lazy: false,
            )
          ],
          child:
              const MaterialApp(title: 'Responsible Student', home: HomePage()),
        ));
  }
}
