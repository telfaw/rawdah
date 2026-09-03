import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/nusuk_helper.dart';

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
  final String serverRequiredVersion = AppConstants.appVersion;
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
  bool _showDisclaimer = false;

  @override
  void initState() {
    super.initState();
    _startMessageCycle();
    // إظهار التنبيه بعد 3 ثوانٍ بدلاً من الانتقال التلقائي
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showDisclaimer = true);
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheAssets();
  }

  void _precacheAssets() {
    precacheImage(const AssetImage("assets/images/s.jpg"), context);
    for (int i = 1; i <= 4; i++) {
      precacheImage(AssetImage("assets/images/$i.jpg"), context);
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

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SahabaGallery(toggleTheme: widget.toggleTheme),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _openNusuk() async {
    await NusukHelper.openNusukInStore();
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
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5D4037), Color(0xFF2D1B10)],
                  ),
                ),
              ),
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
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // الرسائل الروحية (تختفي عند ظهور التنبيه)
          if (!_showDisclaimer)
            Positioned(
              bottom: 150,
              left: 30,
              right: 30,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
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

          // مؤشر التحميل البسيط
          if (!_showDisclaimer)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD4AF37),
                strokeWidth: 2,
              ),
            ),

          // نافذة إخلاء المسؤولية
          if (_showDisclaimer)
            Center(
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: ShineEffect(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D1B10).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFFD4AF37),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFFD4AF37),
                          size: 50,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "تنبيه هام",
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE6D5B8),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "نحيطكم علماً بأن هذا التطبيق تعليمي وثقافي وليس له علاقة بحجوزات الروضة الشريفة. الحجوزات الرسمية تتم حصراً عبر تطبيق 'نسك'.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _navigateToHome,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4AF37),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  "عُلم (دخول)",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _openNusuk,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFD4AF37),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  "تطبيق نسك",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xFFD4AF37),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // رقم الإصدار
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
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
        ],
      ),
    );
  }
}
