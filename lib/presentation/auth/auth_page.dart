import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/routes.dart';
import 'package:withu_leave_tracker/locator.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AuthBloc>()..add(const AuthEvent.authStateChanged()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (user) =>
                context.pushReplacement(AppRoutes.dashboard),
            unauthenticated: () => context.pushReplacement(AppRoutes.login),
            orElse: () {},
          );
        },
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
