import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rawdah/error_handler.dart';
import 'sahaba_gallery.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final String currentAppVersion;

  const SplashScreen({
    super.key,
    required this.toggleTheme,
    required this.currentAppVersion,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String serverRequiredVersion = "1.0.4";
  final List<String> _spiritualMessages = [
    "استغل وقتك بذكر الله",
    "صلِّ على النبي ﷺ تفرج همومك",
    "سبحان الله وبحمده، سبحان الله العظيم",
    "اجعل لسانك رطباً بذكر الله",
    "الروضة الشريفة.. قطعة من الجنة",
    "الذكر يطرد الهموم ويُفرّج الكروب",
    "من قال سبحان الله وبحمده مئة مرة غُفِرت خطاياه وإن كانت مثل زبد البحر",
  ];

  int _messageIndex = 0;
  Timer? _messageTimer;
  Timer? _navigationTimer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _initializeSplash() {
    try {
      _startMessageCycle();
      _checkVersionAndNavigate();
    } catch (e) {
      ErrorHandler.logError("Splash initialization error: $e", StackTrace.current);
      _navigateToHome();
    }
  }

  void _startMessageCycle() {
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _spiritualMessages.length;
        });
      }
    });
  }

  void _checkVersionAndNavigate() {
    _navigationTimer = Timer(const Duration(seconds: 8), () {
      if (mounted && !_isNavigating) {
        if (widget.currentAppVersion == serverRequiredVersion) {
          _navigateToHome();
        } else {
          _showUpdateDialog();
        }
      }
    });
  }

  void _navigateToHome() {
    if (mounted && !_isNavigating) {
      _isNavigating = true;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SahabaGallery(
            toggleTheme: widget.toggleTheme,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _showUpdateDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2D1B10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE6D5B8), width: 1),
          ),
          title: const Text(
            "تحديث جديد متوفر",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              color: Color(0xFFE6D5B8),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.system_update_rounded,
                color: Color(0xFFD4AF37),
                size: 60,
              ),
              const SizedBox(height: 15),
              Text(
                "إصدارك الحالي (${widget.currentAppVersion}) يحتاج لتحديث إلى ($serverRequiredVersion) لمتابعة الاستخدام.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // هنا يمكن إضافة رابط متجر التطبيقات
                  ErrorHandler.showSuccess(context, "جاري التوجه إلى المتجر...");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.update, color: Colors.white),
                label: const Text(
                  "تحديث الآن",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              "assets/images/s.jpg",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF5D4037), Color(0xFF2D1B10)],
                    ),
                  ),
                );
              },
            ),
          ),

          // التدرج اللوني
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // مؤشر التحميل
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFE6D5B8),
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                ),
                SizedBox(height: 15),
                Text(
                  "جاري التحميل...",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),

          // الرسائل الروحية
          Positioned(
            bottom: 120,
            left: 30,
            right: 30,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                _spiritualMessages[_messageIndex],
                key: ValueKey<int>(_messageIndex),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  color: Color(0xFFE6D5B8),
                  shadows: [Shadow(blurRadius: 15, color: Colors.black)],
                  height: 1.5,
                ),
              ),
            ),
          ),

          // رقم الإصدار
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // ميزة مخفية: الضغط على رقم الإصدار يظهر رسالة
                ErrorHandler.showSuccess(context, 'تطبيق الروضة الشريفة - نسخة مطورة');
              },
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  "الإصدار ${widget.currentAppVersion}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}