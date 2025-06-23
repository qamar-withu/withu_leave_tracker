import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/dashboard/dashboard_bloc.dart';
import 'package:withu_leave_tracker/application/leave_request/leave_request_bloc.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_id.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_type.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_text_field.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_button.dart';

import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/locator.dart';

class CreateLeaveRequestPage extends StatefulWidget {
  const CreateLeaveRequestPage({super.key});

  @override
  State<CreateLeaveRequestPage> createState() => _CreateLeaveRequestPageState();
}

class _CreateLeaveRequestPageState extends State<CreateLeaveRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _commentsController = TextEditingController();

  LeaveRequestType _selectedType = LeaveRequestType.annual;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LeaveRequestBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Leave Request'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocListener<LeaveRequestBloc, LeaveRequestState>(
          bloc: context.read<LeaveRequestBloc>(),
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () => setState(() => _isLoading = true),
              loaded: (_) => setState(() => _isLoading = false),
              submitting: () => setState(() => _isLoading = true),
              submitted: () {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Leave created successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                // Navigate to dashboard after successful creation
                final userId = getIt<FirebaseAuth>().currentUser?.uid;
                if (userId != null) {
                  context.read<DashboardBloc>().add(
                    DashboardEvent.loadDashboardData(userId: userId),
                  );
                }
                context.go('/dashboard');
              },
              error: (failure) {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${failure.message}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Time Off',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Fill in the details below to submit your leave request',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Leave Type
                  Text(
                    'Leave Type',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonFormField<LeaveRequestType>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      items: LeaveRequestType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getLeaveTypeDisplayName(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Date Selection
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 12.h),
                            _buildDateField(
                              context: context,
                              date: _startDate,
                              onDateSelected: (date) =>
                                  setState(() => _startDate = date),
                              hintText: 'Select start date',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 12.h),
                            _buildDateField(
                              context: context,
                              date: _endDate,
                              onDateSelected: (date) =>
                                  setState(() => _endDate = date),
                              hintText: 'Select end date',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Reason
                  Text(
                    'Reason',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    label: 'Reason',
                    controller: _reasonController,
                    hint: 'Enter the reason for your leave request',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Additional Comments
                  Text(
                    'Additional Comments (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    label: 'Comments',
                    controller: _commentsController,
                    hint: 'Any additional information or comments',
                    maxLines: 3,
                  ),
                  SizedBox(height: 32.h),

                  // Days calculation
                  if (_startDate != null && _endDate != null)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.info.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.info),
                          SizedBox(width: 12.w),
                          Text(
                            'Total days: ${_calculateDays()}',
                            style: const TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 32.h),

                  // Submit Button
                  CustomButton(
                    text: 'Submit Request',
                    onPressed: _isLoading ? null : _submitRequest,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required DateTime? date,
    required Function(DateTime) onDateSelected,
    required String hintText,
  }) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                date != null
                    ? '${date.day}/${date.month}/${date.year}'
                    : hintText,
                style: TextStyle(
                  color: date != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  int _calculateDays() {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end dates'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    authState.when(
      initial: () {},
      loading: () {},
      authenticated: (user) {
        final request = LeaveRequest(
          id: UniqueId(LeaveRequestId.generate().value),
          userId: user.id,
          userName: user.fullName,
          teamId: user.teamId,
          projectId: user.projectId,
          type: _selectedType,
          startDate: _startDate!,
          endDate: _endDate!,
          reason: _reasonController.text.trim(),
          comments: _commentsController.text.trim().isEmpty
              ? null
              : _commentsController.text.trim(),
          status: LeaveRequestStatus.pending,
          requestedAt: DateTime.now(),
          managerId: null,
          managerComments: null,
          approvedAt: null,
        );

        context.read<LeaveRequestBloc>().add(
          LeaveRequestEvent.createLeaveRequest(request: request),
        );
      },
      unauthenticated: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to create a leave request'),
            backgroundColor: AppColors.error,
          ),
        );
      },
      failure: (_) {},
    );
  }
}
