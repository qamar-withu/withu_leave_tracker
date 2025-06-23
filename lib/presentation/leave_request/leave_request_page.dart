import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/leave_request/leave_request_bloc.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_type.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_button.dart';
import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/routes.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  @override
  void initState() {
    super.initState();
    // Defer loading until after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRequests();
    });
  }

  void _loadRequests() {
    if (!mounted) return;
    final authState = context.read<AuthBloc>().state;
    authState.whenOrNull(
      authenticated: (user) {
        context.read<LeaveRequestBloc>().add(
          LeaveRequestEvent.loadLeaveRequests(userId: user.id.value),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests'),

        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRequests),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              margin: EdgeInsets.all(24.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Leave Requests',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Track and manage all your leave requests',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: 'Create Leave',
                      icon: Icons.add,
                      backgroundColor: Colors.white,
                      textColor: AppColors.primary,
                      onPressed: () => context.go(AppRoutes.createLeaveRequest),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(child: _buildRequestsList()),
          ],
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
          currentIndex: 1, // Leave Requests tab
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
                // Already on leave requests
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
    );
  }

  Widget _buildRequestsList() {
    return BlocBuilder<LeaveRequestBloc, LeaveRequestState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('No requests loaded')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (requests) {
            if (requests.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return _buildRequestCard(requests[index]);
              },
            );
          },
          submitting: () => const Center(child: CircularProgressIndicator()),
          submitted: () {
            _loadRequests();
            return const Center(child: Text('Request updated successfully'));
          },
          error: (failure) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
                SizedBox(height: 16.h),
                Text(
                  'Error: ${failure.message}',
                  style: const TextStyle(color: AppColors.error),
                ),
                SizedBox(height: 16.h),
                CustomButton(text: 'Retry', onPressed: _loadRequests),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64.w, color: AppColors.textSecondary),
          SizedBox(height: 16.h),
          Text(
            'No leave requests found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Create First Leave',
            onPressed: () => context.go(AppRoutes.createLeaveRequest),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(LeaveRequest request) {
    final statusColor = _getStatusColor(request.status);
    final statusIcon = _getStatusIcon(request.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 16.w, color: statusColor),
                    SizedBox(width: 4.w),
                    Text(
                      _getStatusText(request.status),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _getLeaveTypeDisplayName(request.type),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Date range
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16.w,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                '${_formatDate(request.startDate)} - ${_formatDate(request.endDate)}',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8.w),
              Text(
                '(${_calculateDays(request.startDate, request.endDate)} days)',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Reason
          Text(
            'Reason: ${request.reason}',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          ),

          if (request.comments != null) ...[
            SizedBox(height: 8.h),
            Text(
              'Comments: ${request.comments}',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],

          if (request.managerComments != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manager Comments:',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    request.managerComments!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 16.h),

          // Footer
          Row(
            children: [
              Text(
                'Created: ${_formatDateTime(request.requestedAt)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (request.status == LeaveRequestStatus.pending)
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _deleteRequest(request.id.value),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(LeaveRequestStatus status) {
    switch (status) {
      case LeaveRequestStatus.pending:
        return AppColors.warning;
      case LeaveRequestStatus.approved:
        return AppColors.success;
      case LeaveRequestStatus.rejected:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(LeaveRequestStatus status) {
    switch (status) {
      case LeaveRequestStatus.pending:
        return Icons.pending_actions;
      case LeaveRequestStatus.approved:
        return Icons.check_circle;
      case LeaveRequestStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getStatusText(LeaveRequestStatus status) {
    switch (status) {
      case LeaveRequestStatus.pending:
        return 'Pending';
      case LeaveRequestStatus.approved:
        return 'Approved';
      case LeaveRequestStatus.rejected:
        return 'Rejected';
    }
  }

  String _getLeaveTypeDisplayName(LeaveRequestType type) {
    switch (type) {
      case LeaveRequestType.annual:
        return 'Annual Leave';
      case LeaveRequestType.sick:
        return 'Sick Leave';
      case LeaveRequestType.casual:
        return 'Casual Leave';
      case LeaveRequestType.maternity:
        return 'Maternity Leave';
      case LeaveRequestType.paternity:
        return 'Paternity Leave';
      case LeaveRequestType.emergency:
        return 'Emergency Leave';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  int _calculateDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  void _deleteRequest(String requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Leave'),
        content: const Text('Are you sure you want to delete this leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<LeaveRequestBloc>().add(
                LeaveRequestEvent.deleteLeaveRequest(requestId: requestId),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
