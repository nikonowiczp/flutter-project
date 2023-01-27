import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsible_student/modules/app/home_page/home_page_view.dart';
import 'package:responsible_student/modules/auth/signup/bloc/signup_bloc.dart';
import 'package:responsible_student/modules/user_data/bloc/user_data_bloc.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          BlocProvider.of<UserDataBloc>(context)
              .add(const UserDataLoggedInEvent(true));
          Navigator.of(context).pushReplacement(HomePage.route());
        }
        if (state.status == SignupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: const _SignupForm(),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _CreateAccountEmail(),
            SizedBox(height: 30.0),
            _CreateAccountPassword(),
            SizedBox(height: 30.0),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _CreateAccountEmail extends StatelessWidget {
  const _CreateAccountEmail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        onChanged: (value) => context
            .read<SignupBloc>()
            .add(SignupEmailChangedEvent(email: value)),
        decoration: const InputDecoration(hintText: 'Email'),
      ),
    );
  }
}

class _CreateAccountPassword extends StatelessWidget {
  const _CreateAccountPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
        onChanged: (value) => context
            .read<SignupBloc>()
            .add(SignupPasswordChangedEvent(password: value)),
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
      onPressed: () => context.read<SignupBloc>().add(
            const SignupButtonPressedEvent(),
          ),
      child: const Text('Create Account'),
    );
  }
}
