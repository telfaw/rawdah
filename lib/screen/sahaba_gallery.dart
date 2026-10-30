import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/screen/about_app_screen.dart';
import 'package:rawdah/screen/duaa_occasions_screen.dart';
import 'package:rawdah/screen/sahaba_swipe_screen.dart';
import 'package:rawdah/screen/settings_dialog.dart';
import 'package:rawdah/screen/tasbih_screen.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/nusuk_helper.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'ahadith_screen.dart';
import 'developer_screen.dart';
import 'ghazawat_tree_screen.dart';
import 'madinah_landmarks_screen.dart';
import 'prophet_biography_screen.dart';
import 'rawdah_info_screen.dart';

class SahabaGallery extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SahabaGallery({super.key, required this.toggleTheme});

  @override
  State<SahabaGallery> createState() => _SahabaGalleryState();
}

class _SahabaGalleryState extends State<SahabaGallery>
    with SingleTickerProviderStateMixin {
  static const List<String> _pageTitles = [
    "سيرة النبي ﷺ",
    "العشرة المبشرون بالجنة",
    "عن الروضة الشريفة",
    "أحاديث وفضائل الروضة",
    "أدعية القرآن والمناسبات",
    "المسبحة والاستغفار",
    "شجرة الغزوات",
    "معالم المدينة المنورة",
  ];

  static const List<Map<String, dynamic>> _pageNavItems = [
    {"title": "السيرة النبوية", "icon": Icons.account_circle_outlined, "isNew": false},
    {"title": "المبشرون", "icon": Icons.emoji_events_outlined, "isNew": false},
    {"title": "عن الروضة", "icon": Icons.mosque_outlined, "isNew": false},
    {"title": "الأحاديث", "icon": Icons.menu_book_rounded, "isNew": false},
    {"title": "أدعية القرآن", "icon": Icons.auto_awesome, "isNew": true},
    {"title": "المسبحة الذكية", "icon": Icons.self_improvement_rounded, "isNew": false},
    {"title": "الغزوات", "icon": Icons.landscape_outlined, "isNew": false},
    {"title": "معالم المدينة", "icon": Icons.location_on_outlined, "isNew": false},
  ];

  final PageController _mainPageController = PageController(initialPage: 0);
  late final TabController _tabController;
  double _currentPageValue = 0.0;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pageNavItems.length, vsync: this);
    _speech = stt.SpeechToText();
    _mainPageController.addListener(_onPageScroll);
  }

  @override
  void dispose() {
    _mainPageController.removeListener(_onPageScroll);
    _mainPageController.dispose();
    _tabController.dispose();
    if (_speech.isListening) {
      _speech.stop();
    }
    _speech.cancel();
    super.dispose();
  }

  void _onPageScroll() {
    if (mounted && _mainPageController.hasClients) {
      double? page = _mainPageController.page;
      if (page != null && page != _currentPageValue) {
        setState(() => _currentPageValue = page);
        final int roundPage = page.round();
        if (_tabController.index != roundPage && !_tabController.indexIsChanging) {
          _tabController.animateTo(roundPage);
        }
      }
    }
  }

  void _animateToPage(int index) {
    _mainPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _listen() async {
    if (!_isListening) {
      try {
        _speechEnabled = await _speech.initialize(
          onError: (val) => debugPrint('Error Speech: $val'),
          onStatus: (val) => debugPrint('Status Speech: $val'),
        );

        if (_speechEnabled) {
          setState(() => _isListening = true);
          _speech.listen(
            listenOptions: stt.SpeechListenOptions(localeId: 'ar_SA'),
            onResult: (val) {
              if (val.finalResult) _processVoiceSearch(val.recognizedWords);
            },
          );
        } else {
          _showNoMicMessage();
        }
      } catch (e) {
        debugPrint("Speech recognition not available: $e");
        _showNoMicMessage();
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _showNoMicMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "عذراً، ميزة البحث الصوتي غير مدعومة على هذا الجهاز",
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
      ),
    );
  }

  void _processVoiceSearch(String text) {
    for (var sahabi in AppConstants.sahabaData) {
      if (text.contains(sahabi['name'].split(' ')[0])) {
        _navigateToSahabi(sahabi);
        break;
      }
    }
    setState(() => _isListening = false);
  }

  void _navigateToSahabi(Map<String, dynamic> item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SahabaSwipeScreen(
          initialIndex: int.parse(item['id']),
          names: [
            "بشارة نبوية",
            ...AppConstants.sahabaData.map((e) => e['name'] as String),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int activePageIndex = _currentPageValue.round();
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double appTitleSize = screenWidth < 360 ? 16 : 18;
    final double drawerTitleSize = screenWidth < 360 ? 12.5 : 14;
    final double drawerSectionSize = screenWidth < 360 ? 11.5 : 12;

    final Color scaffoldBg = isDark
        ? const Color(0xFF0F0C0A)
        : const Color(0xFFF7F1E7);
    final Color appBarColor = isDark
        ? const Color(0xFF1B140F)
        : const Color(0xFF5B3D2E);
    final Color textColor = isDark ? const Color(0xFFF3E8D3) : Colors.white;

    final LinearGradient appBarGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFF1D1714), Color(0xFF3A2A22), Color(0xFF1B140F)],
          )
        : const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFF785A47), Color(0xFF563E32), Color(0xFF3A2A23)],
          );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBg,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            flexibleSpace: DecoratedBox(
              decoration: BoxDecoration(gradient: appBarGradient),
            ),
            elevation: 0,
            centerTitle: true,
            title: ShineEffect(
              child: Text(
                _pageTitles[activePageIndex.clamp(0, _pageTitles.length - 1)],
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: appTitleSize,
                ),
              ),
            ),
            actions: [],
            shape: const Border(
              bottom: BorderSide(color: Color(0xFFB98A2D), width: 1.2),
            ),
          ),
          drawer: _buildModernDrawer(
            context,
            isDark,
            drawerTitleSize,
            drawerSectionSize,
          ),
          body: Column(
            children: [
              _buildTopQuickNavBar(activePageIndex, isDark),
              Expanded(
                child: Stack(
                  children: [
                    PageView(
                      controller: _mainPageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        const ProphetBiographyScreen(),
                        _buildSahabaGrid(isDark),
                        const RawdahInfoScreen(),
                        const AhadithScreen(),
                        const DuaaOccasionsScreen(),
                        const TasbihScreen(),
                        const GhazawatTreeScreen(),
                        const MadinahLandmarksScreen(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildFloatingIndicator(activePageIndex, isDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Quick Top Navigation Bar (شريط الوصول والتنقل السريع)
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildTopQuickNavBar(int activeIndex, bool isDark) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B140F) : const Color(0xFF563E32),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        indicatorColor: const Color(0xFFD4AF37),
        indicatorWeight: 3.2,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
        labelColor: const Color(0xFFD4AF37),
        unselectedLabelColor: const Color(0xFFF6EAD2),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        dividerColor: Colors.transparent,
        tabs: _pageNavItems.map((item) {
          return Tab(
            height: 42,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item['icon'] as IconData, size: 16),
                const SizedBox(width: 6),
                Text(item['title'] as String),
                if (item['isNew'] == true) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'جديد',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
        onTap: (index) {
          _animateToPage(index);
        },
      ),
    );
  }

  Widget _buildModernDrawer(
    BuildContext context,
    bool isDark,
    double titleSize,
    double sectionSize,
  ) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          bottomLeft: Radius.circular(22),
        ),
      ),
      child: Container(
        color: isDark ? const Color(0xFF120E0D) : const Color(0xFFF6F0E6),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF5C3D2F),
                    Color(0xFF432C23),
                    Color(0xFF1E1512),
                  ],
                ),
              ),
              child: DrawerHeader(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/s.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.15,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mosque_rounded,
                        color: Color(0xFFE6D5B8),
                        size: 26,
                      ),
                    ),
                    const Text(
                      "تطبيق الروضه",
                      style: TextStyle(
                        color: Color(0xFFE6D5B8),
                        fontSize: 24,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "الموسوعة النبوية الشاملة - السيرة، الأحاديث، والذكر",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerSectionTitle("الأقسام العلمية", sectionSize, isDark),
            _buildDrawerItem(
              icon: Icons.account_circle_outlined,
              title: "سيرة النبي ﷺ",
              onTap: () => _goToPage(0),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerItem(
              icon: Icons.emoji_events_outlined,
              title: "العشرة المبشرون بالجنة",
              onTap: () => _goToPage(1),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerItem(
              icon: Icons.mosque_outlined,
              title: "عن الروضة الشريفة",
              onTap: () => _goToPage(2),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerItem(
              icon: Icons.menu_book_rounded,
              title: "الأحاديث النبوية الشريفة",
              onTap: () => _goToPage(3),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerItem(
              icon: Icons.auto_awesome,
              title: "أدعية القرآن والمناسبات",
              badgeText: "جديد",
              onTap: () => _goToPage(4),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerSectionTitle("العبادات والمعالم", sectionSize, isDark),
            _buildDrawerItem(
              icon: Icons.self_improvement,
              title: "المسبحة الذكية والأذكار",
              onTap: () => _goToPage(5),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerItem(
              icon: Icons.landscape_outlined,
              title: "شجرة الغزوات والسرايا",
              onTap: () => _goToPage(6),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerItem(
              icon: Icons.location_on_outlined,
              title: "معالم المدينة المنورة",
              onTap: () => _goToPage(7),
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            const Divider(indent: 20, endIndent: 20, height: 30),
            _buildDrawerItem(
              icon: Icons.app_shortcut_rounded,
              title: "تحميل تطبيق نسك",
              subtitle: "للحجوزات الرسمية للروضة",
              onTap: () => NusukHelper.openNusukInStore(),
              isDark: isDark,
              iconColor: Colors.blueAccent,
            ),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              title: "إعدادات التطبيق والمظهر",
              onTap: () {
                Navigator.pop(context);
                showAppSettingsDialog(
                  context,
                  onUpdated: () => setState(() {}),
                  onToggleTheme: widget.toggleTheme,
                  onVoiceSearch: _listen,
                );
              },
              isDark: isDark,
              titleFontSize: titleSize,
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: "عن التطبيق والرؤية",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutAppScreen()),
              ),
              isDark: isDark,
            ),
            _buildDrawerItem(
              icon: Icons.code,
              title: "عن المبرمج",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeveloperScreen(),
                ),
              ),
              isDark: isDark,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _goToPage(int index) {
    Navigator.pop(context);
    _animateToPage(index);
  }

  Widget _buildDrawerSectionTitle(String title, double size, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: isDark ? const Color(0xFFF0E1C4) : const Color(0xFF47342F),
        ),
      ),
    );
  }

  Widget _buildFloatingIndicator(int activeIndex, bool isDark) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF231A15), Color(0xFF3A2A20)],
                )
              : const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF5D4037), Color(0xFF7D5B3F)],
                ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _pageTitles.length,
            (index) => InkWell(
              onTap: () => _animateToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: activeIndex == index ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: activeIndex == index
                      ? const Color(0xFFD4AF37)
                      : (isDark ? Colors.white30 : Colors.white54),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSahabaGrid(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppConstants.darkBackgroundGradient
            : AppConstants.lightBackgroundGradient,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Container(
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
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
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
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: AppConstants.goldGradient,
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const ShineEffect(
                      child: Icon(
                        Icons.stars_rounded,
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
                          'العشرة المبشرون بالجنة',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 21,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFFE8D8BD) : const Color(0xFF3E2723),
                          ),
                        ),
                        Text(
                          'سِيَرٌ عطرة لأعظم صحابة رسول الله ﷺ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10.5,
                            color: (isDark ? const Color(0xFFE8D8BD) : const Color(0xFF3E2723)).withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.86,
              ),
              itemCount: AppConstants.sahabaData.length,
              itemBuilder: (context, index) =>
                  _buildFancyCard(AppConstants.sahabaData[index], isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badgeText,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
    double titleFontSize = 14,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: iconColor ?? const Color(0xFFD4AF37),
        size: 22,
      ),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              fontSize: titleFontSize,
              color: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF2F201B),
            ),
          ),
          if (badgeText != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                color: isDark ? Colors.white60 : const Color(0xFF5D4037),
              ),
            )
          : null,
      trailing: const Icon(
        Icons.arrow_back_ios_new,
        size: 14,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      tileColor: isDark
          ? Colors.white.withValues(alpha: 0.02)
          : Colors.black.withValues(alpha: 0.01),
    );
  }

  Widget _buildFancyCard(Map<String, dynamic> item, bool isDark) {
    return ShineEffect(
      enabled: int.parse(item['id']) <= 2,
      child: InkWell(
        onTap: () => _navigateToSahabi(item),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1F1713), Color(0xFF120E0D)],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFDF9), Color(0xFFF6EAD2)],
                  ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.28),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: 'image${item['id']}',
                        child: Image.asset(
                          "assets/images/${item['id']}.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.10),
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#${item['id']}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppConstants.brownGradient,
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.28),
                    ),
                  ),
                ),
                child: Text(
                  item['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF6EAD3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
