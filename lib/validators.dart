import 'constants.dart';

class Validators {
  // التحقق من الاسم
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.length < 2) {
      return 'الاسم قصير جداً';
    }
    if (value.length > 50) {
      return 'الاسم طويل جداً';
    }
    if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(value)) {
      return 'الاسم يجب أن يكون باللغة العربية';
    }
    return null;
  }

  // التحقق من البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!_isValidEmail(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  // التحقق من رقم الهاتف
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!_isValidPhone(value)) {
      return 'صيغة رقم الهاتف غير صحيحة';
    }
    return null;
  }

  // التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير، حرف صغير، ورقم';
    }
    return null;
  }

  // التحقق من تأكيد كلمة المرور
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != originalPassword) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  // التحقق من النص
  static String? validateText(String? value, String fieldName, {int minLength = 1, int maxLength = 1000}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    if (value.length < minLength) {
      return '$fieldName قصير جداً (الحد الأدنى $minLength حرف)';
    }
    if (value.length > maxLength) {
      return '$fieldName طويل جداً (الحد الأقصى $maxLength حرف)';
    }
    return null;
  }

  // التحقق من الرقم
  static String? validateNumber(String? value, String fieldName, {int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName يجب أن يكون رقماً';
    }
    if (min != null && number < min) {
      return '$fieldName يجب أن يكون على الأقل $min';
    }
    if (max != null && number > max) {
      return '$fieldName يجب أن لا يتجاوز $max';
    }
    return null;
  }

  // التحقق من التاريخ
  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'التاريخ مطلوب';
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'صيغة التاريخ غير صحيحة';
    }
  }

  // التحقق من الوقت
  static String? validateTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الوقت مطلوب';
    }
    if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
      return 'صيغة الوقت غير صحيحة';
    }
    return null;
  }

  // التحقق من الرابط
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرابط مطلوب';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) {
      return 'صيغة الرابط غير صحيحة';
    }
    return null;
  }

  // التحقق من حقل اختياري
  static String? validateOptional(String? value, String fieldName, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) {
      return null; // حقل اختياري
    }
    if (value.length > maxLength) {
      return '$fieldName طويل جداً (الحد الأقصى $maxLength حرف)';
    }
    return null;
  }

  // التحقق من الاسم العربي فقط
  static String? validateArabicName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(value)) {
      return 'الاسم يجب أن يكون باللغة العربية فقط';
    }
    if (value.length < 2 || value.length > 30) {
      return 'الاسم يجب أن يكون بين 2 و 30 حرفاً';
    }
    return null;
  }

  // التحقق من الاسم الانجليزي فقط
  static String? validateEnglishName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'الاسم يجب أن يكون باللغة الإنجليزية فقط';
    }
    if (value.length < 2 || value.length > 30) {
      return 'الاسم يجب أن يكون بين 2 و 30 حرفاً';
    }
    return null;
  }

  // دمج عدة مدققات
  static String? combineValidators(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // دالة مساعدة للتحقق من صحة الإيميل
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // دالة مساعدة للتحقق من صحة الهاتف
  static bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }
}