import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/settings_helper.dart';

class MadinahLandmarksScreen extends StatefulWidget {
  const MadinahLandmarksScreen({super.key});

  @override
  State<MadinahLandmarksScreen> createState() => _MadinahLandmarksScreenState();
}

class _MadinahLandmarksScreenState extends State<MadinahLandmarksScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _landmarkKeys = List.generate(
    _landmarks.length,
    (_) => GlobalKey(),
  );

  double _fontSize = 13.0;

  @override
  void initState() {
    super.initState();
    _loadFontSettings();
  }

  Future<void> _loadFontSettings() async {
    final sizes = await AppSettings.loadFontSizes();
    if (mounted) {
      setState(() {
        _fontSize = sizes['body'] ?? 14.0;
      });
    }
  }

  static const List<Map<String, dynamic>> _landmarks = [
    {
      'title': 'مسجد قباء',
      'description':
          'أول مسجد أسس في الإسلام، ويقع على مشارف المدينة المنورة، ويُعد من أعظم مواقع الزيارة للزائر المسلم لما له من فضيلة وذكر في السنة النبوية.',
      'route':
          'يمكن الوصول إليه من المسجد النبوي عبر شارع المدينة أو من باب السلام باتجاه الشمال، ويقارب الوصول 5–7 دقائق بالسيارة أو نحو 20–30 دقيقة مشياً على الأقدام بحسب نقطة الانطلاق.',
      'hadith':
          'عن أبي هريرة رضي الله عنه: «من تطهر في بيته ثم أتى مسجد قباء فصلى فيه ركعتين كان كعمره» (رواه النسائي وابن ماجه، وصححه الحاكم).',
      'benefit':
          'يفتح باب الدعاء والرحلة الروحانية، ويستحب للقادم إلى المدينة أن يزوره ويصلي فيه.',
      'icon': Icons.account_balance,
    },
    {
      'title': 'مقبرة البقيع',
      'description':
          'أكبر وأشهر مقبرة في المدينة المنورة، دفن فيها عدد كبير من الصحابة والتابعين وأهل البيت، وهي مكانٌ للتأمل والذكر والاستغفار.',
      'route':
          'تقع جنوب المسجد النبوي، ويمكن الوصول إليها عبر بوابات المدينة الجنوبية، وغالباً عبر taxi أو السيارة في بضع دقائق من الساحة الكبرى.',
      'hadith':
          'عن أبي هريرة رضي الله عنه: «استغفروا لأهل البقيع» كما ورد في روايات متعددة عن زيارة القبور والذكر عندها، مع التزام التواضع والرحمة.',
      'benefit':
          'تعزّز الخشوع، وتذكر الإنسان بمآل الدنيا، وتفتح باب الاستغفار والدعاء لأهل القبور.',
      'icon': Icons.landscape,
    },
    {
      'title': 'جبل أحد',
      'description':
          'من أشهر المعالم التاريخية في المدينة المنورة، وهو موضع معركة أحد الشهيرة، ويضم موقعاً مهيباً وقبر الشهداء، ويُذكر بالحب والوفاء.',
      'route':
          'يقع إلى شمال المدينة، ويمكن الوصول إليه بالسيارة عبر الطريق المؤدي إلى منطقة أحد، ويستغرق السفر من المسجد النبوي نحو 15–20 دقيقة تقريباً.',
      'hadith':
          'قال النبي ﷺ: «جبل أحد جبل يحبنا ونحبه» وهو حديث صحيح، وهو من أعظم دعائم محبة المدينة وأهلها.',
      'benefit':
          'يمنح الزائر فرصة للتأمل في استشهاد الشهداء، ويقوّي العزيمة في الالتزام والدعوة.',
      'icon': Icons.terrain,
    },
    {
      'title': 'مسجد القبلتين',
      'description':
          'المسجد الذي استمرّ في الصلاة فيه إلى أن أنزلت آية تحويل القبلة، وهو علامة تاريخية بارزة في المدينة المنورة.',
      'route':
          'يقع في جنوب المدينة بالقرب من مناطق السكن والطرق الرئيسية، ويمكن الوصول إليه بسهولة عبر وسائل النقل العامة أو السيارة.',
      'hadith':
          'عن أنس بن مالك رضي الله عنه: «إن أول ما نزل في تحويل القبلة ...» ومن أشهر روائع المكان أنه سُمي بالقبيلتين لوقوع التحول في الصلاتين.',
      'benefit':
          'يشرح الروح التاريخية للإسلام، ويعطي الزائر صورة واضحة عن تطور التشريع والعبادة في المدينة.',
      'icon': Icons.sync_alt,
    },
    {
      'title': 'المساجد السبعة',
      'description':
          'مجموعة من المساجد الصغيرة التي ترتبط بمواقع تاريخية ومشاهد من غزوة الأحزاب والخندق، وتُعد من أفضل أماكن الاستذكار والتأمل.',
      'route':
          'تقع في محيط المدينة المنورة، وغالباً يمكن زيارتها عبر جولات قصيرة داخل المدينة، مع نصيحة بترتيب الرحلة لتسهيل الوصول.',
      'hadith':
          'الحديث الشريف عن فضل الجهاد والذكر في محيط المدينة، مع التذكير بأن الجهاد والعبادة متلازمان في روح المدينة.',
      'benefit':
          'توسّع معرفة الزائر بالتاريخ الإسلامي وتُثري الزيارة الروحانية لمدينة الرسول ﷺ.',
      'icon': Icons.grid_view,
    },
    {
      'title': 'مسجد الغمامة',
      'description':
          'من المساجد المرتبطة بذكر صلاة العيد والاستسقاء، ويقع في جهة غربية من المدينة المنورة، ويُستحب التوجه إليه في بعض الأوقات.',
      'route':
          'يُقصد إليه غالباً من جهة الغرب من المدينة، ويمكن الوصول إليه بسهولة عبر السيارة أو كجزء من رحلة قصيرة داخل المدينة.',
      'hadith':
          'وقد كان للنبي ﷺ في بعض المناسبات إتيان مواضع خاصة للدعاء والاستسقاء، ومسمى مسجد الغمامة يوافق هذه الروح في التوبة والدعاء.',
      'benefit':
          'يفرّق بين الزيارة الترفيهية والزيارة الروحية، ويُذكّر الإنسان بدور الدعاء في حياة المسلم.',
      'icon': Icons.cloud_queue,
    },
    {
      'title': 'مسجد الجمعة',
      'description':
          'المكان الذي صلى فيه النبي ﷺ أول صلاة جمعة في المدينة، ويعد من أبرز المواقع السياحية والدينية التي تعكس عمق تاريخ المدينة.',
      'route':
          'يقع ضمن شبكة المواقع الدينية في المدينة، ويمكن الوصول إليه من مختلف محاور المدينة عبر سيارات الأجرة أو النقل الداخلي.',
      'hadith':
          'قال النبي ﷺ: «صلاة الجمعة واجبة على كل مسلم إلا أربعة: عبد مملوك...» وهي تذكير بأن المدينة كانت مركزاً للمعرفة والعبادة.',
      'benefit':
          'يُذكر الزائر بأهمية الجمعة والتنظيم الاجتماعي في المدينة، ويعطيه حساً بتاريخها الديني.',
      'icon': Icons.event_available,
    },
    {
      'title': 'بئر عثمان (بئر رومة)',
      'description':
          'بئر تاريخية اشترى عثمان بن عفان رضي الله عنه ثم جعلها في خدمة المسلمين، وهي اشتهرت بفضلها وذكرها في المدينة المنورة.',
      'route':
          'تتوفر وسائل النقل نحو المنطقة بسهولة، ويُفضل طلب توجيه محلي إذا كان الهدف زيارة الموقع بدقة خلال جولة المدينة.',
      'hadith':
          'الحديث المشهور في فضل الماء والإنفاق في سبيل الله، وقد استعملت هذه البئر في خدمة الناس ورفع حاجاتهم.',
      'benefit':
          'يُرسي مفهوم الخدمة العامة في الإسلام، ويعطي صورة واضحة عن اهتمام الصحابة في قضاء الحاجات.',
      'icon': Icons.water_drop,
    },
    {
      'title': 'مجمع الملك فهد لطباعة المصحف',
      'description':
          'من أبرز المؤسسات العلمية والثقافية في المدينة المنورة، ويُعد مركزاً كبيراً لخدمة المصحف الشريف وأعمال الكتابة والبحث.',
      'route':
          'يقع في جهة المدينة الشمالية الغربية، ويمكن الوصول إليه بسيارة خاصة أو عبر خدمات النقل المخصصة للعامة.',
      'hadith':
          'من فضائل حفظ كتاب الله وإشاعته ما جاء في قوله ﷺ: «من سلك طريقاً يلتمس فيه علماً...»',
      'benefit':
          'يعزز الوعي القرآني، ويُذكر الزائر بأهمية العلم والعمل في خدمة الدين.',
      'icon': Icons.menu_book,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark
        ? AppConstants.textLight
        : AppConstants.textDark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark
            ? AppConstants.darkBackground
            : AppConstants.lightBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppConstants.darkBackgroundGradient
                : AppConstants.lightBackgroundGradient,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 90),
                child: Column(
                  children: [
                    ..._landmarks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final landmark = entry.value;

                      return ShineEffect(
                        enabled: index == 0,
                        child: Container(
                          key: _landmarkKeys[index],
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: isDark
                                ? AppConstants.brownGradient
                                : const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xFFFFFDF8),
                                      Color(0xFFF6ECD7),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppConstants.primaryGold.withValues(
                                alpha: 0.28,
                              ),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.15 : 0.05,
                                ),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: AppConstants.goldGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppConstants.primaryGold
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    landmark['icon'],
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        landmark['title'],
                                        style: const TextStyle(
                                          fontFamily: AppConstants.arabicFont,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.primaryGold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        landmark['description'],
                                        style: TextStyle(
                                          fontFamily: AppConstants.secondaryFont,
                                          fontSize: _fontSize,
                                          height: 1.75,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? const Color(0xFFF3E5C5)
                                              : textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildInfoRow(
                                        'طرق الوصول',
                                        landmark['route'],
                                        isDark,
                                        textColor,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildInfoRow(
                                        'الحديث/الفضل',
                                        landmark['hadith'],
                                        isDark,
                                        textColor,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildInfoRow(
                                        'الفائدة',
                                        landmark['benefit'],
                                        isDark,
                                        textColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xFF1A140F), Color(0xFF2B2018)],
                              )
                            : const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xFFFDF7EE), Color(0xFFE7D29A)],
                              ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppConstants.primaryGold.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: AppConstants.primaryGold,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'نصيحة للزائر',
                                style: TextStyle(
                                  fontFamily: AppConstants.arabicFont,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.primaryGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أخي الزائر، احرص على السكينة والوقار في هذه البقاع الطاهرة، واستغل كل لحظة في الذكر والدعاء.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppConstants.secondaryFont,
                              fontSize: 14,
                              height: 1.6,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInfoRow(
    String label,
    String content,
    bool isDark,
    Color textColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppConstants.primaryGold.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppConstants.arabicFont,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontFamily: AppConstants.secondaryFont,
              fontSize: _fontSize,
              height: 1.7,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF2E2BC) : textColor,
            ),
          ),
        ],
      ),
    );
  }
}
