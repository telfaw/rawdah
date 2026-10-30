import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/painters.dart';
import 'package:rawdah/utils/settings_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DuaaOccasionsScreen extends StatefulWidget {
  const DuaaOccasionsScreen({super.key});

  @override
  State<DuaaOccasionsScreen> createState() => _DuaaOccasionsScreenState();
}

class _DuaaOccasionsScreenState extends State<DuaaOccasionsScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _darkBackground = Color(0xFF17100C);
  static const Color _darkSurface = Color(0xFF251810);
  static const Color _lightBackground = Color(0xFFF7F3E9);
  static const Color _lightSurface = Color(0xFFFFFCF5);
  static const Color _darkText = Color(0xFFE8D8BD);
  static const Color _lightText = Color(0xFF3E2723);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  double _fontSize = 18.0;
  String _selectedCategory = 'الكل';
  Set<String> _favoriteTitles = {};

  final List<String> _categories = [
    'الكل',
    'أدعية قرآنية',
    'شكر النعم والذرية',
    'أدعية المناسبات',
    'المفضلة',
  ];

  late List<Map<String, String>> allDuas;
  List<Map<String, String>> filteredDuas = [];

  @override
  void initState() {
    super.initState();
    allDuas = AppConstants.quranicDuas;
    filteredDuas = List<Map<String, String>>.from(allDuas);
    _loadFavorites();
    _loadFontSettings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFontSettings() async {
    final sizes = await AppSettings.loadFontSizes();
    if (mounted) {
      setState(() {
        _fontSize = sizes['body'] ?? 18.0;
      });
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favs = prefs.getStringList('favorite_duaa');
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
      await prefs.setStringList('favorite_duaa', _favoriteTitles.toList());

      if (_selectedCategory == 'المفضلة') {
        _runFilter(_searchController.text);
      }
    } catch (e) {
      ErrorHandler.logError('Failed to save favorite: $e', StackTrace.current);
    }
  }

  void _runFilter(String query) {
    final String searchLower = query.trim().toLowerCase();

    final List<Map<String, String>> results = allDuas.where((duaa) {
      final String title = duaa['title']?.toLowerCase() ?? '';
      final String text = duaa['text']?.toLowerCase() ?? '';
      final String ref = duaa['ref']?.toLowerCase() ?? '';
      final String category = duaa['category'] ?? '';

      final bool matchesKeyword = searchLower.isEmpty ||
          title.contains(searchLower) ||
          text.contains(searchLower) ||
          ref.contains(searchLower);

      final bool matchesCategory = _selectedCategory == 'الكل' ||
          (_selectedCategory == 'المفضلة'
              ? _favoriteTitles.contains(duaa['title'])
              : category.contains(_selectedCategory) ||
                  (_selectedCategory == 'أدعية قرآنية' && ref.contains('سورة')));

      return matchesKeyword && matchesCategory;
    }).toList();

    if (!mounted) return;

    setState(() {
      filteredDuas = results;
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

  void _copyDuaa(Map<String, String> duaa) {
    final String textToCopy =
        '${duaa['title']}\n\n${duaa['text']}\n\nالمصدر: ${duaa['ref']}\nتطبيق الروضة الشريفة';
    Clipboard.setData(ClipboardData(text: textToCopy));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'تم نسخ الدعاء الشريف بنجاح',
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

  void _shareDuaa(Map<String, String> duaa) {
    final String shareText =
        '${duaa['title']}\n\n${duaa['text']}\n\nالمصدر: ${duaa['ref']}\n\nتم المشاركة عبر تطبيق الروضة';
    Share.share(shareText);
  }

  void _showDuaaDetails(BuildContext context, Map<String, String> duaa, bool isDark) {
    final Color surface = isDark ? _darkSurface : _lightSurface;
    final Color textColor = isDark ? _darkText : _lightText;
    final String title = duaa['title'] ?? '';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bool isFav = _favoriteTitles.contains(title);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.88,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'نسخ',
                                  icon: const Icon(Icons.copy, color: _gold, size: 20),
                                  onPressed: () => _copyDuaa(duaa),
                                ),
                                IconButton(
                                  tooltip: 'مشاركة',
                                  icon: const Icon(Icons.share, color: _gold, size: 20),
                                  onPressed: () => _shareDuaa(duaa),
                                ),
                                IconButton(
                                  tooltip: isFav ? 'مفضل' : 'إضافة للمفضلة',
                                  icon: Icon(
                                    isFav ? Icons.bookmark : Icons.bookmark_outline,
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
                          padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
                          child: Column(
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: _gold,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: _gold.withValues(alpha: isDark ? 0.08 : 0.04),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _gold.withValues(alpha: 0.22)),
                                ),
                                child: SelectableText(
                                  duaa['text'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: _fontSize,
                                    height: 2.0,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _gold.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: _gold.withValues(alpha: 0.25)),
                                ),
                                child: Text(
                                  duaa['ref'] ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _gold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'الشرح والفضل المبارك',
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
                                duaa['explanation'] ?? '',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  height: 1.8,
                                  color: textColor.withValues(alpha: 0.85),
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
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBg = isDark ? _darkBackground : _lightBackground;
    final Color textColor = isDark ? _darkText : _lightText;
    final Color patternColor = isDark
        ? Colors.white.withValues(alpha: 0.035)
        : Colors.black.withValues(alpha: 0.025);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: IslamicPatternPainter(color: patternColor),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildHeader(isDark, textColor),
                    const SizedBox(height: 12),
                    _buildSearchField(isDark, textColor),
                    const SizedBox(height: 10),
                    _buildCategoryChips(isDark),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filteredDuas.isEmpty
                          ? _buildEmptyState(textColor)
                          : ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 90),
                              itemCount: filteredDuas.length,
                              itemBuilder: (context, index) {
                                return _buildDuaaCard(filteredDuas[index], isDark, index);
                              },
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

  Widget _buildHeader(bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(colors: [Color(0xFF2C1E17), Color(0xFF1B120E)])
            : const LinearGradient(colors: [Color(0xFFFFFDF8), Color(0xFFF6ECD7)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppConstants.goldGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أدعية القرآن وأذكار المناسبات',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'أدعية خليل الرحمن، شكر النعم، والذرية، وأدعية النبوة',
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
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withValues(alpha: 0.20)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _runFilter,
        style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: textColor),
        decoration: InputDecoration(
          hintText: 'ابحث في أدعية القرآن والمناسبات...',
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: textColor.withValues(alpha: 0.45),
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: _gold, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _runFilter('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(bool isDark) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final bool isSel = _selectedCategory == cat;

          return ChoiceChip(
            label: Text(
              cat,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                color: isSel ? Colors.white : (isDark ? _darkText : _lightText),
              ),
            ),
            selected: isSel,
            selectedColor: _gold,
            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
            showCheckmark: false,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(color: isSel ? _gold : _gold.withValues(alpha: 0.22)),
            onSelected: (_) => _selectCategory(cat),
          );
        },
      ),
    );
  }

  Widget _buildDuaaCard(Map<String, String> duaa, bool isDark, int index) {
    final Color textColor = isDark ? _darkText : _lightText;
    final String title = duaa['title'] ?? '';
    final bool isFav = _favoriteTitles.contains(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? AppConstants.brownGradient : null,
        color: isDark ? null : Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFav ? Colors.amber.withValues(alpha: 0.70) : _gold.withValues(alpha: 0.22),
          width: isFav ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gold.withValues(alpha: 0.15),
                  border: Border.all(color: _gold.withValues(alpha: 0.3)),
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
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _gold,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.copy, size: 18, color: _gold),
                    onPressed: () => _copyDuaa(duaa),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.share, size: 18, color: _gold),
                    onPressed: () => _shareDuaa(duaa),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: isDark ? 0.05 : 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _gold.withValues(alpha: 0.12)),
            ),
            child: SelectableText(
              duaa['text'] ?? '',
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                duaa['ref'] ?? '',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: textColor.withValues(alpha: 0.60),
                ),
              ),
              InkWell(
                onTap: () => _showDuaaDetails(context, duaa, isDark),
                child: const Row(
                  children: [
                    Text(
                      'الشرح والفضل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _gold,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.arrow_forward_ios_rounded, size: 10, color: _gold),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 45, color: _gold),
          const SizedBox(height: 12),
          Text(
            'لا توجد نتائج مطابقة',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              _selectCategory('الكل');
            },
            style: ElevatedButton.styleFrom(backgroundColor: _gold),
            child: const Text('عرض الكل', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }
}
