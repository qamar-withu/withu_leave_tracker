import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/routes.dart';
import 'package:withu_leave_tracker/locator.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_text_field.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400.w),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 60.h),
                                Center(
                                  child: Icon(
                                    Icons.calendar_today,
                                    size: 80.w,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Center(
                                  child: Text(
                                    'Withu Leave Tracker',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Center(
                                  child: Text(
                                    'Sign in to your account',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                                SizedBox(height: 48.h),
                                CustomTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Email is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  isPassword: true,
                                  prefixIcon: Icons.lock_outline,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24.h),
                                BlocConsumer<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                    state.maybeWhen(
                                      authenticated: (user) =>
                                          context.go(AppRoutes.dashboard),
                                      failure: (failure) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(failure.toString()),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      },
                                      orElse: () {},
                                    );
                                  },
                                  builder: (context, state) {
                                    return CustomButton(
                                      text: 'Sign In',
                                      isLoading: state.maybeWhen(
                                        loading: () => true,
                                        orElse: () => false,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          context.read<AuthBloc>().add(
                                            AuthEvent.signInRequested(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Center(
                                  child: TextButton(
                                    onPressed: () =>
                                        context.go(AppRoutes.register),
                                    child: Text(
                                      "Don't have an account? Sign up",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
