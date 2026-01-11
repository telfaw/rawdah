import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import 'error_handler.dart';

class AppUtils {
  // حفظ البيانات محلياً
  static Future<void> saveData(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      }
    } catch (e) {
      ErrorHandler.logError("Error saving data: $e", StackTrace.current);
    }
  }

  // قراءة البيانات المحلية
  static Future<dynamic> getData(String key, dynamic defaultValue) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (defaultValue is String) {
        return prefs.getString(key) ?? defaultValue;
      } else if (defaultValue is int) {
        return prefs.getInt(key) ?? defaultValue;
      } else if (defaultValue is bool) {
        return prefs.getBool(key) ?? defaultValue;
      } else if (defaultValue is double) {
        return prefs.getDouble(key) ?? defaultValue;
      } else if (defaultValue is List<String>) {
        return prefs.getStringList(key) ?? defaultValue;
      }
      return defaultValue;
    } catch (e) {
      ErrorHandler.logError("Error getting data: $e", StackTrace.current);
      return defaultValue;
    }
  }

  // حذف البيانات المحلية
  static Future<void> removeData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      ErrorHandler.logError("Error removing data: $e", StackTrace.current);
    }
  }

  // التحقق من اليوم الجديد
  static Future<bool> isNewDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String today = DateTime.now().toIso8601String().split('T')[0];
      final String? lastSavedDate = prefs.getString("last_date");
      return lastSavedDate != today;
    } catch (e) {
      ErrorHandler.logError("Error checking new day: $e", StackTrace.current);
      return true;
    }
  }

  // تحديث تاريخ اليوم
  static Future<void> updateTodayDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String today = DateTime.now().toIso8601String().split('T')[0];
      await prefs.setString("last_date", today);
    } catch (e) {
      ErrorHandler.logError("Error updating date: $e", StackTrace.current);
    }
  }

  // الحصول على التحية المناسبة للوقت
  static String getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "صباح الخير";
    } else if (hour < 17) {
      return "مساء الخير";
    } else {
      return "مساء النور";
    }
  }

  // تنسيق الأرقام العربية
  static String formatArabicNumber(int number) {
    final arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((digit) {
      return arabicDigits[int.parse(digit)];
    }).join();
  }

  // إنشاء نص عشوائي من القائمة
  static String getRandomText(List<String> texts) {
    if (texts.isEmpty) return "";
    final random = DateTime.now().millisecond;
    return texts[random % texts.length];
  }

  // تأثير الاهتزاز الخفيف
  static Future<void> lightVibration() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // لا حاجة لمعالجة الخطأ هنا
    }
  }

  // تأثير الاهتزاز القوي
  static Future<void> heavyVibration() async {
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      // لا حاجة لمعالجة الخطأ هنا
    }
  }

  // نسخ النص إلى الحافظة
  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      ErrorHandler.logError("Error copying to clipboard: $e", StackTrace.current);
    }
  }

  // فتح رابط
  static Future<void> openLink(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ErrorHandler.logError("Error opening link: $e", StackTrace.current);
    }
  }

  // حساب نسبة الإنجاز
  static double calculateProgress(int current, int total) {
    if (total == 0) return 0.0;
    return (current / total).clamp(0.0, 1.0);
  }

  // تنسيق الوقت
  static String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // التحقق من صحة الإيميل
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // التحقق من صحة رقم الهاتف
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }

  // إنشاء ID فريد
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // تقسيم النص إلى أسطر
  static List<String> splitTextIntoLines(String text, int maxLength) {
    List<String> lines = [];
    for (int i = 0; i < text.length; i += maxLength) {
      int end = (i + maxLength < text.length) ? i + maxLength : text.length;
      lines.add(text.substring(i, end));
    }
    return lines;
  }

  // حساب عدد الكلمات
  static int countWords(String text) {
    return text.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  // إزالة علامات الترقيم
  static String removePunctuation(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  // تحويل إلى أحرف كبيرة
  static String toTitleCase(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}