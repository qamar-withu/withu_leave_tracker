import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/profile/profile_bloc.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/domain/auth/value_objects/user_role.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_text_field.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_button.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/modern_profile_widgets.dart';
import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/locator.dart';
import 'package:withu_leave_tracker/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEditingProfile = false;
  bool _isChangingPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return authState.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  authenticated: (user) => IconButton(
                    icon: Icon(
                      _isEditingProfile || _isChangingPassword
                          ? Icons.close
                          : Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isEditingProfile || _isChangingPassword) {
                          _isEditingProfile = false;
                          _isChangingPassword = false;
                          _resetForm(user);
                        } else {
                          _isEditingProfile = true;
                          _initializeForm(user);
                        }
                      });
                    },
                  ),
                  unauthenticated: () => const SizedBox.shrink(),
                  failure: (failure) => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return authState.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              authenticated: (user) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      // Modern Profile Header
                      ModernProfileHeader(
                        name: user.name,
                        email: user.email.value,
                        role: _getUserRoleDisplayName(user.role),
                        onEditPressed: () {
                          // Handle edit pressed
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Personal Information Section
                      if (_isEditingProfile)
                        _buildEditProfileForm(user)
                      else
                        ModernProfileCard(
                          title: 'Personal Information',
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Full Name',
                                user.name,
                                Icons.person_outline,
                              ),
                              _buildInfoRow(
                                'Email',
                                user.email.value,
                                Icons.email_outlined,
                              ),
                              _buildInfoRow(
                                'Phone',
                                user.phoneNumber ?? 'Not provided',
                                Icons.phone_outlined,
                              ),
                              _buildInfoRow(
                                'Role',
                                _getUserRoleDisplayName(user.role),
                                Icons.work_outline,
                              ),
                              SizedBox(height: 16.h),
                              CustomButton(
                                text: 'Edit Profile',
                                onPressed: () => setState(() {
                                  _isEditingProfile = true;
                                  _initializeForm(user);
                                }),
                                variant: ButtonVariant.outline,
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 20.h),

                      // Security Section
                      if (_isChangingPassword)
                        _buildChangePasswordForm()
                      else
                        ModernProfileCard(
                          title: 'Security',
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Password',
                                '••••••••',
                                Icons.lock_outline,
                              ),
                              SizedBox(height: 16.h),
                              CustomButton(
                                text: 'Change Password',
                                onPressed: () =>
                                    setState(() => _isChangingPassword = true),
                                variant: ButtonVariant.outline,
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 20.h),

                      // Account Information
                      ModernProfileCard(
                        title: 'Account Information',
                        child: Column(
                          children: [
                            _buildInfoRow('User ID', user.id.value),
                            _buildInfoRow('Team ID', user.teamId.value),
                            _buildInfoRow(
                              'Role',
                              _getRoleDisplayName(user.role),
                            ),
                            _buildInfoRow(
                              'Join Date',
                              _formatDate(user.createdAt),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Logout Button
                      CustomButton(
                        text: 'Logout',
                        onPressed: () => _showLogoutDialog(context),
                        variant: ButtonVariant.outline,
                        icon: Icons.logout,
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                );
              },
              unauthenticated: () => const Center(
                child: Text('Please log in to view your profile'),
              ),
              failure: (failure) =>
                  Center(child: Text('Error: ${failure.message}')),
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 3, // Profile tab
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            selectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go(AppRoutes.dashboard);
                  break;
                case 1:
                  context.go(AppRoutes.leaveRequests);
                  break;
                case 2:
                  context.go(AppRoutes.teamCalendar);
                  break;
                case 3:
                  // Already on profile
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_note_outlined),
                activeIcon: Icon(Icons.event_note),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileForm(dynamic user) {
    return Form(
      key: _formKey,
      child: ModernProfileCard(
        title: 'Edit Profile',
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enabled: false, // Email usually shouldn't be editable
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _phoneController,
              label: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    onPressed: () => setState(() {
                      _isEditingProfile = false;
                      _resetForm(user);
                    }),
                    variant: ButtonVariant.outline,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'Save Changes',
                    onPressed: _updateProfile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return Form(
      key: _formKey,
      child: ModernProfileCard(
        title: 'Change Password',
        child: Column(
          children: [
            CustomTextField(
              controller: _currentPasswordController,
              label: 'Current Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _newPasswordController,
              label: 'New Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    onPressed: () => setState(() {
                      _isChangingPassword = false;
                      _currentPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    }),
                    variant: ButtonVariant.outline,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'Change Password',
                    onPressed: _changePassword,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [IconData? icon]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20.sp, color: AppColors.textSecondary),
            SizedBox(width: 12.w),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _initializeForm(dynamic user) {
    _nameController.text = user.name;
    _emailController.text = user.email.value;
    _phoneController.text = user.phoneNumber ?? '';
  }

  void _resetForm(dynamic user) {
    _nameController.text = user.name;
    _emailController.text = user.email.value;
    _phoneController.text = user.phoneNumber ?? '';
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthBloc>().state;
    authState.whenOrNull(
      authenticated: (user) {
        // Create updated user object with new values
        final updatedUser = user.copyWith(
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          updatedAt: DateTime.now(),
        );
        context.read<ProfileBloc>().add(
          ProfileEvent.updateProfile(user: updatedUser),
        );
      },
    );
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;

    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All password fields are required'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<ProfileBloc>().add(
      ProfileEvent.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const AuthEvent.signOutRequested());
              context.pushReplacement(AppRoutes.login);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _getUserRoleDisplayName(UserRole role) {
    switch (role.runtimeType.toString()) {
      case 'Employee':
        return 'Employee';
      case 'Manager':
        return 'Manager';
      case 'Admin':
        return 'Administrator';
      default:
        return 'Unknown';
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role.runtimeType.toString()) {
      case 'Employee':
        return 'Employee';
      case 'Manager':
        return 'Manager';
      case 'Admin':
        return 'Administrator';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
