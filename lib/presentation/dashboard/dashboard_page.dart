import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/dashboard/dashboard_bloc.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/routes.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/modern_stats_card.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/modern_request_card.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/modern_hero_section.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/modern_quick_actions.dart';
import 'package:withu_leave_tracker/locator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    final userId = getIt<FirebaseAuth>().currentUser?.uid;
    if (userId != null) {
      context.read<DashboardBloc>().add(
        DashboardEvent.loadDashboardData(userId: userId),
      );
    }
  }

  void _loadDashboardData() {
    final authState = context.read<AuthBloc>().state;
    authState.whenOrNull(
      authenticated: (user) {
        context.read<DashboardBloc>().add(
          DashboardEvent.loadDashboardData(userId: user.id.value),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<DashboardBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 20.w,
                ),
              ),
              onPressed: () {
                // TODO: Implement notifications
              },
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.secondary,
                  size: 20.w,
                ),
              ),
              onPressed: () => context.go(AppRoutes.profile),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => _loadDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(24.w),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return authState.when(
                  initial: () =>
                      const Center(child: CircularProgressIndicator()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  authenticated: (user) => _buildDashboardContent(user.name),
                  unauthenticated: () => const Center(
                    child: Text('Please log in to access the dashboard'),
                  ),
                  failure: (failure) =>
                      Center(child: Text('Error: ${failure.message}')),
                );
              },
            ),
          ),
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
            currentIndex: 0,
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
                  // Already on dashboard
                  break;
                case 1:
                  context.go(AppRoutes.leaveRequests);
                  break;
                case 2:
                  context.go(AppRoutes.teamCalendar);
                  break;
                case 3:
                  context.go(AppRoutes.profile);
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

  Widget _buildDashboardContent(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern Hero Welcome Section
        WelcomeCard(
          userName: userName,
          subtitle:
              'Manage your leave requests and track your team\'s availability',
        ),
        SizedBox(height: 32.h),

        // Stats Overview
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return state.when(
              initial: () => _buildModernStatsGrid(isLoading: true),
              loading: () => _buildModernStatsGrid(isLoading: true),
              loaded: (stats, recentRequests) => _buildModernStatsGrid(
                pendingRequests: stats.pendingRequests,
                approvedRequests: stats.approvedRequests,
                remainingDays: stats.remainingLeaveDays,
                teamRequests: stats.teamPendingRequests,
                isLoading: false,
              ),
              error: (failure) => _buildModernStatsGrid(isLoading: false),
            );
          },
        ),
        SizedBox(height: 32.h),

        // Quick Actions
        ModernQuickActions(
          sectionTitle: 'Quick Actions',
          actions: [
            QuickActionItem(
              title: 'Create Leave',
              subtitle: 'Submit new leave',
              icon: Icons.event_note_outlined,
              color: AppColors.primary,
              onTap: () => context.push(AppRoutes.createLeaveRequest),
            ),
            QuickActionItem(
              title: 'View Requests',
              subtitle: 'Check status',
              icon: Icons.list_alt_outlined,
              color: AppColors.secondary,
              onTap: () => context.push(AppRoutes.leaveRequests),
            ),
            QuickActionItem(
              title: 'Team Calendar',
              subtitle: 'View availability',
              icon: Icons.calendar_today_outlined,
              color: AppColors.info,
              onTap: () => context.push(AppRoutes.teamCalendar),
            ),
            QuickActionItem(
              title: 'Profile',
              subtitle: 'Update details',
              icon: Icons.person_outline,
              color: AppColors.warning,
              onTap: () => context.push(AppRoutes.profile),
            ),
          ],
        ),
        SizedBox(height: 32.h),

        // Recent Requests
        Text(
          'Recent Requests',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        BlocBuilder<DashboardBloc, DashboardState>(
          bloc: context.read<DashboardBloc>(),
          builder: (context, state) {
            return state.when(
              initial: () => _buildModernRecentRequests(isLoading: true),
              loading: () => _buildModernRecentRequests(isLoading: true),
              loaded: (stats, recentRequests) => _buildModernRecentRequests(
                requests: recentRequests,
                isLoading: false,
              ),
              error: (failure) => _buildModernRecentRequests(isLoading: false),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModernStatsGrid({
    int? pendingRequests,
    int? approvedRequests,
    int? remainingDays,
    int? teamRequests,
    bool isLoading = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = screenWidth > 800 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.0,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const ModernStatsCard(
                title: 'Loading...',
                value: '--',
                subtitle: 'Please wait',
                icon: Icons.hourglass_empty,
                color: AppColors.textSecondary,
                isLoading: true,
              );
            }

            switch (index) {
              case 0:
                return ModernStatsCard(
                  title: 'Pending Requests',
                  value: '${pendingRequests ?? 0}',
                  subtitle: 'Awaiting approval',
                  icon: Icons.pending_actions_outlined,
                  color: AppColors.warning,
                  trend: '${pendingRequests ?? 0} pending',
                  showTrend: true,
                );
              case 1:
                return ModernStatsCard(
                  title: 'Approved',
                  value: '${approvedRequests ?? 0}',
                  subtitle: 'This year',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  trend: '${approvedRequests ?? 0} approved',
                  showTrend: true,
                );
              case 2:
                return ModernStatsCard(
                  title: 'Remaining Days',
                  value: '${remainingDays ?? 30}',
                  subtitle: 'Available balance',
                  icon: Icons.calendar_today_outlined,
                  color: AppColors.info,
                  trend: remainingDays != null
                      ? '$remainingDays days left'
                      : '30 days available',
                  showTrend: true,
                );
              case 3:
                return ModernStatsCard(
                  title: 'Team Requests',
                  value: '${teamRequests ?? 0}',
                  subtitle: 'Pending review',
                  icon: Icons.group_outlined,
                  color: AppColors.secondary,
                  trend: '2 new today',
                  showTrend: true,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildModernRecentRequests({List? requests, bool isLoading = false}) {
    if (isLoading) {
      return Column(
        children: List.generate(
          3,
          (index) => const ModernRequestCardSkeleton(),
        ),
      );
    }

    // Use mock data if no requests
    final displayRequests = requests?.isNotEmpty == true
        ? requests!
        : _getMockRequests();

    return Column(
      children: displayRequests.take(5).map<Widget>((request) {
        if (requests?.isNotEmpty == true) {
          // Real request data
          return ModernRequestCard(
            title: _getLeaveTypeDisplayName(request.type),
            subtitle:
                '${_formatDate(request.startDate)} - ${_formatDate(request.endDate)}',
            status: _getRequestStatusText(request.status),
            statusColor: _getRequestStatusColor(request.status),
            leadingIcon: _getLeaveTypeIcon(request.type),
            onTap: () => context.go('${AppRoutes.leaveRequests}/${request.id}'),
            additionalInfo:
                '${_calculateDays(request.startDate, request.endDate)} days',
          );
        } else {
          // Mock data
          return ModernRequestCard(
            title: request['type'] as String,
            subtitle: request['dates'] as String,
            status: request['status'] as String,
            statusColor: request['color'] as Color,
            leadingIcon: request['icon'] as IconData,
            onTap: () => context.go(AppRoutes.leaveRequests),
            additionalInfo: request['duration'] as String?,
          );
        }
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getMockRequests() {
    return [];
  }

  IconData _getLeaveTypeIcon(dynamic type) {
    // Return appropriate icon based on leave type
    return Icons.event_note_outlined;
  }

  int _calculateDays(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  Color _getRequestStatusColor(status) {
    // TODO: Implement proper status color mapping
    return AppColors.warning; // Placeholder
  }

  String _getRequestStatusText(status) {
    // TODO: Implement proper status text mapping
    return 'Pending'; // Placeholder
  }

  String _getLeaveTypeDisplayName(type) {
    // TODO: Implement proper type display name mapping
    return 'Leave Request'; // Placeholder
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
