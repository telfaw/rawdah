import 'package:flutter/material.dart';

class AppConstants {
  // معلومات التطبيق
  static const String appName = 'الروضة الشريفة';
  static const String appVersion = '1.0.3';
  static const String developerName = 'فواز الشميري';
  static const String developerPhone = '967777004173';

  // الألوان الأساسية
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color lightBackground = Color(0xFFFCF9F2);
  static const Color brownDark = Color(0xFF5D4037);
  static const Color brownLight = Color(0xFFF7F3E9);
  static const Color textDark = Color(0xFF3E2723);
  static const Color textLight = Color(0xFFE6D5B8);

  // الخطوط
  static const String arabicFont = 'Amiri';
  static const String secondaryFont = 'Cairo';

  // المسارات
  static const String imagesPath = 'assets/images/';
  static const String audioPath = 'assets/audio/';
  static const String fontsPath = 'fonts/';

  // الإعدادات الافتراضية
  static const int defaultTasbihCount = 33;
  static const int maxZoomScale = 6;
  static const double minZoomScale = 0.5;

  // الرسائل
  static const String successMessage = 'تمت العملية بنجاح';
  static const String errorMessage = 'حدث خطأ، حاول مرة أخرى';
  static const String networkError = 'تأكد من اتصالك بالإنترنت';
  static const String loadingMessage = 'جاري التحميل...';

  // أوقات الانتظار
  static const Duration splashDuration = Duration(seconds: 6);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration hintDuration = Duration(seconds: 4);

  // بيانات الصحابة
  static const List<Map<String, dynamic>> sahabaData = [
    {"name": "أبو بكر الصديق", "id": "1", "bio": "أول الخلفاء الراشدين، وأعظم الصحابة بعد النبي"},
    {"name": "عمر بن الخطاب", "id": "2", "bio": "ثاني الخلفاء الراشدين، الفاروق الذي فرق بين الحق والباطل"},
    {"name": "عثمان بن عفان", "id": "3", "bio": "ثالث الخلفاء الراشدين، ذو النورين"},
    {"name": "علي بن أبي طالب", "id": "4", "bio": "رابع الخلفاء الراشدين، باب علم النبي"},
    {"name": "طلحة بن عبيد الله", "id": "5", "bio": "أحد العشرة المبشرين بالجنة"},
    {"name": "سعيد بن زيد", "id": "6", "bio": "أحد العشرة المبشرين بالجنة"},
    {"name": "الزبير بن العوام", "id": "7", "bio": "أحد العشرة المبشرين بالجنة"},
    {"name": "أبو عبيدة الجراح", "id": "8", "bio": "أمين هذه الأمة من العشرة المبشرين"},
    {"name": "عبد الرحمن بن عوف", "id": "9", "bio": "أحد العشرة المبشرين بالجنة"},
    {"name": "سعد بن أبي وقاص", "id": "10", "bio": "أحد العشرة المبشرين بالجنة"},
  ];

  // الأذكار
  static const List<Map<String, dynamic>> azkarData = [
    {"title": "سُبْحَانَ اللَّهِ", "target": 33, "type": "tasbih"},
    {"title": "الْحَمْدُ لِلَّهِ", "target": 33, "type": "hamd"},
    {"title": "اللَّهُ أَكْبَرُ", "target": 33, "type": "takbir"},
    {"title": "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", "target": 100, "type": "hawl"},
    {"title": "أَسْتَغْفِرُ اللَّهَ", "target": 100, "type": "istighfar"},
    {"title": "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ", "target": 100, "type": "salat"},
  ];

  // الأحاديث
  static const List<Map<String, String>> ahadithData = [
    {
      "title": "فضل البدء ببسم الله",
      "text": "«كُلُّ أَمْرٍ ذِي بَالٍ لا يُبْدَأُ فِيهِ بِبِسْمِ اللَّهِ فَهُوَ أَقْطَعُ»",
      "ref": "رواه أحمد",
      "explanation": "يُرشدنا الحديث إلى أهمية استهلال الأعمال الهامة بذكر الله تعالى."
    },
    {
      "title": "كفالة اليتيم",
      "text": "«أَنَا وَكَافِلُ الْيَتِيمِ فِي الْجَنَّةِ كَهَاتَيْنِ»",
      "ref": "رواه البخاري",
      "explanation": "بيان للمنزلة الرفيعة والقرب من النبي ﷺ في الجنة لمن يقوم برعاية اليتيم."
    },
  ];

  // رسائل التطبيق
  static const List<String> spiritualMessages = [
    "استغل وقتك بذكر الله",
    "صلِّ على النبي ﷺ تفرج همومك",
    "سبحان الله وبحمده، سبحان الله العظيم",
    "اجعل لسانك رطباً بذكر الله",
    "الروضة الشريفة.. قطعة من الجنة",
    "الذكر يطرد الهموم ويُفرّج الكروب",
    "من قال سبحان الله وبحمده مئة مرة غُفِرت خطاياه",
    "اللهم صلِّ وسلم على نبينا محمد",
    "سبحان الله والحمد لله ولا إله إلا الله والله أكبر",
    "اللهم اجعلنا من أهل الروضة الشريفة",
  ];
}