import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/painters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _azkarData = [
    {'title': 'سُبْحَانَ اللَّهِ', 'target': 33},
    {'title': 'الْحَمْدُ لِلَّهِ', 'target': 33},
    {'title': 'اللَّهُ أَكْبَرُ', 'target': 33},
    {'title': 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ', 'target': 100},
    {'title': 'أَسْتَغْفِرُ اللَّهَ', 'target': 100},
    {'title': 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ', 'target': 100},
  ];

  late final Map<String, int> _remainingCounts = {};
  int _activeIndex = 0;
  int _completedToday = 0;
  double _numberScale = 1.0;
  late final PageController _pageController;
  late final AnimationController _pulseController;
  bool _isProcessing = false;
  DateTime? _lastTapTime;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _darkBackground = Color(0xFF17100C);
  static const Color _lightBackground = Color(0xFFF7F3E9);
  static const Color _success = Color(0xFF3E9B61);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: 0);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.96,
      upperBound: 1.0,
    )..repeat(reverse: true);
    _loadProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String today = DateTime.now().toIso8601String().split('T')[0];
      final String? lastSavedDate = prefs.getString('last_date');

      if (lastSavedDate != today) {
        for (final item in _azkarData) {
          await prefs.remove('${item['title']}_rem');
        }
        await prefs.setString('last_date', today);
      }

      int completed = 0;
      for (final item in _azkarData) {
        final int target = item['target'];
        final int remaining = prefs.getInt('${item['title']}_rem') ?? target;
        _remainingCounts[item['title']] = remaining;
        if (remaining == 0) completed++;
      }

      if (mounted) setState(() => _completedToday = completed);
    } catch (e) {
      ErrorHandler.logError('Progress load error: $e', StackTrace.current);
    }
  }

  Future<void> _handleTap() async {
    final now = DateTime.now();
    if (_isProcessing ||
        (_lastTapTime != null &&
            now.difference(_lastTapTime!) <
                const Duration(milliseconds: 150))) {
      return;
    }

    _isProcessing = true;
    _lastTapTime = now;

    try {
      final String zikr = _azkarData[_activeIndex]['title'];
      final int currentRem =
          _remainingCounts[zikr] ?? _azkarData[_activeIndex]['target'];

      if (currentRem > 0) {
        final int nextCount = currentRem - 1;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('${zikr}_rem', nextCount);

        setState(() {
          _remainingCounts[zikr] = nextCount;
          _numberScale = 1.15;
        });

        HapticFeedback.selectionClick();

        if (nextCount == 0) {
          setState(() => _completedToday++);
          HapticFeedback.vibrate();
          if (mounted) {
            ErrorHandler.showSuccess(context, 'تم إكمال $zikr');
          }
          _moveToNextIncomplete();
        }

        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          setState(() => _numberScale = 1.0);
        }
      } else {
        _moveToNextIncomplete();
      }
    } finally {
      _isProcessing = false;
    }
  }

  void _moveToNextIncomplete() {
    int nextIdx = -1;
    for (int i = 1; i <= _azkarData.length; i++) {
      int checkIdx = (_activeIndex + i) % _azkarData.length;
      if ((_remainingCounts[_azkarData[checkIdx]['title']] ?? 1) > 0) {
        nextIdx = checkIdx;
        break;
      }
    }
    if (nextIdx != -1) {
      _pageController.animateToPage(
        nextIdx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'تقبل الله منك',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'لقد أتممت جميع أذكار اليوم!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('الحمد لله'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark
        ? const Color(0xFFE8D8BD)
        : const Color(0xFF3E2723);
    final Color patternColor = isDark
        ? Colors.white.withValues(alpha: 0.03)
        : Colors.black.withValues(alpha: 0.02);

    final String title = _azkarData[_activeIndex]['title'];
    final int rem =
        _remainingCounts[title] ?? _azkarData[_activeIndex]['target'];
    final double progress = (1.0 - (rem / _azkarData[_activeIndex]['target']))
        .clamp(0.0, 1.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? _darkBackground : _lightBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppConstants.darkBackgroundGradient
                : AppConstants.lightBackgroundGradient,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(color: patternColor),
                ),
              ),
              SafeArea(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(
                        _gold.withValues(alpha: 0.5),
                      ),
                      thickness: WidgetStateProperty.all(5),
                      radius: const Radius.circular(10),
                    ),
                  ),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      // إضافة حماية من التدفق
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            _buildHeader(isDark, textColor),
                            const SizedBox(height: 15),
                            _buildZikrCarousel(isDark),
                            const SizedBox(height: 20),
                            ShineEffect(
                              child: _buildMainCounter(
                                rem,
                                progress,
                                isDark,
                                textColor,
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildControlButtons(isDark),
                            const SizedBox(height: 20),
                            Text(
                              'اضغط على العداد للتسبيح',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                color: textColor.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ), // مساحة للـ Floating Indicator
                          ],
                        ),
                      ),
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

  Widget _buildHeader(bool isDark, Color textColor) {
    double totalProgress = (_completedToday / _azkarData.length).clamp(
      0.0,
      1.0,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'إنجاز اليوم',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
            ),
            Text(
              '$_completedToday / ${_azkarData.length}',
              style: const TextStyle(color: _gold, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: totalProgress,
          backgroundColor: isDark ? Colors.white10 : Colors.black12,
          color: _success,
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildZikrCarousel(bool isDark) {
    return SizedBox(
      height: 70,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _azkarData.length,
        onPageChanged: (i) => setState(() => _activeIndex = i),
        itemBuilder: (context, i) {
          bool active = _activeIndex == i;
          bool done = (_remainingCounts[_azkarData[i]['title']] ?? 1) == 0;
          return Center(
            child: AnimatedScale(
              scale: active ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              child: Text(
                _azkarData[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: active ? 22 : 16,
                  fontWeight: FontWeight.bold,
                  color: done
                      ? _success
                      : (active ? _gold : Colors.grey.withValues(alpha: 0.5)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainCounter(
    int rem,
    double progress,
    bool isDark,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _numberScale,
        duration: const Duration(milliseconds: 100),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 185,
              height: 185,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                color: rem == 0 ? _success : _gold,
                backgroundColor: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDark
                    ? const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xFF2D1B10), Color(0xFF1B130F)],
                      )
                    : const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xFFFFFDF8), Color(0xFFF7E8C7)],
                      ),
                boxShadow: [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: _gold.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '$rem',
                  style: TextStyle(
                    fontSize: 40,
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
        _btn(
          Icons.arrow_forward_ios,
          () => _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
        ),
        const SizedBox(width: 30),
        _btn(Icons.refresh, () async {
          final prefs = await SharedPreferences.getInstance();
          String title = _azkarData[_activeIndex]['title'];
          setState(() {
            if (_remainingCounts[title] == 0) _completedToday--;
            _remainingCounts[title] = _azkarData[_activeIndex]['target'];
            prefs.setInt('${title}_rem', _azkarData[_activeIndex]['target']);
          });
        }, isLarge: true),
        const SizedBox(width: 30),
        _btn(
          Icons.arrow_back_ios_new,
          () => _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
        ),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, {bool isLarge = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(isLarge ? 12 : 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppConstants.goldGradient,
          boxShadow: [
            BoxShadow(
              color: _gold.withValues(alpha: 0.20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: isLarge ? 24 : 18),
      ),
    );
  }
}
