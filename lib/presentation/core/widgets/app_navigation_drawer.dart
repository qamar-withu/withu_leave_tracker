import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/routes.dart';

class AppNavigationDrawer extends StatelessWidget {
  final String currentRoute;

  const AppNavigationDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      child: Column(
        children: [
          // Header section
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture placeholder
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(32.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // User name and email
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return state.whenOrNull(
                              authenticated: (user) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    user.email.value,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ) ??
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Name',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'user@example.com',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavigationItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRoutes.dashboard,
                  isActive: currentRoute == AppRoutes.dashboard,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.event_note_outlined,
                  activeIcon: Icons.event_note,
                  title: 'Leave Requests',
                  route: AppRoutes.leaveRequests,
                  isActive: currentRoute == AppRoutes.leaveRequests,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.add_circle_outline,
                  activeIcon: Icons.add_circle,
                  title: 'Create Leave',
                  route: AppRoutes.createLeaveRequest,
                  isActive: currentRoute == AppRoutes.createLeaveRequest,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month,
                  title: 'Team Calendar',
                  route: AppRoutes.teamCalendar,
                  isActive: currentRoute == AppRoutes.teamCalendar,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  title: 'Profile',
                  route: AppRoutes.profile,
                  isActive: currentRoute == AppRoutes.profile,
                ),

                // Divider
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: const Divider(color: AppColors.borderColor),
                ),

                // Settings
                _buildNavigationItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                  isActive: currentRoute == '/settings',
                ),

                // Help & Support
                _buildNavigationItem(
                  context: context,
                  icon: Icons.help_outline,
                  activeIcon: Icons.help,
                  title: 'Help & Support',
                  route: '/help',
                  isActive: currentRoute == '/help',
                ),
              ],
            ),
          ),

          // Logout section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.borderColor, width: 1),
              ),
            ),
            child: _buildLogoutItem(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String route,
    required bool isActive,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: isActive
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
          size: 24.sp,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop(); // Close drawer
          if (!isActive) {
            context.go(route);
          }
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.error.withOpacity(0.05),
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: AppColors.error, size: 24.sp),
        title: Text(
          'Logout',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.error,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop(); // Close drawer
          _showLogoutDialog(context);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(
                  const AuthEvent.signOutRequested(),
                );
                context.go(AppRoutes.auth);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
