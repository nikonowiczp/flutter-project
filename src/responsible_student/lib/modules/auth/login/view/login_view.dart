import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/app/home_page/home_page_view.dart';
import 'package:responsible_student/modules/auth/login/bloc/login_bloc.dart';
import 'package:responsible_student/modules/auth/signup/view/signup_page.dart';
import 'package:responsible_student/modules/user_data/bloc/user_data_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            if (BlocProvider.of<UserDataBloc>(context).state.tasks.length > 0) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Basic dialog title'),
                      content: const Text('Do you want to synchronize'
                          ' data on your device with cloud? '
                          ' If not, all of your local data will be lost'),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Lose data'),
                          onPressed: () {
                            BlocProvider.of<UserDataBloc>(context)
                                .add(const UserDataLoggedInEvent(false));
                            Navigator.of(context)
                                .pushReplacement(HomePage.route());
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Synchronize'),
                          onPressed: () {
                            BlocProvider.of<UserDataBloc>(context)
                                .add(const UserDataLoggedInEvent(true));
                            Navigator.of(context)
                                .pushReplacement(HomePage.route());
                          },
                        ),
                      ],
                    );
                  });
            } else {
              BlocProvider.of<UserDataBloc>(context)
                  .add(const UserDataLoggedInEvent(true));
              Navigator.of(context).pushReplacement(HomePage.route());
            }
          }
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocListener<UserDataBloc, UserDataState>(
          listener: (context, userDataState) {
            if (userDataState.shouldBeLoggedIn && !userDataState.isLoggedIn) {
              Navigator.of(context).pushReplacement(HomePage.route());
            }
          },
          child: const _LoginForm(),
        ));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: OverflowBox(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LoginEmail(),
            _LoginPassword(),
            _SubmitButton(),
            const _CreateAccountButton(),
            const _ContinueWithoutLogginIn()
          ],
        ),
      ),
    );
  }
}

class _LoginEmail extends StatelessWidget {
  const _LoginEmail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        onChanged: ((value) {
          context.read<LoginBloc>().add(LoginEmailChangedEvent(email: value));
        }),
        decoration: const InputDecoration(hintText: 'Email'),
      ),
    );
  }
}

class _LoginPassword extends StatelessWidget {
  const _LoginPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        onChanged: ((value) {
          context
              .read<LoginBloc>()
              .add(LoginPasswordChangedEvent(password: value));
        }),
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<LoginBloc>().add(
              const LoginButtonPressedEvent(),
            );
      },
      child: const Text('Login'),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupPage(),
          ),
        );
      },
      child: const Text('Create Account'),
    );
  }
}

class _ContinueWithoutLogginIn extends StatelessWidget {
  const _ContinueWithoutLogginIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        BlocProvider.of<UserDataBloc>(context)
            .add(const UserDataSetShouldNotLogInEvent());
        Navigator.of(context).pushReplacement(HomePage.route());
      },
      child: const Text('Continue without logging in'),
    );
  }
}
