import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class QuickActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isEnabled;

  const QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isEnabled = true,
  });
}

class ModernQuickActions extends StatelessWidget {
  final List<QuickActionItem> actions;
  final String? sectionTitle;
  final int crossAxisCount;

  const ModernQuickActions({
    super.key,
    required this.actions,
    this.sectionTitle,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null) ...[
          Text(
            sectionTitle!,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive grid layout
            final screenWidth = constraints.maxWidth;
            final effectiveCrossAxisCount = screenWidth > 600
                ? (actions.length > 4 ? 4 : actions.length)
                : crossAxisCount;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: effectiveCrossAxisCount,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.1,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return _buildActionCard(actions[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(QuickActionItem action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.isEnabled ? action.onTap : null,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  action.icon,
                  color: action.isEnabled
                      ? action.color
                      : action.color.withOpacity(0.5),
                  size: 28.w,
                ),
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                action.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: action.isEnabled
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),

              // Subtitle
              Text(
                action.subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: action.isEnabled
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Horizontal quick actions for compact spaces
class HorizontalQuickActions extends StatelessWidget {
  final List<QuickActionItem> actions;
  final String? sectionTitle;

  const HorizontalQuickActions({
    super.key,
    required this.actions,
    this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null) ...[
          Text(
            sectionTitle!,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
        ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: actions.map((action) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: SizedBox(
                  width: 140.w,
                  child: _buildCompactActionCard(action),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActionCard(QuickActionItem action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.isEnabled ? action.onTap : null,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  action.icon,
                  color: action.isEnabled
                      ? action.color
                      : action.color.withOpacity(0.5),
                  size: 24.w,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                action.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: action.isEnabled
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                action.subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: action.isEnabled
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
