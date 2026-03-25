import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : isSuccess
                      ? Icons.check_circle_outline_rounded
                      : Icons.info_outline_rounded,
              color: isError
                  ? AppColors.error
                  : isSuccess
                      ? AppColors.success
                      : AppColors.secondary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
