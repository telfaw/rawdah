import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/nusuk_helper.dart';
import 'package:rawdah/utils/settings_helper.dart';

class RawdahInfoScreen extends StatefulWidget {
  const RawdahInfoScreen({super.key});

  @override
  State<RawdahInfoScreen> createState() => _RawdahInfoScreenState();
}

class _RawdahInfoScreenState extends State<RawdahInfoScreen> {
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadFontSettings();
  }

  Future<void> _loadFontSettings() async {
    final sizes = await AppSettings.loadFontSizes();
    if (mounted) {
      setState(() {
        _fontSize = sizes['body'] ?? 16.0;
      });
    }
  }

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
                    'ينبغي للزائر التحلي بالسكينة والوقار، والإكثار من الصلاة والسلام على النبي ﷺ وعلى صاحبيه رضي الله عنهما، والالتزام بالأنظمة والتعليمات الرسمية لتنظيم الزيارة.',
                icon: Icons.volunteer_activism,
                textColor: textColor,
                cardColor: cardColor,
                isDark: isDark,
                fontSize: _fontSize,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSummary(bool isDark) {
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
          color: AppConstants.primaryGold.withValues(alpha: 0.25),
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
                color: AppConstants.primaryGold.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryGold.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const ShineEffect(
              child: Icon(
                Icons.mosque_rounded,
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
                  'عن الروضة الشريفة',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 21,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFE8D8BD) : const Color(0xFF3E2723),
                  ),
                ),
                Text(
                  'أطهر البقاع وأعظمها بركة في مسجد رسول الله ﷺ',
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
    );
  }

  Widget _buildNusukBanner(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => NusukHelper.openNusukInStore(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.app_shortcut_rounded, color: Colors.blueAccent, size: 28),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'احجز زيارة الروضة عبر تطبيق نسك',
                      style: TextStyle(
                        fontFamily: AppConstants.secondaryFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'التصاريح الرسمية تتم حصراً عبر تطبيق نسك المعتمد',
                      style: TextStyle(
                        fontFamily: AppConstants.secondaryFont,
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueAccent),
            ],
          ),
        ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.primaryGold.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppConstants.primaryGold, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppConstants.arabicFont,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: TextStyle(
              fontFamily: AppConstants.secondaryFont,
              fontSize: fontSize,
              height: 1.8,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
