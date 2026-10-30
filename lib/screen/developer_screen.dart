import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  static const Color primaryGold = Color(0xFFD4AF37);

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      ErrorHandler.logError("URL launch error: $e", StackTrace.current);
    }
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر طريقة التواصل',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryGold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              context,
              Icons.chat,
              'واتساب',
              'تواصل سريع للإنتاج التقني',
              () => _launchURL("https://wa.me/967777004173"),
              Colors.green,
            ),
            _buildContactOption(
              context,
              Icons.email,
              'إيميل',
              'للاقتراحات التقنية',
              () => _launchURL("mailto:fzfludev@gmail.com"),
              Colors.blue,
            ),
            _buildContactOption(
              context,
              Icons.phone,
              'اتصال',
              'للدعم الفني المباشر',
              () => _launchURL("tel:967777004173"),
              primaryGold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryGold.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
        ),
        trailing: const Icon(
          Icons.arrow_back_ios_new,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0D0D0D)
            : const Color(0xFFFCF9F2),
        appBar: AppBar(
          title: const ShineEffect(
            child: Text("عن المطور", style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold)),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFF5D4037),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppConstants.darkBackgroundGradient
                : AppConstants.lightBackgroundGradient,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: ShineEffect(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryGold, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGold.withValues(alpha: 0.35),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: isDark ? const Color(0xFF251810) : Colors.white,
                        child: Icon(
                          Icons.person_pin,
                          size: 80,
                          color: primaryGold.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "فواز الشميري",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryGold,
                  ),
                ),
                Text(
                  "متخصص تقنية معلومات ومطور تطبيقات",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : AppConstants.brownDark,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? AppConstants.brownGradient
                        : const LinearGradient(
                            colors: [Color(0xFFFFFDF8), Color(0xFFF6ECD7)],
                          ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryGold.withValues(alpha: 0.28),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "خبير في برمجة تطبيقات الهواتف الذكية والأنظمة البرمجية، أسعى لتوظيف التكنولوجيا الحديثة في خدمة المحتوى الإسلامي والحلول الخدمية المبتكرة باحترافية عالية.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      height: 1.7,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "تواصل معي للمقترحات والدعم الفني",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryGold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildContactCard(
                  icon: Icons.chat_outlined,
                  label: "تواصل عبر واتساب",
                  sublabel: "رد سريع ومباشر",
                  color: Colors.green,
                  onTap: () => _launchURL("https://wa.me/967777004173"),
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _buildContactCard(
                  icon: Icons.email_outlined,
                  label: "إرسال رسالة إلكترونية",
                  sublabel: "fzfludev@gmail.com",
                  color: Colors.blue,
                  onTap: () => _launchURL("mailto:fzfludev@gmail.com"),
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _buildContactCard(
                  icon: Icons.phone_outlined,
                  label: "اتصال تلفوني مباشر",
                  sublabel: "+967 777 004 173",
                  color: primaryGold,
                  onTap: () => _launchURL("tel:967777004173"),
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showContactOptions(context),
                  icon: const Icon(Icons.hub_outlined, color: primaryGold, size: 18),
                  label: const Text(
                    "عرض جميع خيارات التواصل",
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryGold,
                    side: const BorderSide(color: primaryGold),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryGold.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? Colors.white : AppConstants.brownDark,
                        ),
                      ),
                      Text(
                        sublabel,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: primaryGold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
