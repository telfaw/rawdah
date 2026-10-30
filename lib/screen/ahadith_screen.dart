import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/painters.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AhadithScreen extends StatefulWidget {
  const AhadithScreen({super.key});

  @override
  State<AhadithScreen> createState() => _AhadithScreenState();
}

class _AhadithScreenState extends State<AhadithScreen> {
  // ═══════════════════════════════════════════════════════════════════════
  // Design System & Constants
  // ═══════════════════════════════════════════════════════════════════════

  static const Color _gold = Color(0xFFD4AF37);
  double _fontSize = 18.0;

  static const Color _darkBackground = Color(0xFF17100C);
  static const Color _darkSurface = Color(0xFF251810);

  static const Color _lightBackground = Color(0xFFF7F3E9);
  static const Color _lightSurface = Color(0xFFFFFCF5);

  static const Color _darkText = Color(0xFFE8D8BD);
  static const Color _lightText = Color(0xFF3E2723);

  // ═══════════════════════════════════════════════════════════════════════
  // Controllers & State
  // ═══════════════════════════════════════════════════════════════════════

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<GlobalKey> _hadithKeys = [];

  late List<Map<String, String>> allAhadith;
  List<Map<String, String>> filteredAhadith = [];
  Set<String> _favoriteTitles = {};
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'أذكار النوم',
    'الروضة والمسجد',
    'الأعمال والنيات',
    'الأخلاق والمعاملات',
    'الأذكار والفضائل',
    'المفضلة',
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // Lifecycle & Storage
  // ═══════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    allAhadith = AppConstants.ahadithData;
    filteredAhadith = List<Map<String, String>>.from(allAhadith);
    _syncHadithKeys();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favs = prefs.getStringList('favorite_ahadith');
      if (favs != null && mounted) {
        setState(() {
          _favoriteTitles = favs.toSet();
        });
      }
    } catch (e) {
      ErrorHandler.logError('Failed to load favorites: $e', StackTrace.current);
    }
  }

  Future<void> _toggleFavorite(String title) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        if (_favoriteTitles.contains(title)) {
          _favoriteTitles.remove(title);
        } else {
          _favoriteTitles.add(title);
        }
      });
      await prefs.setStringList('favorite_ahadith', _favoriteTitles.toList());

      if (_selectedCategory == 'المفضلة') {
        _runFilter(_searchController.text);
      }
    } catch (e) {
      ErrorHandler.logError('Failed to save favorite: $e', StackTrace.current);
    }
  }

  void _syncHadithKeys() {
    _hadithKeys
      ..clear()
      ..addAll(
        List<GlobalKey>.generate(filteredAhadith.length, (_) => GlobalKey()),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // البحث والفلترة
  // ═══════════════════════════════════════════════════════════════════════

  void _runFilter(String enteredKeyword) {
    final String searchLower = enteredKeyword.trim().toLowerCase();

    final List<Map<String, String>> results = allAhadith.where((hadith) {
      final String title = hadith['title']?.toLowerCase() ?? '';
      final String text = hadith['text']?.toLowerCase() ?? '';
      final String ref = hadith['ref']?.toLowerCase() ?? '';
      final String category = hadith['category'] ?? '';

      final bool matchesKeyword = searchLower.isEmpty ||
          title.contains(searchLower) ||
          text.contains(searchLower) ||
          ref.contains(searchLower);

      final bool matchesCategory = _selectedCategory == 'الكل' ||
          (_selectedCategory == 'المفضلة'
              ? _favoriteTitles.contains(hadith['title'])
              : category == _selectedCategory);

      return matchesKeyword && matchesCategory;
    }).toList();

    if (!mounted) return;

    setState(() {
      filteredAhadith = results;
      _syncHadithKeys();
    });

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _runFilter(_searchController.text);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // المشاركة والنسخ
  // ═══════════════════════════════════════════════════════════════════════

  void _copyHadith(Map<String, String> hadith) {
    final String textToCopy =
        '${hadith['title']}\n\n${hadith['text']}\n\nالمصدر: ${hadith['ref']}\nتطبيق الروضة الشريفة';
    Clipboard.setData(ClipboardData(text: textToCopy));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'تم نسخ الحديث الشريف بنجاح',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3E9B61),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareHadith(Map<String, String> hadith) {
    final String shareText =
        '${hadith['title']}\n\n${hadith['text']}\n\nالمصدر: ${hadith['ref']}\n\nتم المشاركة عبر تطبيق الروضة';
    Share.share(shareText);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Details Bottom Sheet
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
              final double screenHeight = MediaQuery.sizeOf(sheetContext).height;
              final double maxHeight = screenHeight * 0.88;
              final Color surface = isDark ? _darkSurface : _lightSurface;
              final Color textColor = isDark ? _darkText : _lightText;
              final String title = hadith['title'] ?? '';
              final bool isFav = _favoriteTitles.contains(title);

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
                      border: Border.all(color: _gold.withValues(alpha: 0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.30),
                          blurRadius: 30,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: _gold.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'تكبير الخط',
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
                                    tooltip: 'تصغير الخط',
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
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'نسخ الحديث',
                                    icon: const Icon(
                                      Icons.copy_rounded,
                                      color: _gold,
                                      size: 20,
                                    ),
                                    onPressed: () => _copyHadith(hadith),
                                  ),
                                  IconButton(
                                    tooltip: 'مشاركة الحديث',
                                    icon: const Icon(
                                      Icons.share_rounded,
                                      color: _gold,
                                      size: 20,
                                    ),
                                    onPressed: () => _shareHadith(hadith),
                                  ),
                                  IconButton(
                                    tooltip:
                                        isFav ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                                    icon: Icon(
                                      isFav
                                          ? Icons.bookmark_rounded
                                          : Icons.bookmark_border_rounded,
                                      color: isFav ? Colors.amber : _gold,
                                      size: 22,
                                    ),
                                    onPressed: () async {
                                      await _toggleFavorite(title);
                                      setSheetState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              20,
                              0,
                              20,
                              MediaQuery.viewInsetsOf(sheetContext).bottom + 22,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (hadith['category'] != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _gold.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _gold.withValues(alpha: 0.25),
                                      ),
                                    ),
                                    child: Text(
                                      hadith['category']!,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _gold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 22,
                                    height: 1.35,
                                    fontWeight: FontWeight.bold,
                                    color: _gold,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: _gold.withValues(alpha: 0.18),
                                ),
                                const SizedBox(height: 18),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _gold.withValues(
                                      alpha: isDark ? 0.06 : 0.045,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _gold.withValues(alpha: 0.20),
                                    ),
                                  ),
                                  child: SelectableText(
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
                                const SizedBox(height: 18),
                                _buildSourceChip(hadith['ref'] ?? '', isDark),
                                const SizedBox(height: 18),
                                const Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'شرح الحديث والتوجيه النبوي',
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
                                    color: textColor.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _copyHadith(hadith),
                                        icon: const Icon(Icons.copy, size: 18),
                                        label: const Text(
                                          'نسخ',
                                          style: TextStyle(fontFamily: 'Cairo'),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: _gold,
                                          side: const BorderSide(color: _gold),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _shareHadith(hadith),
                                        icon: const Icon(Icons.share, size: 18),
                                        label: const Text(
                                          'مشاركة',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _gold,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
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
      ErrorHandler.logError('Error showing hadith details: $e', StackTrace.current);
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
        ? 60
        : isTablet
            ? 35
            : 14;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: IslamicPatternPainter(color: patternColor),
                ),
              ),
            ),
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
                            const SizedBox(height: 8),
                            _buildAppHeader(isDark, textColor),
                            const SizedBox(height: 12),
                            _buildSearchField(isDark, textColor),
                            const SizedBox(height: 10),
                            _buildCategorySelector(isDark),
                            const SizedBox(height: 10),
                            if (filteredAhadith.isNotEmpty)
                              _buildResultsHeader(isDark, textColor),
                            const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Helper Widgets
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAppHeader(bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
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
                size: 22,
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
                  'الموسوعة الحديثية الشريفة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 21,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'أحاديث صحيحة من الهدي النبوي وأذكار النوم والروضة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    color: textColor.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isDark, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _gold.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.10 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
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
          hintText: 'ابحث عن حديث، أذكار النوم، الروضة، مصدر...',
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: textColor.withValues(alpha: 0.45),
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: _gold, size: 21),
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
                    size: 18,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String cat = _categories[index];
          final bool isSelected = _selectedCategory == cat;

          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cat == 'المفضلة') ...[
                  Icon(
                    Icons.bookmark,
                    size: 13,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.amber : _gold),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  cat,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? _darkText : _lightText),
                  ),
                ),
              ],
            ),
            selected: isSelected,
            selectedColor: _gold,
            backgroundColor: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide(
              color: isSelected ? _gold : _gold.withValues(alpha: 0.22),
            ),
            onSelected: (_) => _selectCategory(cat),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader(bool isDark, Color textColor) {
    final int count = filteredAhadith.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 14,
            color: _gold.withValues(alpha: 0.80),
          ),
          const SizedBox(width: 6),
          Text(
            _selectedCategory == 'الكل'
                ? 'جميع الأحاديث'
                : 'قسم: $_selectedCategory',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor.withValues(alpha: 0.70),
            ),
          ),
          const Spacer(),
          Text(
            '$count حديث',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }

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
        padding: const EdgeInsets.fromLTRB(2, 4, 2, 90),
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

  Widget _buildHadithCard(
    BuildContext context,
    Map<String, String> hadith,
    bool isDark,
    int index,
  ) {
    final Color textColor = isDark ? _darkText : _lightText;
    final String title = hadith['title'] ?? '';
    final bool isFav = _favoriteTitles.contains(title);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showHadithDetails(context, hadith, isDark),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: isDark ? AppConstants.brownGradient : null,
              color: isDark ? null : Colors.white.withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFav
                    ? Colors.amber.withValues(alpha: 0.60)
                    : _gold.withValues(alpha: 0.20),
                width: isFav ? 1.4 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.12 : 0.04,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              _gold.withValues(alpha: 0.25),
                              _gold.withValues(alpha: 0.08),
                            ],
                          ),
                          border: Border.all(
                            color: _gold.withValues(alpha: 0.25),
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _gold,
                              ),
                            ),
                            if (hadith['category'] != null)
                              Text(
                                hadith['category']!,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  color: textColor.withValues(alpha: 0.50),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'نسخ',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.copy_rounded,
                              size: 18,
                              color: _gold,
                            ),
                            onPressed: () => _copyHadith(hadith),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            tooltip: 'مشاركة',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.share_rounded,
                              size: 18,
                              color: _gold,
                            ),
                            onPressed: () => _shareHadith(hadith),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            tooltip: isFav ? 'مفضل' : 'إضافة للمفضلة',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isFav ? Icons.bookmark : Icons.bookmark_outline,
                              size: 20,
                              color: isFav ? Colors.amber : _gold,
                            ),
                            onPressed: () => _toggleFavorite(title),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: isDark ? 0.04 : 0.03),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _gold.withValues(alpha: 0.10),
                      ),
                    ),
                    child: SelectableText(
                      hadith['text'] ?? '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: _fontSize,
                        height: 1.8,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 13,
                        color: _gold.withValues(alpha: 0.80),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          hadith['ref'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: textColor.withValues(alpha: 0.60),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'التفاصيل والشرح',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _gold,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: _gold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color textColor) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _gold.withValues(alpha: 0.08),
                border: Border.all(color: _gold.withValues(alpha: 0.20)),
              ),
              child: Icon(
                _selectedCategory == 'المفضلة'
                    ? Icons.bookmark_border
                    : Icons.search_off_rounded,
                size: 40,
                color: _gold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedCategory == 'المفضلة'
                  ? 'لا توجد أحاديث مفضلة حالياً'
                  : 'لم نجد نتائج مطابقة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedCategory == 'المفضلة'
                  ? 'يمكنك إضافة أي حديث إلى قائمة المفضلة للوصول السريع إليه بالضغط على أيقونة الإشارة المرجعية'
                  : 'تأكد من كتابة الكلمة بشكل صحيح أو اختر قسماً آخر من الأعلى',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                height: 1.6,
                color: textColor.withValues(alpha: 0.60),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                _selectCategory('الكل');
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'عرض جميع الأحاديث',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceChip(String source, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _gold.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_outlined, size: 14, color: _gold),
          const SizedBox(width: 6),
          Text(
            source,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }
}
