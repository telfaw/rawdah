import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void showSuccess(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  static void logError(String error, StackTrace stackTrace) {
    debugPrint('=== ERROR CAUGHT ===');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
    debugPrint('====================');

    // يمكن إضافة إرسال التقارير إلى Firebase Crashlytics هنا
  }
}