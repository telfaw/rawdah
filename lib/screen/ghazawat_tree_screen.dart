import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/error_handler.dart';

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double step = 60.0;
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        Path path = Path();
        path.moveTo(i + step / 2, j);
        path.lineTo(i + step * 0.7, j + step * 0.3);
        path.lineTo(i + step, j + step / 2);
        path.lineTo(i + step * 0.7, j + step * 0.7);
        path.lineTo(i + step / 2, j + step);
        path.lineTo(i + step * 0.3, j + step * 0.7);
        path.lineTo(i, j + step / 2);
        path.lineTo(i + step * 0.3, j + step * 0.3);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GhazawatTreeScreen extends StatefulWidget {
  const GhazawatTreeScreen({super.key});

  @override
  State<GhazawatTreeScreen> createState() => _GhazawatTreeScreenState();
}

class _GhazawatTreeScreenState extends State<GhazawatTreeScreen> {
  bool _showHint = false;
  double _currentScale = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() {
    try {
      _triggerHint();
      // محاكاة تحميل الصورة
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      ErrorHandler.logError("Screen initialization error: $e", StackTrace.current);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _triggerHint() {
    if (!mounted) return;

    setState(() => _showHint = true);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showHint = false);
      }
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentScale = details.scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color scaffoldBg = isDark ? const Color(0xFF1A130F) : const Color(0xFFF7F3E9);
    Color patternColor = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: scaffoldBg,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: scaffoldBg,
          body: Stack(
            children: [
              // النقش الإسلامي في الخلفية
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(color: patternColor),
                ),
              ),

              // مؤشر التحميل
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD4AF37),
                    strokeWidth: 2,
                  ),
                ),

              // الصورة التفاعلية
              if (!_isLoading)
                GestureDetector(
                  onTap: _triggerHint,
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 6.0,
                      boundaryMargin: const EdgeInsets.all(20),
                      onInteractionUpdate: _onScaleUpdate,
                      child: Hero(
                        tag: 'ghazawat_image',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/c.jpg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                ErrorHandler.logError("Image load error: Ghazawat tree", stackTrace!);
                                return Container(
                                  width: 300,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2D1B10) : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 80,
                                        color: isDark ? Colors.white24 : Colors.black26,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'صورة شجرة الغزوات غير متوفرة',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: isDark ? Colors.white54 : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // زر المعلومات
              Positioned(
                top: 60,
                right: 20,
                child: SafeArea(
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _showInfoDialog,
                    backgroundColor: const Color(0xFFD4AF37).withOpacity(0.8),
                    child: const Icon(Icons.info_outline, color: Colors.white),
                  ),
                ),
              ),

              // الرسالة الإرشادية
              Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: _showHint ? 1.0 : 0.0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2D1B10) : const Color(0xFF5D4037),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                            )
                          ],
                          border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.pinch_rounded,
                              color: Color(0xFFD4AF37),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "استخدم إصبعين للتكبير (${(_currentScale * 100).toStringAsFixed(0)}%)",
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                color: Color(0xFFE6D5B8),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // شريط التكبير
              if (!_isLoading && _currentScale != 1.0)
                Positioned(
                  top: 120,
                  left: 20,
                  right: 20,
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.zoom_in, color: Color(0xFFD4AF37), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (_currentScale - 0.5) / 5.5,
                              backgroundColor: const Color(0xFFD4AF37).withOpacity(0.2),
                              color: const Color(0xFFD4AF37),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(_currentScale * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFD4AF37)),
              SizedBox(width: 10),
              Text(
                'عن شجرة الغزوات',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'شجرة الغزوات والسرايا تعرض تسلسل الأحداث العسكرية في عهد النبي ﷺ:',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 15),
                _InfoItem(
                  icon: Icons.touch_app,
                  text: 'استخدم إصبعين للتكبير والتصغير',
                ),
                _InfoItem(
                  icon: Icons.pan_tool,
                  text: 'اسحب للتنقل في أجزاء الصورة',
                ),
                _InfoItem(
                  icon: Icons.zoom_in,
                  text: 'انقر مرتين للتكبير السريع',
                ),
                SizedBox(height: 10),
                Text(
                  'الغزوات الكبرى: بدر، أحد، الخندق، مكة، حُنين...',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '',
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
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}