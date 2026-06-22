import 'package:astro_gurujii/Setup/app_circular_progress_indicator.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Setup/app_dimens.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';

class AppButtonIcon extends StatelessWidget {
  final String? title;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  final bool isLoading;

  final double? height;
  final double? width;
  final double? borderWidth;
  final double? cornerRadius;

  final Color? backgroundColor;
  final Color? borderColor;

  final TextStyle? textStyle;

  final VoidCallback? onPressed;

  AppButtonIcon({
    this.title,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.height,
    this.width,
    this.borderWidth,
    this.cornerRadius,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: height ?? AppDimens.buttonHeight,
      width: width ?? double.infinity,
      child: ElevatedButton(
        child: _buildChildWidget(),

        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                cornerRadius ?? AppDimens.buttonCornerRadius),
          ),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
          // primary: backgroundColor,
          padding: EdgeInsets.all(0),
        ),
        onPressed: onPressed,

      ),
    );
  }

  Widget _buildChildWidget() {
    if (isLoading) {
      return AppCircularProgressIndicator(color: Colors.white);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leadingIcon ?? Container(),
          title != null
              ? CustomText(
              text: title!,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite)
              : Container(),
          trailingIcon ?? Container(),
        ],
      );
    }
  }
}
