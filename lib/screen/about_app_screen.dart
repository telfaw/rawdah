import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? const Color(0xFFE6D5B8) : const Color(0xFF3E2723);
    final Color cardColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white;
    const Color primaryGold = Color(0xFFD4AF37);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A130F) : const Color(0xFFF7F3E9),
        appBar: AppBar(
          title: const Text(
            "عن تطبيق الروضة",
            style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF2D1B10) : const Color(0xFF5D4037),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // شعار التطبيق
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryGold.withOpacity(0.1),
                    border: Border.all(color: primaryGold.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.menu_book_outlined, size: 80, color: primaryGold),
                ),
              ),
              const SizedBox(height: 15),

              // اسم التطبيق
              Text(
                "تطبيق الروضة",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                "الإصدار 1.0.3",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 30),

              // أقسام التطبيق
              _buildSection(
                "ما هو تطبيق الروضة؟",
                "تطبيق 'الروضة' هو رفيقك الرقمي لتعميق صلتك بالتراث الإسلامي العريق. صُمم ليكون واحةً غناء تجمع بين عبق المعرفة وطمأنينة العبادة؛ حيث يستعرض السيرة النبوية الشريفة، وسير الصحابة الكرام، مع أدوات ذكية تعينك على ذكر الله بأسلوب تقني يمزج بين سلاسة الاستخدام وجمال التصميم.",
                Icons.info_outline,
                textColor,
                cardColor,
              ),

              _buildSection(
                "دليل الاستخدام الذكي",
                "• استكشف سير الصحابة: أبحر في قصص أبطال الإسلام عبر بطاقات تفاعلية تدعم السحب والإيماءات الذكية.\n"
                    "• المسبحة المطورة: سبّح بتركيز مع نظام الانتقال التلقائي بين الأذكار، ومدعومة بخاصية الاهتزاز التي تحاكي حبات المسبحة الواقعية.\n"
                    "• شجرة الغزوات: خريطة زمنية تفاعلية تتيح لك استعراض المعارك الفاصلة في التاريخ الإسلامي مع ميزة التقريب اللمسي.\n"
                    "• مكتبة الأحاديث: مجموعة منتقاة من الأحاديث النبوية المشروحة بأسلوب ميسر يعمق فهمك للمقاصد الشرعية.",
                Icons.touch_app_outlined,
                textColor,
                cardColor,
              ),

              _buildSection(
                "رؤيتنا التقنية",
                "نحن لا نتوقف هنا؛ رؤيتنا تهدف إلى تخصيص تجربتك بالكامل. نعمل في التحديثات القادمة على إضافة محرك بحث متطور يدعم الأوامر الصوتية، وزيادة المحتوى من الأذكار والأحاديث. كما نسعى لتفعيل نظام المزامنة السحابي لحفظ تقدمك، لضمان استمرارية إنجازاتك عبر مختلف أجهزتك، بإذن الله.",
                Icons.auto_awesome_outlined,
                textColor,
                cardColor,
              ),

              // مميزات إضافية
              _buildFeaturesSection(textColor, cardColor),

              // الإحصائيات
              _buildStatsSection(textColor, cardColor),

              const SizedBox(height: 20),
              const Divider(color: primaryGold, thickness: 0.5),

              // حقوق الملكية
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "صُنع بكل حب لخدمة المحتوى الإسلامي",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "جميع الحقوق محفوظة © 2024",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: primaryGold,
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
  }

  Widget _buildSection(String title, String content, IconData icon, Color textColor, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFFD4AF37), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: textColor.withOpacity(0.9),
              height: 1.8,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(Color textColor, Color cardColor) {
    final features = [
      {'icon': Icons.people, 'title': 'الصحابة الكرام', 'desc': 'سير العشرة المبشرين بالجنة'},
      {'icon': Icons.mosque, 'title': 'احاديث الروضة الشريفة', 'desc': 'فضائل وأحكام زيارة الروضة'},
      {'icon': Icons.countertops, 'title': 'المسبحة الإلكترونية', 'desc': 'تسبيح ذكي مع عداد آلي'},
      {'icon': Icons.map, 'title': 'الغزوات', 'desc': 'خريطة تفاعلية للغزوات والسرايا'},
      {'icon': Icons.book, 'title': 'الأحاديث', 'desc': 'أحاديث نبوية منتقية مع الشروح'},
      {'icon': Icons.mic, 'title': 'البحث الصوتي', 'desc': 'ابحث عن الصحابة بصوتك'},
    ];

    const crossCount = 2;
    const childRatio = 1.5;
    const crossSpacing = 10.0;
    const mainSpacing = 10.0;
    final rowsCount = (features.length / crossCount).ceil();
    const itemHeight = 100.0;
    final gridHeight = rowsCount * (itemHeight + mainSpacing) - mainSpacing;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFD4AF37), size: 22),
              SizedBox(width: 12),
              Text(
                "المميزات الرئيسية",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: gridHeight,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                childAspectRatio: childRatio,
                crossAxisSpacing: crossSpacing,
                mainAxisSpacing: mainSpacing,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                return _buildFeatureItem(
                  features[index]['icon']! as IconData,
                  features[index]['title']! as String,
                  features[index]['desc']! as String,
                  textColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      IconData icon, String title, String desc, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // إذا كان الارتفاع كافياً نعرض Column العادي
          const double neededHeight = 90; // ارتفاع تقديري للنصوص + أيقونة
          if (constraints.maxHeight >= neededHeight) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFFD4AF37), size: 24),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }
          // إذا لم يكفِ الارتفاع نستعمل ListView ليتم التمرير داخل البطاقة
          return Scrollbar(
            thickness: 2,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              children: [
                const SizedBox(height: 6),
                Icon(icon, color: const Color(0xFFD4AF37), size: 22),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildStatsSection(Color textColor, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: Color(0xFFD4AF37), size: 22),
              SizedBox(width: 12),
              Text(
                "في التحديثات القادمة إحصائيات التطبيق",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('📱', 'التنزيلات', '1000+'),
              _buildStatItem('⭐', 'التقييم', '4.8'),
              _buildStatItem('🎯', 'الهدف', 'خدمة الإسلام'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37),
          ),
        ),
      ],
    );
  }
}