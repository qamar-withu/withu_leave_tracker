import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

enum ButtonVariant { primary, secondary, outline, ghost, gradient }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool fullWidth;
  final double? elevation;

  // Legacy properties for backwards compatibility
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.fullWidth = true,
    this.elevation,
    this.isOutlined = false,
  });

  // Legacy constructor for backwards compatibility
  const CustomButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.fullWidth = true,
    this.elevation,
  }) : variant = ButtonVariant.outline,
       isOutlined = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? (width ?? double.infinity) : width,
      height: height ?? 56.h,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (isOutlined) {
      return _buildOutlineButton(context);
    }

    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton(context);
      case ButtonVariant.secondary:
        return _buildSecondaryButton(context);
      case ButtonVariant.outline:
        return _buildOutlineButton(context);
      case ButtonVariant.ghost:
        return _buildGhostButton(context);
      case ButtonVariant.gradient:
        return _buildGradientButton(context);
    }
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? AppColors.textLight,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16.r),
        ),
        elevation: elevation ?? 0,
        shadowColor: Colors.transparent,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return FilledButton.tonal(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.surfaceVariant,
        foregroundColor: textColor ?? AppColors.primary,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16.r),
        ),
        elevation: elevation ?? 0,
        shadowColor: Colors.transparent,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildOutlineButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16.r),
        ),
        side: BorderSide(
          color: backgroundColor ?? AppColors.primary,
          width: 1.5,
        ),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildGhostButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16.r),
        ),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(16.r),
          child: Container(
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Center(child: _buildContent()),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: 20.h,
        width: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.gradient ||
                    variant == ButtonVariant.primary
                ? Colors.white
                : AppColors.primary,
          ),
        ),
      );
    }

    // Handle leading and trailing icons
    List<Widget> children = [];

    if (leadingIcon != null) {
      children.add(Icon(leadingIcon, size: 20.w));
      children.add(SizedBox(width: 8.w));
    }

    if (icon != null) {
      children.add(Icon(icon, size: 20.w));
      children.add(SizedBox(width: 8.w));
    }

    children.add(
      Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );

    if (trailingIcon != null) {
      children.add(SizedBox(width: 8.w));
      children.add(Icon(trailingIcon, size: 20.w));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
