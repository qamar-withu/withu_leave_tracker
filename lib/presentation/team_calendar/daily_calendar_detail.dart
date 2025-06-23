import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_type.dart';

class DailyCalendarDetail extends StatefulWidget {
  final List<LeaveRequest> leaveRequests;
  final DateTime? selectedDay;
  const DailyCalendarDetail({
    super.key,
    required this.leaveRequests,
    required this.selectedDay,
  });

  @override
  State<DailyCalendarDetail> createState() => _DailyCalendarDetailState();
}

class _DailyCalendarDetailState extends State<DailyCalendarDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leave Requests for ${widget.selectedDay?.day}/${widget.selectedDay?.month}/${widget.selectedDay?.year}',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _buildSelectedDayEvents(),
        ],
      ),
    );
  }

  Widget _buildSelectedDayEvents() {
    final eventsForDay = widget.leaveRequests;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eventsForDay.isEmpty
              ? Center(
                  child: Text(
                    'No leave requests for this day',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: eventsForDay.length,
                  itemBuilder: (context, index) {
                    final request = eventsForDay[index];
                    return _buildLeaveRequestCard(request);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestCard(LeaveRequest request) {
    Color statusColor;
    IconData statusIcon;

    switch (request.status.value) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: statusColor, width: 4.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${request.userName}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  request.status.value.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.category, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Text(
                request.type.value,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.date_range, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Text(
                '${request.startDate.day}/${request.startDate.month} - ${request.endDate.day}/${request.endDate.month}',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
            ],
          ),
          if (request.reason.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              request.reason,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
