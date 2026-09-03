import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/nusuk_helper.dart';

class RawdahInfoScreen extends StatefulWidget {
  const RawdahInfoScreen({super.key});

  @override
  State<RawdahInfoScreen> createState() => _RawdahInfoScreenState();
}

class _RawdahInfoScreenState extends State<RawdahInfoScreen> {
  double _fontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark
        ? AppConstants.textLight
        : AppConstants.textDark;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark
          ? AppConstants.darkBackground
          : AppConstants.lightBackground,
      appBar: AppBar(
        title: const ShineEffect(
          child: Text(
            'عن الروضة الشريفة',
            style: TextStyle(
              fontFamily: AppConstants.arabicFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: isDark
            ? const Color(0xFF1A1A1A)
            : AppConstants.brownDark,
        foregroundColor: AppConstants.textLight,
        centerTitle: true,
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppConstants.darkBackgroundGradient
              : AppConstants.lightBackgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeroSummary(isDark),
              const SizedBox(height: 16),
              _buildNusukBanner(isDark),
              const SizedBox(height: 16),
              ShineEffect(
                child: _buildInfoCard(
                  title: 'ما هي الروضة الشريفة؟',
                  content:
                      'عن النبي ﷺ قال: "مَا بَيْنَ بَيْتِي وَمِنْبَرِي رَوْضَةٌ مِنْ رِيَاضِ الْجَنَّةِ". وهي تقع في المسجد النبوي الشريف، وتحديداً المساحة الممتدة من بيت النبي ﷺ (القبر الشريف حالياً) إلى منبره.',
                  icon: Icons.mosque,
                  textColor: textColor,
                  cardColor: cardColor,
                  isDark: isDark,
                  fontSize: _fontSize,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'فضل الصلاة فيها',
                content:
                    'تعتبر الصلاة في الروضة الشريفة ذات فضل عظيم، فهي قطعة من الجنة في الأرض، ويستحب للمسلم إذا زار المسجد النبوي أن يحرص على الصلاة والذكر والدعاء فيها بخشوع وسكينة.',
                icon: Icons.star_border_purple500,
                textColor: textColor,
                cardColor: cardColor,
                isDark: isDark,
                fontSize: _fontSize,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'آداب الزيارة',
                content:
                    '1. الوضوء والتطيب ولبس أحسن الثياب.\n2. الدخول بالسكينة والوقار.\n3. السلام على النبي ﷺ وصاحبيه أبي بكر وعمر رضي الله عنهما.\n4. خفض الصوت وعدم مزاحمة الزوار.\n5. الإكثار من الصلاة على النبي ﷺ.',
                icon: Icons.menu_book,
                textColor: textColor,
                cardColor: cardColor,
                isDark: isDark,
                fontSize: _fontSize,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'أهم أساطين (أعمدة) الروضة',
                content:
                    '• اسطوانة السرير: حيث كان يوضع سرير النبي ﷺ.\n• اسطوانة الحرس: حيث كان يجلس الحراس لحماية النبي ﷺ.\n• اسطوانة الوفود: حيث كان النبي ﷺ يستقبل الوفود.\n• اسطوانة التوبة (أبي لبابة): التي ربط فيها أبو لبابة نفسه توبةً.',
                icon: Icons.account_balance,
                textColor: textColor,
                cardColor: cardColor,
                isDark: isDark,
                fontSize: _fontSize,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'كيفية السلام على النبي ﷺ',
                content:
                    'يقول الزائر بأدب وخفض صوت: "السلام عليك يا رسول الله ورحمة الله وبركاته، أشهد أنك بلغت الرسالة وأديت الأمانة ونصحت الأمة، فجزاك الله عنا خير ما جزى نبياً عن أمته".',
                icon: Icons.volunteer_activism,
                textColor: textColor,
                cardColor: cardColor,
                isDark: isDark,
                fontSize: _fontSize,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'حدود الروضة الحالية',
                content:
                    'تتميز الروضة الشريفة حالياً بالسجاد الأخضر، بينما بقية المسجد النبوي مفروش بالسجاد الأحمر، مما يسهل على الزائر معرفة حدودها الشرعية التي حددها النبي ﷺ.',
                icon: Icons.straighten,
                textColor: textColor,
                cardColor: cardColor,
                isDark: isDark,
                fontSize: _fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSummary(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF2C1E18),
                  Color(0xFF4B352D),
                  Color(0xFF1D140F),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF7C5C49),
                  Color(0xFF563F33),
                  Color(0xFF36251D),
                ],
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppConstants.primaryGold.withValues(alpha: 0.38),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGold.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: AppConstants.goldGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mosque_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الروضة الشريفة',
                  style: TextStyle(
                    fontFamily: AppConstants.arabicFont,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'بقعة من الجنة في المدينة المنورة، تعكس روح الدعاء والوقار والعبادة.',
                  style: TextStyle(
                    fontFamily: AppConstants.secondaryFont,
                    fontSize: 12.5,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color textColor,
    required Color cardColor,
    required bool isDark,
    required double fontSize,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF5D4037),
                  Color(0xFF2E221D),
                  Color(0xFF5D4037),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFFAF3DD),
                  Color(0xFFF7E5B3),
                  Color(0xFFF5E7C7),
                ],
              ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGold.withValues(
              alpha: isDark ? 0.14 : 0.10,
            ),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B140F) : Colors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: AppConstants.goldGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppConstants.arabicFont,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(
                color: AppConstants.primaryGold,
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontFamily: AppConstants.secondaryFont,
                  fontSize: fontSize,
                  height: 1.8,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFF3E7D3) : textColor,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNusukBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF2E1B1B), Color(0xFF3C2A2A)],
              )
            : const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFFFFF1F1), Color(0xFFFBE4D5)],
              ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.redAccent, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تنبيه هام",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.redAccent,
                  ),
                ),
                Text(
                  "هذا التطبيق تعليمي ولا يتبع حجوزات الروضة. للحجز الرسمي استخدم تطبيق نسك.",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => NusukHelper.openNusukInStore(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "فتح نسك",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
