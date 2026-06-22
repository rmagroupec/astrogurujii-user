import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_button.dart';

class AppWhiteButton extends AppButton {
  AppWhiteButton({
    @required String? title,
    bool isLoading = false,
    VoidCallback? onPressed,
  }) : super(
          title: title,
          isLoading: isLoading,
          onPressed: onPressed,
          textStyle: TextStyle(
            fontSize: 16,
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.white,
        );
}
