import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/painters.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  final ScrollController _scrollController = ScrollController();
  double _fontSize = 14.0;

  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkBackground = Color(0xFF1A130F);
  static const Color darkCard = Color(0xFF2D1B10);
  static const Color lightBackground = Color(0xFFF7F3E9);
  static const Color lightText = Color(0xFF3E2723);
  static const Color darkText = Color(0xFFE6D5B8);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBackground = isDark ? darkBackground : lightBackground;
    final Color textColor = isDark ? darkText : lightText;
    final Color patternColor = isDark
        ? Colors.white.withValues(alpha: 0.035)
        : Colors.black.withValues(alpha: 0.025);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBackground,
        appBar: _buildAppBar(isDark),
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppConstants.darkBackgroundGradient
                : AppConstants.lightBackgroundGradient,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: IslamicPatternPainter(color: patternColor),
                  ),
                ),
              ),
              SafeArea(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  interactive: true,
                  radius: const Radius.circular(20),
                  thickness: 6,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 35),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          children: [
                            _buildAppIdentity(context, isDark, textColor),
                            const SizedBox(height: 28),
                            _buildSection(
                              title: "رؤية تطبيق الروضة",
                              content:
                                  "تطبيق 'الروضة' هو مبادرة تقنية تهدف إلى تقديم محتوى إسلامي موثق وشامل حول السيرة النبوية الشريفة ومعالم المدينة المنورة. صُمم التطبيق ليكون مرجعاً ميسراً للزوار والمحبين، يجمع بين عبق التاريخ الإسلامي وسهولة الاستخدام الحديثة.",
                              icon: Icons.auto_awesome_outlined,
                              textColor: textColor,
                              isDark: isDark,
                              fontSize: _fontSize,
                            ),
                            _buildSection(
                              title: "إخلاء مسؤولية رسمي",
                              content:
                                  "تطبيق 'الروضة' هو تطبيق تعليمي وثقافي مستقل تماماً، وليس له أي صفة رسمية أو علاقة بوزارة الحج والعمرة أو تطبيق 'نسك' (Nusuk). إن الهدف من التطبيق هو التعريف بفضائل الروضة وسير الصحابة فقط. نرجو من الراغبين في حجز زيارة الروضة الشريفة أو العمرة التوجه حصراً للتطبيق الرسمي المعتمد.",
                              icon: Icons.warning_amber_rounded,
                              textColor: textColor,
                              isDark: isDark,
                              iconColor: Colors.redAccent,
                              borderColor: Colors.redAccent.withValues(
                                alpha: 0.3,
                              ),
                              fontSize: _fontSize,
                            ),
                            _buildDetailedFeatures(context, textColor, isDark),
                            const SizedBox(height: 20),
                            _buildSection(
                              title: "المصادر والمراجع",
                              content:
                                  "تم الاعتماد في جمع محتوى التطبيق على المصادر الإسلامية الموثوقة، ومنها:\n• القرآن الكريم (مجمع الملك فهد لطباعة المصحف الشريف).\n• الأحاديث النبوية من صحيح البخاري وصحيح مسلم والكتب الستة.\n• كتب السيرة النبوية المعتمدة (مثل الرحيق المختوم).\n• المصادر التاريخية الموثقة لمعالم المدينة المنورة الصادرة عن الجهات المختصة.",
                              icon: Icons.library_books_rounded,
                              textColor: textColor,
                              isDark: isDark,
                              fontSize: _fontSize,
                            ),
                            _buildStatsSection(context, textColor, isDark),
                            const SizedBox(height: 16),
                            _buildFooter(textColor),
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

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: isDark ? darkCard : const Color(0xFF5D4037),
      foregroundColor: Colors.white,
      title: const ShineEffect(
        child: Text(
          "عن تطبيق الروضة",
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.text_increase),
          tooltip: 'تكبير الخط',
          onPressed: () {
            setState(() {
              if (_fontSize < 24) _fontSize += 2;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.text_decrease),
          tooltip: 'تصغير الخط',
          onPressed: () {
            setState(() {
              if (_fontSize > 10) _fontSize -= 2;
            });
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDark
                ? [const Color(0xFF352015), const Color(0xFF21150F)]
                : [const Color(0xFF6D4C41), const Color(0xFF4E342E)],
          ),
          border: Border(
            bottom: BorderSide(
              color: primaryGold.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppIdentity(BuildContext context, bool isDark, Color textColor) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ShineEffect(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppConstants.goldGradient,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryGold.withValues(alpha: 0.2),
                  blurRadius: 25,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.mosque_outlined, size: 65, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "تطبيق الروضة",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: primaryGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryGold.withValues(alpha: 0.25)),
          ),
          child: const Text(
            "الإصدار 1.0.6",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: primaryGold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color textColor,
    required bool isDark,
    required double fontSize,
    Color iconColor = primaryGold,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        gradient: isDark ? AppConstants.brownGradient : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? primaryGold.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppConstants.goldGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryGold,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: primaryGold, thickness: 0.5),
            ),
            Text(
              content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                height: 1.8,
                color: isDark ? Colors.white.withValues(alpha: 0.9) : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedFeatures(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    final features = [
      {
        'title': 'السيرة النبوية العطرة',
        'desc':
            'رحلة إيمانية مفصلة في حياة النبي ﷺ من الميلاد إلى الوفاة، مع استعراض أهم الأحداث والدروس والعبر.',
        'icon': Icons.history_edu,
      },
      {
        'title': 'العشرة المبشرون بالجنة',
        'desc':
            'سير عطرة لصحابة النبي ﷺ الذين بشروا بالجنة، مع توضيح أدوارهم البطولية في نصرة الإسلام.',
        'icon': Icons.stars_rounded,
      },
      {
        'title': 'معالم الروضة الشريفة',
        'desc':
            'دليل شامل لأساطين (أعمدة) الروضة، حدودها الشرعية، فضل الصلاة فيها، وآداب السلام على النبي ﷺ.',
        'icon': Icons.mosque,
      },
      {
        'title': 'مكتبة الأحاديث الشريفة',
        'desc':
            'مجموعة منتقاة من الأحاديث النبوية الشريفة المتعلقة بفضل المدينة المنورة والروضة، مع شرح ميسر.',
        'icon': Icons.menu_book_rounded,
      },
      {
        'title': 'المسبحة الإلكترونية الذكية',
        'desc':
            'أداة رقمية تعينك على الذكر والتسبيح اليومي مع نظام متابعة الإنجاز والاهتزاز التفاعلي.',
        'icon': Icons.self_improvement,
      },
      {
        'title': 'شجرة الغزوات التفاعلية',
        'desc':
            'خريطة زمنية ومكانية للغزوات والسرايا النبوية، تعرض المعلومات العسكرية والنتائج بأسلوب تعليمي.',
        'icon': Icons.account_tree_outlined,
      },
      {
        'title': 'معالم المدينة المنورة',
        'desc':
            'استكشاف لأهم المواقع التاريخية في طيبة الطيبة مثل مسجد قباء، جبل أحد، ومقبرة البقيع.',
        'icon': Icons.location_on_outlined,
      },
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryGold.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.featured_play_list_outlined, color: primaryGold),
              const SizedBox(width: 10),
              const Text(
                "أقسام ومميزات التطبيق",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(f['icon'] as IconData, color: primaryGold, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryGold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          f['desc'] as String,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark ? AppConstants.brownGradient : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryGold.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('📱', 'تحديث', 'دوري', textColor),
          _buildStatItem('🎯', 'الهدف', 'نشر العلم', textColor),
          _buildStatItem('⭐', 'التقييم', 'ممتاز', textColor),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String emoji,
    String label,
    String value,
    Color textColor,
  ) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: textColor.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryGold,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(Color textColor) {
    return Column(
      children: [
        const Divider(color: primaryGold, thickness: 0.5),
        const SizedBox(height: 10),
        Text(
          "تم تطوير هذا التطبيق لخدمة الإسلام ونشر المعرفة النبوية",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: textColor.withValues(alpha: 0.5),
          ),
        ),
        const Text(
          "جميع الحقوق محفوظة © 2024",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
