import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/presentation/auth/auth_page.dart';
import 'package:withu_leave_tracker/presentation/auth/login_page.dart';
import 'package:withu_leave_tracker/presentation/auth/register_page.dart';
import 'package:withu_leave_tracker/presentation/dashboard/dashboard_page.dart';
import 'package:withu_leave_tracker/presentation/leave_request/leave_request_page.dart';
import 'package:withu_leave_tracker/presentation/leave_request/create_leave_request_page.dart';
import 'package:withu_leave_tracker/presentation/profile/profile_page.dart';
import 'package:withu_leave_tracker/presentation/team_calendar/team_calendar_page.dart';
import 'package:withu_leave_tracker/presentation/team_calendar/daily_calendar_detail.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/app_page_wrapper.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String leaveRequests = '/leave-requests';
  static const String createLeaveRequest = '/create-leave-request';
  static const String teamCalendar = '/team-calendar';

  static const String profile = '/profile';
  static const String dailyCalendarDetail = '/daily-calendar-detail';
}

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.auth,
  redirect: (context, state) {
    final currentPath = state.uri.path;

    // For now we'll use a simple redirect logic
    // In a full implementation, you'd check actual auth state here

    // Prevent navigation back to auth pages from app pages
    if (currentPath == AppRoutes.auth ||
        currentPath == AppRoutes.login ||
        currentPath == AppRoutes.register) {
      // For web: disable browser back button behavior
      // Users should use in-app navigation
      return null; // Allow for now, but will be controlled by auth state
    }

    return null; // Allow navigation
  },
  routes: [
    GoRoute(
      path: AppRoutes.auth,
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const AppPageWrapper(
        canPop: false, // Dashboard is root level - no browser back
        child: DashboardPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.leaveRequests,
      name: 'leaveRequests',
      builder: (context, state) =>
          const AppPageWrapper(child: LeaveRequestPage()),
    ),
    GoRoute(
      path: AppRoutes.teamCalendar,
      name: 'teamCalendar',
      builder: (context, state) =>
          const AppPageWrapper(child: TeamCalendarPage()),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const AppPageWrapper(child: ProfilePage()),
    ),
    GoRoute(
      path: AppRoutes.createLeaveRequest,
      name: 'createLeaveRequest',
      builder: (context, state) =>
          const AppPageWrapper(child: CreateLeaveRequestPage()),
    ),
    GoRoute(
      path: AppRoutes.dailyCalendarDetail,
      name: 'dailyCalendarDetail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final leaveRequests =
            extra?['leaveRequests'] as List<LeaveRequest>? ?? [];
        final selectedDay = extra?['selectedDay'] as DateTime?;

        return AppPageWrapper(
          child: DailyCalendarDetail(
            leaveRequests: leaveRequests,
            selectedDay: selectedDay,
          ),
        );
      },
    ),
  ],
);
