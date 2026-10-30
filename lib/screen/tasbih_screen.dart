import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/painters.dart';
import 'package:rawdah/utils/settings_helper.dart';
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
    {'title': 'أَسْتَغْفِرُ اللَّهَ العَظِيمَ وَأَتُوبُ إِلَيْهِ', 'target': 100},
    {'title': 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ', 'target': 100},
    {
      'title':
          '﴿رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ...﴾',
      'target': 3,
    },
    {
      'title':
          '﴿رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا﴾',
      'target': 3,
    },
    {
      'title':
          '﴿رَبِّ هَبْ لِي حُكْمًا وَأَلْحِقْنِي بِالصَّالِحِينَ ۝ وَاجْعَلْ لِي لِسَانَ صِدْقٍ فِي الْآخِرِينَ...﴾',
      'target': 3,
    },
    {
      'title':
          'دعاء النوم (اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ...)',
      'target': 1,
    },
  ];

  late final Map<String, int> _remainingCounts = {};
  int _activeIndex = 0;
  int _completedToday = 0;
  double _numberScale = 1.0;
  double _azkarFontSize = 20.0;
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
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.96,
      upperBound: 1.0,
    )..repeat(reverse: true);
    _loadProgress();
    _loadFontSettings();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadFontSettings() async {
    final sizes = await AppSettings.loadFontSizes();
    if (mounted) {
      setState(() {
        _azkarFontSize = sizes['body'] ?? 20.0;
      });
    }
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
                const Duration(milliseconds: 140))) {
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
            ErrorHandler.showSuccess(context, 'تم إكمال الذكر المبارك');
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
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
          'تقبل الله طاعتك وأذكارك',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'لقد أتممت جميع أذكار وأدعية اليوم بفضل الله تعالى!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: _gold),
              child: const Text('الحمد لله والمنّة', style: TextStyle(fontFamily: 'Cairo')),
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
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildHeader(isDark, textColor),
                        const SizedBox(height: 10),
                        _buildZikrCarousel(isDark),
                        const SizedBox(height: 12),
                        ShineEffect(
                          child: _buildMainCounter(
                            rem,
                            progress,
                            isDark,
                            textColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildControlButtons(isDark),
                        const SizedBox(height: 10),
                        Text(
                          'اضغط على العداد لتسجيل التسبيح أو الدعاء',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: textColor.withValues(alpha: 0.60),
                          ),
                        ),
                        const SizedBox(height: 70),
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

  Widget _buildHeader(bool isDark, Color textColor) {
    double totalProgress = (_completedToday / _azkarData.length).clamp(
      0.0,
      1.0,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF1D1713), Color(0xFF2E201B)],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFFCF4E7), Color(0xFFF0E0B2)],
              ),
        border: Border.all(
          color: _gold.withValues(alpha: 0.25),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: AppConstants.goldGradient,
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _gold.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const ShineEffect(
                  child: Icon(
                    Icons.self_improvement_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المسبحة الإلكترونية وإنجاز اليوم',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 21,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFE8D8BD) : const Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      'متابعة أذكارك اليومية وتسبيحاتك المباركة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.5,
                        color: (isDark ? const Color(0xFFE8D8BD) : const Color(0xFF3E2723)).withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_completedToday / ${_azkarData.length}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: _gold,
                    fontWeight: FontWeight.bold,
                  ),
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
              color: _success,
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZikrCarousel(bool isDark) {
    return SizedBox(
      height: 85,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _azkarData.length,
        onPageChanged: (i) => setState(() => _activeIndex = i),
        itemBuilder: (context, i) {
          bool active = _activeIndex == i;
          bool done = (_remainingCounts[_azkarData[i]['title']] ?? 1) == 0;
          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active
                    ? _gold.withValues(alpha: isDark ? 0.12 : 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active
                      ? _gold.withValues(alpha: 0.40)
                      : Colors.transparent,
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  _azkarData[i]['title'],
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: active ? _azkarFontSize : 14,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: done
                        ? _success
                        : (active
                            ? _gold
                            : (isDark ? Colors.white38 : Colors.black38)),
                  ),
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
              width: 145,
              height: 145,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 7,
                color: rem == 0 ? _success : _gold,
                backgroundColor: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            Container(
              width: 112,
              height: 112,
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
                    color: _gold.withValues(alpha: 0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: _gold.withValues(alpha: 0.30),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$rem',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: rem == 0 ? _success : textColor,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      rem == 0 ? 'مكتمل' : 'المتبقي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 9,
                        color: rem == 0 ? _success : textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
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
            curve: Curves.easeOut,
          ),
          tooltip: 'الذكر السابق',
        ),
        const SizedBox(width: 25),
        _btn(
          Icons.refresh,
          () async {
            final prefs = await SharedPreferences.getInstance();
            String title = _azkarData[_activeIndex]['title'];
            setState(() {
              if (_remainingCounts[title] == 0) _completedToday--;
              _remainingCounts[title] = _azkarData[_activeIndex]['target'];
              prefs.setInt('${title}_rem', _azkarData[_activeIndex]['target']);
            });
          },
          isLarge: true,
          tooltip: 'إعادة العداد',
        ),
        const SizedBox(width: 25),
        _btn(
          Icons.arrow_back_ios_new,
          () => _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
          tooltip: 'الذكر التالي',
        ),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, {bool isLarge = false, String? tooltip}) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.all(isLarge ? 14 : 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppConstants.goldGradient,
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.22),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: isLarge ? 24 : 18),
        ),
      ),
    );
  }
}
