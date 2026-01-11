import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  final List<Map<String, dynamic>> _azkarData = [
    {"title": "سُبْحَانَ اللَّهِ", "target": 33},
    {"title": "الْحَمْدُ لِلَّهِ", "target": 33},
    {"title": "اللَّهُ أَكْبَرُ", "target": 33},
    {"title": "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", "target": 100},
    {"title": "أَسْتَغْفِرُ اللَّهَ", "target": 100},
    {"title": "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ", "target": 100},
  ];

  Map<String, int> _remainingCounts = {};
  int _activeIndex = 0;
  int _completedToday = 0;
  double _numberScale = 1.0;
  late PageController _pageController;
  bool _isProcessing = false; // حماية من الضغط المتكرر
  DateTime? _lastTapTime; // لتتبع وقت آخر ضغطة

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: 0);
    _loadProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String today = DateTime.now().toIso8601String().split('T')[0];
      final String? lastSavedDate = prefs.getString("last_date");

      if (lastSavedDate != today) {
        for (var item in _azkarData) {
          await prefs.remove("${item['title']}_rem");
        }
        await prefs.setString("last_date", today);
      }

      int completed = 0;
      for (var item in _azkarData) {
        int rem = prefs.getInt("${item['title']}_rem") ?? item['target'];
        _remainingCounts[item['title']] = rem;
        if (rem == 0) completed++;
      }

      if (mounted) {
        setState(() => _completedToday = completed);
      }
    } catch (e) {
      ErrorHandler.logError("Error loading progress: $e", StackTrace.current);
    }
  }

  Future<void> _handleTap() async {
    // حماية من الضغط المتكرر السريع
    final now = DateTime.now();
    if (_isProcessing ||
        (_lastTapTime != null && now.difference(_lastTapTime!) < const Duration(milliseconds: 200))) {
      return;
    }

    _isProcessing = true;
    _lastTapTime = now;

    try {
      String currentZikr = _azkarData[_activeIndex]['title'];
      int currentRem = _remainingCounts[currentZikr] ?? _azkarData[_activeIndex]['target'];

      if (currentRem > 0) {
        int nextCount = currentRem - 1;
        final prefs = await SharedPreferences.getInstance();

        setState(() {
          _remainingCounts[currentZikr] = nextCount;
          _numberScale = 1.2;
          prefs.setInt("${currentZikr}_rem", nextCount);
        });

        // تأثير اهتزاز خفيف
        HapticFeedback.selectionClick();

        if (nextCount == 0) {
          setState(() => _completedToday++);
          HapticFeedback.vibrate();
          ErrorHandler.showSuccess(context, 'تم إكمال ${currentZikr}');
          _moveToNextIncomplete();
        }

        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          setState(() => _numberScale = 1.0);
        }
      } else {
        _moveToNextIncomplete();
      }
    } catch (e) {
      ErrorHandler.logError("Error in handleTap: $e", StackTrace.current);
    } finally {
      _isProcessing = false;
    }
  }

  void _moveToNextIncomplete() {
    int nextIncompleteIndex = -1;

    for (int i = 1; i <= _azkarData.length; i++) {
      int checkIndex = (_activeIndex + i) % _azkarData.length;
      String title = _azkarData[checkIndex]['title'];
      int rem = _remainingCounts[title] ?? _azkarData[checkIndex]['target'];

      if (rem > 0) {
        nextIncompleteIndex = checkIndex;
        break;
      }
    }

    if (nextIncompleteIndex != -1) {
      _pageController.animateToPage(
        nextIncompleteIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "تقبل الله منك",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "لقد أتممت جميع أذكار اليوم بنجاح!",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "الحمد لله",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color scaffoldBg = isDark ? const Color(0xFF1A130F) : const Color(0xFFF7F3E9);
    Color textColor = isDark ? const Color(0xFFE6D5B8) : const Color(0xFF3E2723);
    Color patternColor = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03);

    String currentTitle = _azkarData[_activeIndex]['title'];
    int currentRem = _remainingCounts[currentTitle] ?? _azkarData[_activeIndex]['target'];
    double progress = (_azkarData[_activeIndex]['target'] - currentRem) / _azkarData[_activeIndex]['target'];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(painter: IslamicPatternPainter(color: patternColor)),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildMilestoneHeader(isDark, textColor),
                  _buildZikrCarousel(isDark),
                  const Spacer(),
                  _buildMainCounter(currentRem, progress, isDark, textColor),
                  const Spacer(),
                  _buildControlButtons(isDark),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneHeader(bool isDark, Color textColor) {
    double totalProgress = (_completedToday / _azkarData.length).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "إنجاز اليوم",
                style: TextStyle(
                  fontSize: 13,
                  color: textColor.withOpacity(0.7),
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                "$_completedToday / ${_azkarData.length}",
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: totalProgress,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              color: Colors.green,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZikrCarousel(bool isDark) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _azkarData.length,
        onPageChanged: (index) {
          if (mounted) {
            setState(() => _activeIndex = index);
          }
        },
        itemBuilder: (context, index) {
          bool active = _activeIndex == index;
          bool done = (_remainingCounts[_azkarData[index]['title']] ?? 1) == 0;
          return Center(
            child: AnimatedScale(
              scale: active ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              child: Text(
                _azkarData[index]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: active ? 22 : 16,
                  fontWeight: FontWeight.bold,
                  color: done
                      ? Colors.green
                      : (active ? const Color(0xFFD4AF37) : Colors.grey.withOpacity(0.5)),
                  fontFamily: 'Amiri',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainCounter(int current, double progress, bool isDark, Color textColor) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _numberScale,
        duration: const Duration(milliseconds: 100),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                color: current == 0 ? Colors.green : const Color(0xFFD4AF37),
                backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
              ),
            ),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF2D1B10) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                  )
                ],
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  "$current",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleBtn(Icons.arrow_forward_ios, () {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }, isDark),
        const SizedBox(width: 35),
        _circleBtn(Icons.refresh, () async {
          try {
            final prefs = await SharedPreferences.getInstance();
            String current = _azkarData[_activeIndex]['title'];
            setState(() {
              if (_remainingCounts[current] == 0) _completedToday--;
              _remainingCounts[current] = _azkarData[_activeIndex]['target'];
              prefs.setInt("${current}_rem", _azkarData[_activeIndex]['target']);
            });
            ErrorHandler.showSuccess(context, 'تم إعادة تعيين العداد');
          } catch (e) {
            ErrorHandler.logError("Reset error: $e", StackTrace.current);
          }
        }, isDark, isLarge: true),
        const SizedBox(width: 35),
        _circleBtn(Icons.arrow_back_ios_new, () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }, isDark),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap, bool isDark, {bool isLarge = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(isLarge ? 14 : 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.03),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFD4AF37),
          size: isLarge ? 26 : 18,
        ),
      ),
    );
  }
}