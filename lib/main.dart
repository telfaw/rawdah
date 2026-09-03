import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
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
  late final ThemeData _lightTheme;
  late final ThemeData _darkTheme;

  @override
  void initState() {
    super.initState();
    _lightTheme = _buildTheme(Brightness.light);
    _darkTheme = _buildTheme(Brightness.dark);
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      themeMode: _themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: SplashScreen(
        toggleTheme: _toggleTheme,
        currentAppVersion: AppConstants.appVersion,
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppConstants.primaryGold,
      brightness: brightness,
      primary: AppConstants.primaryGold,
      secondary: AppConstants.brownDark,
      surface: isDark ? const Color(0xFF17120F) : const Color(0xFFFCF8F1),
      onSurface: isDark ? AppConstants.textLight : AppConstants.textDark,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? AppConstants.darkBackground
          : AppConstants.lightBackground,
      fontFamily: AppConstants.secondaryFont,
      cardColor: isDark ? AppConstants.darkSurface : AppConstants.lightSurface,
      dividerColor: AppConstants.primaryGold.withValues(alpha: 0.25),
      splashColor: AppConstants.primaryGold.withValues(alpha: 0.12),
      highlightColor: AppConstants.primaryGold.withValues(alpha: 0.08),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppConstants.primaryGold,
        selectionColor: AppConstants.primaryGold.withValues(alpha: 0.25),
        selectionHandleColor: AppConstants.primaryGold,
      ),
      iconTheme: IconThemeData(
        color: isDark ? AppConstants.primaryGold : AppConstants.brownDark,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppConstants.darkSurface : AppConstants.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        shadowColor: AppConstants.primaryGold.withValues(alpha: 0.16),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF1A1512) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 10,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? const Color(0xFF1A140F)
            : const Color(0xFF6A4A3D),
        surfaceTintColor: AppConstants.primaryGold,
        centerTitle: true,
        elevation: isDark ? 0 : 1.5,
        shadowColor: AppConstants.primaryGold.withValues(alpha: 0.18),
        titleTextStyle: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? AppConstants.primaryGold : const Color(0xFFF8F0E0),
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppConstants.primaryGold : const Color(0xFFF8F0E0),
        ),
        actionsIconTheme: IconThemeData(
          color: isDark ? AppConstants.primaryGold : const Color(0xFFF8F0E0),
        ),
        shape: Border(
          bottom: BorderSide(
            color: AppConstants.primaryGold.withValues(alpha: 0.22),
            width: 1.2,
          ),
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark
            ? const Color(0xFF120E0D)
            : const Color(0xFFFCF9F2),
        scrimColor: Colors.black.withValues(alpha: 0.4),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          AppConstants.primaryGold.withValues(alpha: isDark ? 0.65 : 0.5),
        ),
        trackColor: WidgetStateProperty.all(
          AppConstants.primaryGold.withValues(alpha: 0.08),
        ),
        radius: const Radius.circular(10),
        thickness: WidgetStateProperty.all(6),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textColor: isDark ? AppConstants.textLight : AppConstants.textDark,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppConstants.primaryGold.withValues(alpha: 0.12)
            : AppConstants.primaryGold.withValues(alpha: 0.08),
        selectedColor: AppConstants.primaryGold,
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: AppConstants.primaryGold,
        ),
        side: BorderSide(
          color: AppConstants.primaryGold.withValues(alpha: 0.25),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDark ? const Color(0xFFF3E7D1) : const Color(0xFF2C201B),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.7,
        ),
        bodyMedium: TextStyle(
          color: isDark ? const Color(0xFFECD8B3) : const Color(0xFF33251F),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.8,
        ),
        titleMedium: TextStyle(
          color: isDark ? const Color(0xFFF7F0E5) : const Color(0xFF2E201B),
          fontFamily: 'Amiri',
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: isDark ? const Color(0xFFF7F0E5) : const Color(0xFF2E201B),
          fontFamily: 'Amiri',
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryGold,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          elevation: 1,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryGold,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1C1714) : const Color(0xFFF8F3EB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppConstants.primaryGold.withValues(alpha: 0.35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppConstants.primaryGold, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppConstants.primaryGold.withValues(alpha: 0.25),
          ),
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : Colors.black45,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
