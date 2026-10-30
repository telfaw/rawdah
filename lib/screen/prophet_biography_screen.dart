import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/settings_helper.dart';

class ProphetBiographyScreen extends StatefulWidget {
  const ProphetBiographyScreen({super.key});

  @override
  State<ProphetBiographyScreen> createState() => _ProphetBiographyScreenState();
}

class _ProphetBiographyScreenState extends State<ProphetBiographyScreen> {
  final ScrollController _scrollController = ScrollController();
  double _fontSize = 16.0;

  static final List<_BiographySection> _sections = [
    const _BiographySection(
      title: 'نسب النبي ﷺ',
      content:
          'هو محمد بن عبد الله بن عبد المطلب بن هاشم بن عبد مناف بن قصي بن كلاب بن مرة بن كعب بن لؤي بن غالب بن فهر بن مالك بن النضر بن كنانة بن خزيمة بن مدركة بن إلياس بن مضر بن نزار بن معد بن عدنان. وهو من قريش، من بني هاشم. وقد اصطفاه الله تعالى لحمل رسالته وتبليغ دينه إلى الناس.',
      icon: Icons.account_circle,
    ),
    const _BiographySection(
      title: 'مولده ﷺ',
      content:
          'وُلد رسول الله ﷺ في مكة المكرمة في عام الفيل، وكان مولده يوم الاثنين، كما ثبت في الحديث. ولم يثبت بدليل صحيح تحديد اليوم من شهر ربيع الأول تحديدًا يجمع عليه أهل العلم؛ لذلك لا نجزم بيوم معين منه. وكان ﷺ يتيم الأب؛ فقد توفي والده عبد الله قبل ولادته.',
      icon: Icons.baby_changing_station,
    ),
    const _BiographySection(
      title: 'رضاعته ونشأته في بني سعد',
      content:
          'أرضعته حليمة السعدية رضي الله عنها، ونشأ في بادية بني سعد مدة من طفولته. وقد وردت أخبار صحيحة ومشهورة في بركة وجوده ﷺ في بيت حليمة، ثم عاد إلى أمه آمنة رضي الله عنها بعد انتهاء مدة رضاعته.',
      icon: Icons.family_restroom,
    ),
    const _BiographySection(
      title: 'وفاة أمه وكفالة جده',
      content:
          'توفيت أمه آمنة بنت وهب رضي الله عنها وهو في طفولته، فكفله جده عبد المطلب، وكان يحبه ويعتني به. فلما توفي عبد المطلب انتقلت كفالته إلى عمه أبي طالب، فكان قريبًا منه، يحميه ويرعاه.',
      icon: Icons.elderly,
    ),
    const _BiographySection(
      title: 'كفالة أبي طالب',
      content:
          'نشأ رسول الله ﷺ في رعاية عمه أبي طالب، وعاش في مكة بين قومه. وكان معروفًا منذ صغره بحسن الخلق والصدق والأمانة والعفة، ولم يُعرف عنه ما يقدح في مروءته أو أمانته.',
      icon: Icons.home_work_outlined,
    ),
    const _BiographySection(
      title: 'نشأته وشبابه ﷺ',
      content:
          'نشأ النبي ﷺ على مكارم الأخلاق، ورعى الغنم في صغره، ثم اشتغل بالتجارة. وعُرف بين قومه بالصدق والأمانة، حتى أصبح موضع ثقتهم. وكان بعيدًا عن عادات الجاهلية التي تخالف الفطرة السليمة ومكارم الأخلاق.',
      icon: Icons.work_outline,
    ),
    const _BiographySection(
      title: 'زواجه من خديجة رضي الله عنها',
      content:
          'تزوج رسول الله ﷺ خديجة بنت خويلد رضي الله عنها قبل البعثة، وكانت من خيرة نساء قريش وأكرمهن. وعاش معها حياة زوجية مستقرة، وكانت أول من آمن به وصدقه حين جاءه الوحي، ووقفت إلى جانبه في بداية دعوته.',
      icon: Icons.favorite_outline,
    ),
    const _BiographySection(
      title: 'بناء الكعبة والتحكيم في الحجر الأسود',
      content:
          'قبل بعثته ﷺ أعادت قريش بناء الكعبة، فلما اختلفت القبائل فيمن يضع الحجر الأسود في موضعه، رضوا بتحكيم محمد ﷺ، لما عرفوه به من الصدق والأمانة. فوضع الحجر في ثوب، وطلب من رؤساء القبائل أن يرفعوه جميعًا، ثم وضعه بيده الشريفة في مكانه.',
      icon: Icons.account_balance,
    ),
    const _BiographySection(
      title: 'الخلوة في غار حراء',
      content:
          'كان رسول الله ﷺ قبل نزول الوحي يحب الخلوة والتعبد، وكان يخلو في غار حراء، ويتزود لذلك ثم يعود إلى أهله. واستمر على ذلك حتى جاءه الوحي وهو في الغار، فبدأت مرحلة النبوة والرسالة.',
      icon: Icons.landscape,
    ),
    const _BiographySection(
      title: 'نزول الوحي وبداية النبوة',
      content:
          'لما جاءه الوحي في غار حراء جاءه جبريل عليه السلام وقال له: «اقرأ». ونزلت عليه أوائل سورة العلق. فرجع رسول الله ﷺ إلى خديجة رضي الله عنها وهو يرجف من شدة ما رأى، فطمأنته وثبتته، ثم ذهبت به إلى ورقة بن نوفل، فشهد له بما عرف من أمر الوحي.',
      icon: Icons.auto_stories,
    ),
  ];

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark
        ? AppConstants.textLight
        : AppConstants.textDark;
    final Color cardColor = isDark
        ? AppConstants.darkSurface
        : AppConstants.lightSurface;

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
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                _responsiveHorizontalPadding(context),
                12,
                _responsiveHorizontalPadding(context),
                90,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: Column(
                    children: [
                      const ShineEffect(child: _BiographyHeroCard()),
                      const SizedBox(height: 12),
                      _buildIntroCard(isDark),
                      const SizedBox(height: 12),
                      ..._sections.map(
                        (section) => _buildSectionCard(
                          section: section,
                          isDark: isDark,
                          textColor: textColor,
                          cardColor: cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _responsiveHorizontalPadding(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 40;
    if (width >= 700) return 28;
    return 14;
  }

  Widget _buildIntroCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.primaryGold.withValues(alpha: 0.25),
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
        'رحلة موجزة في سيرة خير خلق الله محمد ﷺ، من مولده ونشأته، إلى بعثته ودعوته، ثم هجرته وجهاده وبناء المجتمع المسلم، حتى وفاته ﷺ.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppConstants.secondaryFont,
          fontSize: 13,
          height: 1.7,
          color: isDark ? const Color(0xFFF3E7D1) : AppConstants.brownDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required _BiographySection section,
    required bool isDark,
    required Color textColor,
    required Color cardColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? AppConstants.brownGradient
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFFFFDF8), Color(0xFFF6ECD7)],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.primaryGold.withValues(alpha: 0.28),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppConstants.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(section.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.title,
                  softWrap: true,
                  style: const TextStyle(
                    fontFamily: AppConstants.arabicFont,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            section.content,
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
              fontFamily: AppConstants.secondaryFont,
              fontSize: _fontSize,
              height: 1.85,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF4E5C9) : textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BiographyHeroCard extends StatelessWidget {
  const _BiographyHeroCard();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
                  'السيرة النبوية الشريفة',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 21,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFE8D8BD) : const Color(0xFF3E2723),
                  ),
                ),
                Text(
                  'قبسات نورانية من حياة سيد الخلق والمرسلين ﷺ',
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
}

class _BiographySection {
  final String title;
  final String content;
  final IconData icon;

  const _BiographySection({
    required this.title,
    required this.content,
    required this.icon,
  });
}
