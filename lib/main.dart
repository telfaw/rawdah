import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/screen/splash_screen.dart';

void main() {
  // معالجة الأخطاء العامة
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    ErrorHandler.logError(
      details.exception.toString(),
      details.stack ?? StackTrace.current,
    );
  };

  // ضمان تشغيل التطبيق بشكل صحيح
  WidgetsFlutterBinding.ensureInitialized();

  // تثبيت الاتجاه الرأسي فقط
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const RawdahApp());
  })
      .catchError((error) {
    // في حال وجود خطأ، نشغل التطبيق على أي حال
    ErrorHandler.logError("Orientation error: $error", StackTrace.current);
    runApp(const RawdahApp());
  });
}

class RawdahApp extends StatefulWidget {
  const RawdahApp({super.key});

  @override
  State<RawdahApp> createState() => _RawdahAppState();
}

class _RawdahAppState extends State<RawdahApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final String appVersion = "1.0.5";

  // دالة تحويل الوضع اللوني
  void _toggleTheme() {
    if (mounted) {
      setState(() {
        _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      themeMode: _themeMode,

      // الثيم الفاتح (تباين عالي)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppConstants.lightBackground,
        fontFamily: AppConstants.secondaryFont,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5D4037),
          centerTitle: true,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE6D5B8),
          ),
          iconTheme: IconThemeData(color: Color(0xFFE6D5B8)),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),

        dividerTheme: const DividerThemeData(color: Colors.black12),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF3E2723), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFF3E2723), fontSize: 14),
        ),

        // لون أزرار التحكم
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      // الثيم الداكن (سواد عميق لتباين النص الذهبي)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConstants.darkBackground,
        fontFamily: AppConstants.secondaryFont,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37),
          ),
          iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE6D5B8), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFFE6D5B8), fontSize: 14),
        ),

        // لون أزرار التحكم في الوضع الداكن
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      home: SplashScreen(
        toggleTheme: _toggleTheme,
        currentAppVersion: appVersion,
      ),
    );
  }
}