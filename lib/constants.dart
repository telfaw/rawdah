import 'package:flutter/material.dart';

class AppConstants {
  // معلومات التطبيق
  static const String appName = 'الروضة';
  static const String appVersion = '1.0.6';
  static const String developerName = 'فواز الشميري';
  static const String developerPhone = '967777004173';

  // الألوان الأساسية
  static const Color primaryGold = Color(0xFFD9B15B);
  static const Color goldSoft = Color(0xFFF9E7B4);
  static const Color darkBackground = Color(0xFF120D0B);
  static const Color darkSurface = Color(0xFF1B140F);
  static const Color lightBackground = Color(0xFFFEF9F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color brownDark = Color(0xFF5A3D30);
  static const Color brownMedium = Color(0xFF7A5647);
  static const Color brownLight = Color(0xFFF9F3E9);
  static const Color textDark = Color(0xFF31241D);
  static const Color textLight = Color(0xFFEFE2C6);

  // التدرجات اللونية (Gradients)
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFD9B15B), Color(0xFFB9892D), Color(0xFFEFD68F)],
  );

  static const LinearGradient brownGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5D4037), Color(0xFF3B261C), Color(0xFF2C1D18)],
  );

  static LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFF120D0B),
      const Color(0xFF201610).withValues(alpha: 0.96),
      const Color(0xFF120D0B),
    ],
  );

  static LinearGradient lightBackgroundGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFDF9), Color(0xFFF9F0E0), Color(0xFFF5E7C3)],
  );

  static const LinearGradient shineGradient = LinearGradient(
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [
      Colors.transparent,
      Colors.white10,
      Colors.white24,
      Colors.white10,
      Colors.transparent,
    ],
    stops: [0.0, 0.35, 0.5, 0.65, 1.0],
  );

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
    {
      "name": "أبو بكر الصديق",
      "id": "1",
      "bio":
          "أول الخلفاء الراشدين، وأعظم الصحابة بعد النبي، لقب بالصديق لإيمانه بنبي الله في الغار",
    },
    {
      "name": "عمر بن الخطاب",
      "id": "2",
      "bio":
          "ثاني الخلفاء الراشدين، الفاروق الذي فرق بين الحق والباطل، أقوى الدول الإسلامية في عهده",
    },
    {
      "name": "عثمان بن عفان",
      "id": "3",
      "bio":
          "ثالث الخلفاء الراشدين، ذو النورين، جمع بين بنتي النبي، أنزل الله سكينته عليه",
    },
    {
      "name": "علي بن أبي طالب",
      "id": "4",
      "bio":
          "رابع الخلفاء الراشدين، ابن عم النبي وزوج ابنته فاطمة، باب علم النبي",
    },
    {
      "name": "طلحة بن عبيد الله",
      "id": "5",
      "bio":
          "أحد العشرة المبشرين بالجنة، اشترى ناقة النبي عند الهجرة، استشهد في معركة الجمل",
    },
    {
      "name": "سعيد بن زيد",
      "id": "6",
      "bio":
          "أحد العشرة المبشرين بالجنة، من أوائل الصحابة إسلاماً، زوج أخت عمر بن الخطاب",
    },
    {
      "name": "الزبير بن العوام",
      "id": "7",
      "bio": "أحد العشرة المبشرين بالجنة، ابن عمة النبي، استشهد في معركة الجمل",
    },
    {
      "name": "أبو عبيدة الجراح",
      "id": "8",
      "bio": "أمين هذه الأمة، أحد العشرة المبشرين، قاتل في سبيل الله حتى مات",
    },
    {
      "name": "عبد الرحمن بن عوف",
      "id": "9",
      "bio": "أحد العشرة المبشرين بالجنة، أغنى الصحابة، أكرمهم الله بالمال",
    },
    {
      "name": "سعد بن أبي وقاص",
      "id": "10",
      "bio":
          "أحد العشرة المبشرين بالجنة، أول من رمى سهماً في سبيل الله، فاتح بلاد الفرس",
    },
  ];

  // الأذكار
  static const List<Map<String, dynamic>> azkarData = [
    {"title": "سُبْحَانَ اللَّهِ", "target": 33, "type": "tasbih"},
    {"title": "الْحَمْدُ لِلَّهِ", "target": 33, "type": "hamd"},
    {"title": "اللَّهُ أَكْبَرُ", "target": 33, "type": "takbir"},
    {
      "title": "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
      "target": 100,
      "type": "hawl",
    },
    {"title": "أَسْتَغْفِرُ اللَّهَ", "target": 100, "type": "istighfar"},
    {
      "title": "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ",
      "target": 100,
      "type": "salat",
    },
  ];

  // الأحاديث
  static const List<Map<String, String>> ahadithData = [
    {
      "title": "فضل البدء ببسم الله",
      "text":
          "«كُلُّ أَمْرٍ ذِي بَالٍ لا يُبْدَأُ فِيهِ بِبِسْمِ اللَّهِ فَهُوَ أَقْطَعُ»",
      "ref": "رواه أحمد",
      "explanation":
          "يُرشدنا الحديث إلى أهمية استهلال الأعمال الهامة بذكر الله تعالى.",
    },
    {
      "title": "كفالة اليتيم",
      "text": "«أَنَا وَكَافِلُ الْيَتِيمِ فِي الْجَنَّةِ كَهَاتَيْنِ»",
      "ref": "رواه البخاري",
      "explanation":
          "بيان للمنزلة الرفيعة والقرب من النبي ﷺ في الجنة لمن يقوم برعاية اليتيم.",
    },
  ];

  // الغزوات الكبرى
  static const List<Map<String, String>> ghazawatData = [
    {
      'name': 'غزوة بدر الكبرى',
      'date': '17 رمضان 2هـ',
      'leader': 'النبي ﷺ',
      'purpose':
          'إظهار الدين، ودفع هجوم قريش على المسلمين، وتحقيق النصر الذي فتح باب الفتح في المدينة.',
      'benefit':
          'ثبت إيمان المسلمين، ورفع morale الجهاد، وأعطى الإسلام شارة النصر في أول مواجهة كبرى.',
    },
    {
      'name': 'غزوة أحد',
      'date': '7 شوال 3هـ',
      'leader': 'النبي ﷺ',
      'purpose':
          'رد هجوم المشركين على المدينة وصد غارة استهدفت المسلمين بعد بدر.',
      'benefit':
          'علّم المسلمون قيمة الصبر والالتزام، وفتح باب التوبة والتعلم من الخطأ في القتال.',
    },
    {
      'name': 'غزوة الخندق',
      'date': '5 شوال 5هـ',
      'leader': 'النبي ﷺ',
      'purpose':
          'تحصين المدينة من تحالف الأحزاب، وصد الخطر المشترك عن المسلمين.',
      'benefit':
          'أثبتت قوة التنظيم العسكري، وحققت الأمن للمدينة، ووضعت أسس التعاون بين المقاتلين.',
    },
    {
      'name': 'غزوة فتح مكة',
      'date': '20 رمضان 8هـ',
      'leader': 'النبي ﷺ',
      'purpose':
          'إزالة ظلم قريش، وعودة المسلمين إلى مكة في حالة كبرى من العفو والرحمة.',
      'benefit':
          'أظهر سمت الرحمة في الإسلام، وساهم في توحيد الجزيرة واستقرار الدعوة.',
    },
    {
      'name': 'غزوة حنين',
      'date': '6 شوال 8هـ',
      'leader': 'النبي ﷺ',
      'purpose':
          'دفع هجوم هوازن بعد فتح مكة، والحفاظ على وحدة الدولة الإسلامية.',
      'benefit':
          'أثبتت قوة الإيمان في وقت الفتح، وعلّمت المسلمين أن التوكل على الله أهم من القوة العددية.',
    },
  ];

  // السرايا والبعوث
  static const List<Map<String, String>> sarayaData = [
    {
      'name': 'سرية عبد الله بن جحش',
      'date': 'رجب 2هـ',
      'leader': 'عبد الله بن جحش',
      'purpose':
          'استطلاع معلومات عن قريش وتوثيق الحركة المشركة في الطريق إلى مكة.',
      'benefit':
          'كانت أول سرية في الإسلام، وساهمت في تطوير مهارة الاستخبارات والمراقبة.',
    },
    {
      'name': 'سرية زيد بن حارثة',
      'date': 'شوال 2هـ',
      'leader': 'زيد بن حارثة',
      'purpose': 'مهاجمة قافلة قريش والتخفيف من الضغط الاقتصادي على المسلمين.',
      'benefit':
          'قوت قلوب المسلمين، وأثبتت أن الجهاد لا يقتصر على غزوة كبيرة فقط.',
    },
    {
      'name': 'سرية أبي عبيدة بن الجراح',
      'date': '3هـ',
      'leader': 'أبو عبيدة بن الجراح',
      'purpose':
          'توطيد الأمن في الطريق إلى الشام وتجهيز المسلمين للخطط العسكرية المستقبلية.',
      'benefit':
          'حافظت على سلامة المسار، وساعدت في توسيع الروابط العسكرية والإنسانية.',
    },
    {
      'name': 'سرية خزاعة',
      'date': '4هـ',
      'leader': 'قائد غير محدد من الصحابة',
      'purpose':
          'حماية الطريق بين المدينة ومناطق التهديد ومراقبة تحركات الأعداء.',
      'benefit': 'دعم الأمن في الحجاز ومنع التوغل المعادي في مناطق المسلمين.',
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
