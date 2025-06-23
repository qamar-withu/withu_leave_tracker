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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedTeamId = '';
  String _selectedProjectId = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: SafeArea(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400.w),
                  padding: EdgeInsets.all(32.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Icon(
                            Icons.person_add,
                            size: 80.w,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Center(
                          child: Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Center(
                          child: Text(
                            'Join Withu Leave Tracker',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        CustomTextField(
                          controller: _firstNameController,
                          label: 'First Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Last name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Email is required';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value!)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Team',
                            prefixIcon: Icon(Icons.group_outlined, size: 20.w),
                          ),
                          value: _selectedTeamId.isEmpty
                              ? null
                              : _selectedTeamId,
                          items: [
                            const DropdownMenuItem(
                              value: 'team1',
                              child: Text('Development Team'),
                            ),
                            const DropdownMenuItem(
                              value: 'team2',
                              child: Text('Design Team'),
                            ),
                            const DropdownMenuItem(
                              value: 'team3',
                              child: Text('Marketing Team'),
                            ),
                            const DropdownMenuItem(
                              value: 'team4',
                              child: Text('HR Team'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedTeamId = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please select a team';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Project',
                            prefixIcon: Icon(Icons.work_outline, size: 20.w),
                          ),
                          value: _selectedProjectId.isEmpty
                              ? null
                              : _selectedProjectId,
                          items: [
                            const DropdownMenuItem(
                              value: 'project1',
                              child: Text('WithU'),
                            ),
                            const DropdownMenuItem(
                              value: 'project2',
                              child: Text('Mvmnt'),
                            ),
                            const DropdownMenuItem(
                              value: 'project3',
                              child: Text('URunn'),
                            ),
                            const DropdownMenuItem(
                              value: 'project4',
                              child: Text('HR System'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedProjectId = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please select a project';
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
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
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
                                ScaffoldMessenger.of(context).showSnackBar(
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
                              text: 'Create Account',
                              isLoading: state.maybeWhen(
                                loading: () => true,
                                orElse: () => false,
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context.read<AuthBloc>().add(
                                    AuthEvent.signUpRequested(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      teamId: _selectedTeamId,
                                      projectId: _selectedProjectId,
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
                            onPressed: () => context.go(AppRoutes.login),
                            child: Text(
                              'Already have an account? Sign in',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.primary),
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
      ),
    );
  }
}
