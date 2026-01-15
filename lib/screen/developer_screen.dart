import 'package:flutter/material.dart';
import 'package:rawdah/error_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

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
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 20),
            _buildContactOption(
              context,
              Icons.chat,
              'واتساب',
              'تواصل سريع',
                  () => _launchURL("https://wa.me/967777004173"),
              Colors.green,
            ),
            _buildContactOption(
              context,
              Icons.email,
              'إيميل',
              'للاقتراحات التقنية',
                  () => _launchURL("mailto:telfaw@gmail.com"), // التعديل هنا
              Colors.blue,
            ),
            _buildContactOption(
              context,
              Icons.phone,
              'اتصال',
              'للدعم الفني',
                  () => _launchURL("tel:967777004173"),
              const Color(0xFFD4AF37),
            ),
          ],
        ),
      ),
    );
  }

  // بقية الـ Widgets (تظل كما هي في كودك الأصلي)
  Widget _buildContactOption(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGold = Color(0xFFD4AF37);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFCF9F2),
        appBar: AppBar(
          title: const Text(
            "عن المطور",
            style: TextStyle(fontFamily: 'Amiri'),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFF5D4037),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryGold, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGold.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person_pin,
                      size: 90,
                      color: primaryGold.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                "متخصص تقنية معلومات",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "خبير في برمجة تطبيقات الهواتف الذكية والأنظمة البرمجية، أسعى لتوظيف التكنولوجيا الحديثة في خدمة المحتوى الإسلامي والحلول الخدمية المبتكرة.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    height: 1.6,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(indent: 50, endIndent: 50, thickness: 0.5),
              const Text(
                "تواصل معي للمقترحات والدعم الفني",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: primaryGold,
                ),
              ),
              const SizedBox(height: 15),
              _buildContactCard(
                icon: Icons.chat_outlined,
                label: "تواصل عبر واتساب",
                value: "إرسال رسالة مباشرة",
                color: Colors.green,
                onTap: () => _showContactOptions(context),
              ),
              const SizedBox(height: 10),
              _buildAdditionalInfo(isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // بقية الميثودز المساعدة تظل كما هي...
  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          trailing: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F3E9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: Color(0xFFD4AF37), size: 20),
              SizedBox(width: 10),
              Text(
                "رسالتنا",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "نسعى لنكون منارة تقنية في خدمة الإسلام والمسلمين، نحو تطبيقات ذكية تعكس أصالة الدين وروح العصر.",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              height: 1.6,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Divider(color: Color(0xFFD4AF37), thickness: 0.5),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip('اليمن', Icons.location_on),
              _buildInfoChip('Flutter Dev', Icons.code),
              _buildInfoChip('+5 سنوات', Icons.work),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: Color(0xFFD4AF37),
            ),
          ),
        ],
      ),
    );
  }
}