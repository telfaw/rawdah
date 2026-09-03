import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/painters.dart';

class AhadithScreen extends StatefulWidget {
  const AhadithScreen({super.key});

  @override
  State<AhadithScreen> createState() => _AhadithScreenState();
}

class _AhadithScreenState extends State<AhadithScreen> {
  // ═══════════════════════════════════════════════════════════════════════
  // Design System - روضه
  // ═══════════════════════════════════════════════════════════════════════

  static const Color _gold = Color(0xFFD4AF37);
  double _fontSize = 19.0;

  static const Color _darkBackground = Color(0xFF17100C);
  static const Color _darkSurface = Color(0xFF251810);

  static const Color _lightBackground = Color(0xFFF7F3E9);
  static const Color _lightSurface = Color(0xFFFFFCF5);

  static const Color _darkText = Color(0xFFE8D8BD);
  static const Color _lightText = Color(0xFF3E2723);

  // ═══════════════════════════════════════════════════════════════════════
  // Controllers
  // ═══════════════════════════════════════════════════════════════════════

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  final List<GlobalKey> _hadithKeys = [];

  // ═══════════════════════════════════════════════════════════════════════
  // البيانات الأصلية
  // ═══════════════════════════════════════════════════════════════════════

  final List<Map<String, String>> allAhadith = const [
    {
      'title': 'فضل البدء ببسم الله',
      'text':
          '«كُلُّ أَمْرٍ ذِي بَالٍ لا يُبْدَأُ فِيهِ بِبِسْمِ اللَّهِ فَهُوَ أَقْطَعُ»',
      'ref': 'رواه أحمد',
      'explanation':
          "يُرشدنا الحديث إلى أهمية استهلال الأعمال الهامة بذكر الله تعالى، فكلمة «أقطع» تعني ناقص البركة.",
    },
    {
      'title': 'كفالة اليتيم',
      'text':
          '«أَنَا وَكَافِلُ الْيَتِيمِ فِي الْجَنَّةِ كَهَاتَيْنِ» وَأَشَارَ بِالسَّبَّابَةِ وَالْوُسْطَى.',
      'ref': 'رواه البخاري',
      'explanation':
          'بيان للمنزلة الرفيعة والقرب من النبي ﷺ في الجنة لمن يقوم برعاية اليتيم.',
    },
    {
      'title': 'الأعمال بالنيات (الأربعين النووية)',
      'text':
          '«إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى»',
      'ref': 'متفق عليه',
      'explanation':
          'هذا الحديث أصل عظيم، معناه أن صلاح العمل أو فساده تابع للنية التي يحملها المؤمن في قلبه.',
    },
    {
      'title': 'من حسن إسلام المرء',
      'text': '«مِنْ حُسْنِ إِسْلامِ الْمَرْءِ تَرْكُهُ مَا لا يَعْنِيهِ»',
      'ref': 'رواه الترمذي',
      'explanation':
          'دعوة للاشتغال بما يفيد في الدين والدنيا والابتعاد عن الفضول والتدخل في شؤون الآخرين.',
    },
    {
      'title': 'النهي عن الغضب',
      'text': '«لا تَغْضَبْ» (كررها مراراً)',
      'ref': 'رواه البخاري',
      'explanation':
          'وصية نبوية جامعة، فالغضب مفتاح كل شر، وملك النفس عند الغضب من أعظم القوة.',
    },
    {
      'title': 'الروضة الشريفة',
      'text':
          '«مَا بَيْنَ بَيْتِي وَمِنْبَرِي رَوْضَةٌ مِنْ رِيَاضِ الجَنَّةِ»',
      'ref': 'متفق عليه',
      'explanation': 'إثبات لفضل هذا المكان المبارك في المسجد النبوي الشريف.',
    },
    {
      'title': 'الإحسان إلى الجار',
      'text':
          '«مَا زَالَ جِبْرِيلُ يُوصِينِي بِالْجَارِ حَتَّى ظَنَنْتُ أَنَّهُ سَيُورِّثُهُ»',
      'ref': 'رواه البخاري ومسلم',
      'explanation': 'النهي عن أذى الجار والحث على إكرامه والإحسان إليه.',
    },
    {
      'title': 'فضل الصدقة',
      'text': '«صَدَقَةُ السِّرِّ تُطْفِئُ غَضَبَ الرَّبِّ»',
      'ref': 'رواه الطبراني',
      'explanation': 'الصدقة سبب لمغفرة الذنوب ورضا الرب سبحانه وتعالى.',
    },
  ];

  List<Map<String, String>> filteredAhadith = [];

  // ═══════════════════════════════════════════════════════════════════════
  // Lifecycle
  // ═══════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    filteredAhadith = List<Map<String, String>>.from(allAhadith);

    _syncHadithKeys();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // مزامنة المفاتيح مع القائمة المفلترة
  // ═══════════════════════════════════════════════════════════════════════

  void _syncHadithKeys() {
    _hadithKeys
      ..clear()
      ..addAll(
        List<GlobalKey>.generate(filteredAhadith.length, (_) => GlobalKey()),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // البحث
  // ═══════════════════════════════════════════════════════════════════════

  void _runFilter(String enteredKeyword) {
    final String searchLower = enteredKeyword.trim().toLowerCase();

    final List<Map<String, String>> results;

    if (searchLower.isEmpty) {
      results = List<Map<String, String>>.from(allAhadith);
    } else {
      results = allAhadith.where((hadith) {
        final String title = hadith['title']?.toLowerCase() ?? '';

        final String text = hadith['text']?.toLowerCase() ?? '';

        final String ref = hadith['ref']?.toLowerCase() ?? '';

        return title.contains(searchLower) ||
            text.contains(searchLower) ||
            ref.contains(searchLower);
      }).toList();
    }

    if (!mounted) return;

    setState(() {
      filteredAhadith = results;
      _syncHadithKeys();
    });

    // بعد الفلترة نعيد موضع التمرير للبداية.
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Bottom Sheet
  // ═══════════════════════════════════════════════════════════════════════

  void _showHadithDetails(
    BuildContext context,
    Map<String, String> hadith,
    bool isDark,
  ) {
    try {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetContext) {
          return StatefulBuilder(
            builder: (context, setSheetState) {
              final double screenHeight = MediaQuery.sizeOf(
                sheetContext,
              ).height;
              final double maxHeight = screenHeight * 0.88;
              final Color surface = isDark ? _darkSurface : _lightSurface;
              final Color textColor = isDark ? _darkText : _lightText;

              return Directionality(
                textDirection: TextDirection.rtl,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      border: Border.all(color: _gold.withValues(alpha: 0.20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 30,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        // مقبض السحب
                        Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: _gold.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.text_increase,
                                  color: _gold,
                                ),
                                onPressed: () {
                                  setSheetState(() => _fontSize += 2);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.text_decrease,
                                  color: _gold,
                                ),
                                onPressed: () {
                                  if (_fontSize > 12) {
                                    setSheetState(() => _fontSize -= 2);
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              22,
                              0,
                              22,
                              MediaQuery.viewInsetsOf(sheetContext).bottom + 22,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                // العنوان
                                Text(
                                  hadith['title'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 23,
                                    height: 1.35,
                                    fontWeight: FontWeight.bold,
                                    color: _gold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: _gold.withValues(alpha: 0.18),
                                ),
                                const SizedBox(height: 20),
                                // نص الحديث
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _gold.withValues(
                                      alpha: isDark ? 0.06 : 0.045,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _gold.withValues(alpha: 0.18),
                                    ),
                                  ),
                                  child: Text(
                                    hadith['text'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: _fontSize,
                                      height: 1.9,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // المصدر
                                _buildSourceChip(hadith['ref'] ?? '', isDark),
                                const SizedBox(height: 18),
                                // الشرح
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'شرح الحديث',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _gold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hadith['explanation'] ?? '',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    height: 1.8,
                                    color: textColor.withValues(alpha: 0.82),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // زر الإغلاق
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(sheetContext).pop();
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 19,
                                    ),
                                    label: const Text(
                                      'إغلاق',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: _gold,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      ErrorHandler.logError(
        'Error showing hadith details: $e',
        StackTrace.current,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Build
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isDark = theme.brightness == Brightness.dark;

    final Size screenSize = MediaQuery.sizeOf(context);

    final double width = screenSize.width;
    final double height = screenSize.height;

    final bool isTablet = width >= 600;
    final bool isDesktop = width >= 1000;

    final Color scaffoldBg = isDark ? _darkBackground : _lightBackground;

    final Color textColor = isDark ? _darkText : _lightText;

    final Color patternColor = isDark
        ? Colors.white.withValues(alpha: 0.035)
        : Colors.black.withValues(alpha: 0.025);

    final double horizontalPadding = isDesktop
        ? 70
        : isTablet
        ? 45
        : 16;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: Stack(
          children: [
            // ═══════════════════════════════════════════════════════
            // الخلفية
            // ═══════════════════════════════════════════════════════
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: IslamicPatternPainter(color: patternColor),
                ),
              ),
            ),

            // ═══════════════════════════════════════════════════════
            // المحتوى
            // ═══════════════════════════════════════════════════════
            SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double availableWidth = constraints.maxWidth;

                  final double contentMaxWidth = isDesktop ? 1100 : 850;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          children: [
                            // AppBar
                            _buildAppHeader(isDark, textColor),

                            const SizedBox(height: 12),

                            // حديث اليوم (تم نقله هنا)
                            _buildDailyHadith(isDark),

                            const SizedBox(height: 12),

                            // البحث
                            _buildSearchField(isDark, textColor),

                            const SizedBox(height: 10),

                            // عدد النتائج
                            if (filteredAhadith.isNotEmpty)
                              _buildResultsHeader(isDark, textColor),

                            const SizedBox(height: 6),

                            // القائمة
                            Expanded(
                              child: filteredAhadith.isEmpty
                                  ? _buildEmptyState(isDark, textColor)
                                  : _buildHadithList(
                                      isDark,
                                      availableWidth,
                                      height,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ═══════════════════════════════════════════════════════
            // شريط التنقل الجانبي
            // ═══════════════════════════════════════════════════════
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // App Header
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAppHeader(bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        border: Border.all(color: _gold.withValues(alpha: 0.22), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: AppConstants.goldGradient,
              border: Border.all(color: _gold.withValues(alpha: 0.25)),
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
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الأحاديث النبوية',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'من هدي النبي ﷺ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    color: textColor.withValues(alpha: 0.52),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: _gold.withValues(alpha: 0.22)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 14, color: _gold),
                const SizedBox(width: 5),
                Text(
                  '${allAhadith.length}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyHadith(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? AppConstants.brownGradient : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: _gold.withValues(alpha: 0.28), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ShineEffect(
                child: Icon(Icons.auto_awesome, color: _gold, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                "حديث اليوم",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : _gold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "«مَا بَيْنَ بَيْتِي وَمِنْبَرِي رَوْضَةٌ مِنْ رِيَاضِ الْجَنَّةِ»",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 17,
              height: 1.6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Search Field
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildSearchField(bool isDark, Color textColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.045)
            : Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.10 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        textInputAction: TextInputAction.search,
        onChanged: _runFilter,
        style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: textColor),
        decoration: InputDecoration(
          hintText: 'ابحث عن حديث أو عنوان أو مصدر...',
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: textColor.withValues(alpha: 0.42),
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: _gold, size: 22),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  tooltip: 'مسح البحث',
                  onPressed: () {
                    _searchController.clear();
                    _runFilter('');
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.grey,
                    size: 19,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Results Header
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildResultsHeader(bool isDark, Color textColor) {
    final int count = filteredAhadith.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 15,
            color: _gold.withValues(alpha: 0.75),
          ),
          const SizedBox(width: 6),
          Text(
            count == allAhadith.length ? 'جميع الأحاديث' : 'نتائج البحث',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              color: textColor.withValues(alpha: 0.55),
            ),
          ),
          const Spacer(),
          Text(
            '$count حديث',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Hadith List
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildHadithList(bool isDark, double width, double height) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: width >= 900,
      radius: const Radius.circular(20),
      thickness: 5,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
        itemCount: filteredAhadith.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> hadith = filteredAhadith[index];

          return KeyedSubtree(
            key: _hadithKeys[index],
            child: _buildHadithCard(context, hadith, isDark, index),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Hadith Card
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildHadithCard(
    BuildContext context,
    Map<String, String> hadith,
    bool isDark,
    int index,
  ) {
    final Color textColor = isDark ? _darkText : _lightText;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ShineEffect(
        enabled: index == 0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showHadithDetails(context, hadith, isDark),
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: isDark ? AppConstants.brownGradient : null,
                color: isDark ? null : Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _gold.withValues(alpha: 0.17)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.10 : 0.035,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _gold.withValues(alpha: 0.20),
                                _gold.withValues(alpha: 0.06),
                              ],
                            ),
                            border: Border.all(
                              color: _gold.withValues(alpha: 0.20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _gold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            hadith['title'] ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                              color: _gold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 15,
                          color: _gold.withValues(alpha: 0.45),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _gold.withValues(alpha: isDark ? 0.035 : 0.025),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        hadith['text'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          height: 1.85,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: _gold.withValues(alpha: 0.10),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 15,
                          color: _gold.withValues(alpha: 0.70),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'المصدر: ${hadith['ref'] ?? ''}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              height: 1.5,
                              color: textColor.withValues(alpha: 0.55),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _gold.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                size: 13,
                                color: _gold,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'التفاصيل',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: _gold,
                                ),
                              ),
                            ],
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
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Empty State
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildEmptyState(bool isDark, Color textColor) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _gold.withValues(alpha: 0.06),
                border: Border.all(color: _gold.withValues(alpha: 0.16)),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 45,
                color: _gold.withValues(alpha: 0.65),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'لا توجد نتائج',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'عذراً، لم نجد حديثاً يطابق عبارة البحث.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                height: 1.7,
                color: textColor.withValues(alpha: 0.52),
              ),
            ),

            const SizedBox(height: 18),

            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                _runFilter('');
              },
              icon: const Icon(Icons.refresh_rounded, size: 17),
              label: const Text(
                'عرض جميع الأحاديث',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 11),
              ),
              style: TextButton.styleFrom(foregroundColor: _gold),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Source Chip
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildSourceChip(String source, bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _gold.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_outlined, size: 15, color: _gold),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              source,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
