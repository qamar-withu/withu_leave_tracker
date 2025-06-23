import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/application/team_calendar/team_calendar_bloc.dart';
import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';

import 'package:withu_leave_tracker/locator.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_button.dart';
import 'package:withu_leave_tracker/routes.dart';

class TeamCalendarPage extends StatefulWidget {
  const TeamCalendarPage({super.key});

  @override
  State<TeamCalendarPage> createState() => _TeamCalendarPageState();
}

class _TeamCalendarPageState extends State<TeamCalendarPage> {
  late TeamCalendarBloc _teamCalendarBloc;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _teamCalendarBloc = getIt<TeamCalendarBloc>();
    _selectedDay = DateTime.now();
    _loadTeamCalendar();
  }

  void _loadTeamCalendar() {
    _teamCalendarBloc.add(const TeamCalendarEvent.loadTeamCalendar());
  }

  @override
  void dispose() {
    _teamCalendarBloc.close();
    super.dispose();
  }

  List<LeaveRequest> _getEventsForDay(DateTime day, List<LeaveRequest> events) {
    return events.where((event) {
      return (day.isAfter(event.startDate.subtract(const Duration(days: 1))) &&
              day.isBefore(event.endDate.add(const Duration(days: 1)))) ||
          isSameDay(day, event.startDate) ||
          isSameDay(day, event.endDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _teamCalendarBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Team Calendar',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                await context.push(AppRoutes.createLeaveRequest);
              },
              tooltip: 'Create Leave',
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                _teamCalendarBloc.add(
                  const TeamCalendarEvent.refreshCalendar(),
                );
              },
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: BlocBuilder<TeamCalendarBloc, TeamCalendarState>(
          builder: (context, state) {
            return state.when(
              initial: () =>
                  const Center(child: Text('Loading team calendar...')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (leaveRequests) => _buildCalendarView(leaveRequests),
              creating: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Creating leave...'),
                  ],
                ),
              ),
              created: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    SizedBox(height: 16),
                    Text('Leave created successfully!'),
                  ],
                ),
              ),
              error: (failure) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      'Error loading calendar',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      failure.when(
                        serverError: (msg) => msg ?? 'Server error occurred',
                        networkError: (msg) => msg ?? 'Network error occurred',
                        authenticationFailure: (msg) =>
                            msg ?? 'Authentication failed',
                        permissionDenied: (msg) => msg ?? 'Permission denied',
                        notFound: (msg) => msg ?? 'Resource not found',
                        validationError: (msg) => msg,
                        unknownError: (msg) => msg ?? 'Unknown error occurred',
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _loadTeamCalendar,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
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
            currentIndex: 2, // Team Calendar tab
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
                  // Already on team calendar
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

  Widget _buildCalendarView(List<LeaveRequest> leaveRequests) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TableCalendar<LeaveRequest>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _getEventsForDay(day, leaveRequests),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red[400]),
              holidayTextStyle: TextStyle(color: Colors.red[400]),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
        CustomButton(
          text: 'Show Details',
          onPressed: () {
            if (_selectedDay != null) {
              final events = _getEventsForDay(_selectedDay!, leaveRequests);
              if (events.isNotEmpty) {
                // Navigate to details page with selected day events
                context.push(
                  AppRoutes.dailyCalendarDetail,
                  extra: {'selectedDay': _selectedDay, 'leaveRequests': events},
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No events found for selected day'),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a day first')),
              );
            }
          },
        ),
      ],
    );
  }
}
