import 'package:flutter/material.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/utils/effects.dart';

class ProphetBiographyScreen extends StatefulWidget {
  const ProphetBiographyScreen({super.key});

  @override
  State<ProphetBiographyScreen> createState() => _ProphetBiographyScreenState();
}

class _ProphetBiographyScreenState extends State<ProphetBiographyScreen> {
  final ScrollController _scrollController = ScrollController();

  double _fontSize = 14.0;

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

    const _BiographySection(
      title: 'الدعوة السرية',
      content:
          'بدأ رسول الله ﷺ دعوته إلى توحيد الله تعالى وعبادته وحده، فآمن به عدد من السابقين الأولين، ومنهم خديجة رضي الله عنها، وأبو بكر الصديق رضي الله عنه، وعلي بن أبي طالب رضي الله عنه، وزيد بن حارثة رضي الله عنه. ثم أخذ عدد المؤمنين يزداد شيئًا فشيئًا.',
      icon: Icons.light_mode_outlined,
    ),

    const _BiographySection(
      title: 'الجهر بالدعوة وأذى قريش',
      content:
          'لما جهر رسول الله ﷺ بالدعوة إلى توحيد الله تعالى، واجهته قريش بالإنكار والأذى ومحاولات الصد عن دعوته. وثبت ﷺ على الحق، وصبر على ما لقيه هو وأصحابه، واستمر في تبليغ رسالة الله بالحكمة والصبر.',
      icon: Icons.record_voice_over_outlined,
    ),

    const _BiographySection(
      title: 'الهجرة إلى الحبشة',
      content:
          'لما اشتد أذى المشركين على بعض المسلمين، أذن لهم رسول الله ﷺ بالهجرة إلى الحبشة، وكان فيها ملك عُرف بالعدل. فخرج عدد من الصحابة فرارًا بدينهم، ثم عاد بعضهم بعد ذلك، وهاجر آخرون مرة ثانية.',
      icon: Icons.directions_boat_outlined,
    ),

    const _BiographySection(
      title: 'حصار بني هاشم في الشِّعب',
      content:
          'فرضت قريش حصارًا على بني هاشم ومن انضم إليهم من المسلمين، فاشتد عليهم البلاء والجوع والمشقة. واستمر الحصار مدة من الزمن، ثم انتهى، وعاد المسلمون إلى مواجهة مرحلة جديدة من الدعوة والصبر.',
      icon: Icons.lock_outline,
    ),

    const _BiographySection(
      title: 'عام الحزن',
      content:
          'فقد رسول الله ﷺ في مكة عمه أبا طالب، ثم توفيت زوجته خديجة رضي الله عنها، فاشتد عليه الحزن؛ لما كان لهما من مكانة ونصرة ومؤازرة. وكانت تلك المرحلة من أشد مراحل الدعوة في مكة.',
      icon: Icons.sentiment_dissatisfied_outlined,
    ),

    const _BiographySection(
      title: 'الدعوة خارج مكة والطائف',
      content:
          'خرج رسول الله ﷺ يدعو إلى الله تعالى خارج مكة، وقصد الطائف يلتمس النصرة ويبلغ الرسالة. فلم يجد منهم الاستجابة التي كان يرجوها، بل لقي أذى شديدًا، ومع ذلك لم يدعُ عليهم، بل ظل حريصًا على هداية الناس ورحمتهم.',
      icon: Icons.directions_walk,
    ),

    const _BiographySection(
      title: 'الإسراء والمعراج',
      content:
          'أكرم الله تعالى نبيه ﷺ برحلة الإسراء من المسجد الحرام إلى المسجد الأقصى، ثم عُرج به إلى السماوات العلا، وأراه الله من آياته الكبرى. وفي هذه الرحلة فُرضت الصلاة، ثم عاد ﷺ إلى مكة، فواصل دعوته وصبره.',
      icon: Icons.nightlight_round,
    ),

    const _BiographySection(
      title: 'بيعتا العقبة',
      content:
          'التقى رسول الله ﷺ جماعة من أهل يثرب، فآمنوا به وبايعوه، ثم جاء في العام التالي عدد أكبر منهم فبايعوه على الإسلام والنصرة. وكانت بيعتا العقبة من أهم المقدمات التي مهدت لهجرة المسلمين إلى المدينة.',
      icon: Icons.handshake_outlined,
    ),

    const _BiographySection(
      title: 'الهجرة إلى المدينة',
      content:
          'لما أذن الله تعالى لرسوله ﷺ بالهجرة، خرج من مكة مع أبي بكر الصديق رضي الله عنه. واختبآ في غار ثور مدة، ثم تابعا طريقهما حتى وصلا إلى المدينة، فكانت الهجرة بداية مرحلة جديدة في تاريخ الدعوة الإسلامية.',
      icon: Icons.route,
    ),

    const _BiographySection(
      title: 'الوصول إلى المدينة وبناء المسجد',
      content:
          'وصل رسول الله ﷺ إلى المدينة، واستقبله أهلها بفرح ومحبة. وكان من أول أعماله ﷺ تأسيس المسجد، فصار المسجد مركزًا للعبادة والتعليم وإدارة شؤون المجتمع المسلم.',
      icon: Icons.mosque_outlined,
    ),

    const _BiographySection(
      title: 'المؤاخاة بين المهاجرين والأنصار',
      content:
          'آخى رسول الله ﷺ بين المهاجرين والأنصار، فكان ذلك من أعظم صور التكافل والإيثار. وأسهمت هذه المؤاخاة في بناء مجتمع متماسك يقوم على الإيمان والتعاون والنصرة، لا على العصبية والنسب.',
      icon: Icons.people_outline,
    ),

    const _BiographySection(
      title: 'صلح الحديبية',
      content:
          'خرج رسول الله ﷺ وأصحابه يريدون العمرة، فصدتهم قريش عن دخول مكة، وانتهى الأمر إلى عقد صلح الحديبية. وكان الصلح في ظاهره شاقًا على بعض المسلمين، لكنه كان فتحًا عظيمًا؛ إذ أتاح فرصة لانتشار الدعوة وازدياد الداخلين في الإسلام.',
      icon: Icons.handshake,
    ),

    const _BiographySection(
      title: 'فتح مكة',
      content:
          'في السنة الثامنة للهجرة خرج رسول الله ﷺ إلى مكة بعد أن نقضت قريش وحلفاؤها العهد. ودخل المسلمون مكة، ودخلها رسول الله ﷺ متواضعًا لله تعالى، وطهّر البيت من الأصنام، وعفا عن كثير من أهل مكة، فكان الفتح تحولًا عظيمًا في تاريخ الإسلام.',
      icon: Icons.location_city,
    ),

    _BiographySection(
      title: 'حجة الوداع',
      content:
          'حج رسول الله ﷺ في آخر حياته، واجتمع معه عدد كبير من المسلمين. وعلّم الناس مناسك الحج، وخطب فيهم، وبيّن حرمة الدماء والأموال والأعراض، وأوصى بالتمسك بكتاب الله، وأكد أصول العدل والحقوق والرحمة.',
      icon: Icons.mosque,
    ),

    const _BiographySection(
      title: 'مرضه ﷺ ووفاته',
      content:
          'مرض رسول الله ﷺ في آخر حياته، واشتد عليه المرض، وكان في بيت عائشة رضي الله عنها. وتوفي ﷺ يوم الاثنين من شهر ربيع الأول في السنة الحادية عشرة للهجرة. وحزن الصحابة لفقده حزنًا شديدًا، وثبت أبو بكر الصديق رضي الله عنه، ثم دُفن رسول الله ﷺ في الموضع الذي توفي فيه.',
      icon: Icons.access_time_filled,
    ),

    const _BiographySection(
      title: 'أخلاقه وشمائله ﷺ',
      content:
          'كان رسول الله ﷺ أكمل الناس خلقًا وأعظمهم رحمة وأصدقهم حديثًا وأعظمهم أمانة. وكان متواضعًا، رحيمًا بالضعفاء، حسن المعاملة، كثير العفو، حريصًا على هداية الناس. وقد أثنى الله تعالى على خلقه فقال: ﴿وَإِنَّكَ لَعَلَىٰ خُلُقٍ عَظِيمٍ﴾.',
      icon: Icons.auto_awesome,
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textColor = isDark
        ? const Color(0xFFF3E7D1)
        : const Color(0xFF2F201B);

    final Color cardColor = isDark
        ? const Color(0xFF201812)
        : const Color(0xFFFFFDFC);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark
            ? AppConstants.darkBackground
            : AppConstants.lightBackground,
        appBar: AppBar(
          title: const ShineEffect(
            child: Text(
              'السيرة النبوية الشريفة',
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
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.text_increase),
              tooltip: 'تكبير الخط',
              onPressed: () {
                setState(() {
                  if (_fontSize < 24) {
                    _fontSize += 2;
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.text_decrease),
              tooltip: 'تصغير الخط',
              onPressed: () {
                setState(() {
                  if (_fontSize > 10) {
                    _fontSize -= 2;
                  }
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
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStatePropertyAll(
                AppConstants.primaryGold.withValues(alpha: 0.65),
              ),
              thickness: const WidgetStatePropertyAll(6),
              radius: const Radius.circular(10),
              minThumbLength: 48,
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  _responsiveHorizontalPadding(context),
                  20,
                  _responsiveHorizontalPadding(context),
                  100,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(
                      children: [
                        const ShineEffect(child: _BiographyHeroCard()),
                        const SizedBox(height: 20),
                        _buildIntroCard(isDark),
                        const SizedBox(height: 18),
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
      ),
    );
  }

  double _responsiveHorizontalPadding(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    if (width >= 1200) {
      return 40;
    }

    if (width >= 700) {
      return 28;
    }

    return 16;
  }

  Widget _buildIntroCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.035)
            : Colors.white.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppConstants.primaryGold.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        'رحلة موجزة في سيرة خير خلق الله محمد ﷺ، من مولده ونشأته، إلى بعثته ودعوته، ثم هجرته وجهاده وبناء المجتمع المسلم، حتى وفاته ﷺ.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppConstants.secondaryFont,
          fontSize: 14,
          height: 1.8,
          color: isDark ? const Color(0xFFF3E7D1) : AppConstants.brownDark,
          fontWeight: FontWeight.w600,
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF2C1E18), Color(0xFF1A120F)],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFFFFBF5), Color(0xFFF5E6C3)],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.primaryGold.withValues(alpha: 0.32),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGold.withValues(
              alpha: isDark ? 0.10 : 0.12,
            ),
            blurRadius: 14,
            offset: const Offset(0, 6),
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
                  borderRadius: BorderRadius.circular(10),
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
          const SizedBox(height: 12),
          Text(
            section.content,
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
              fontFamily: AppConstants.secondaryFont,
              fontSize: _fontSize,
              height: 1.9,
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
    final double width = MediaQuery.sizeOf(context).width;

    final double titleSize = width >= 700 ? 30 : 26;
    final double iconSize = width >= 700 ? 56 : 50;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width >= 700 ? 32 : 24,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppConstants.primaryGold, Color(0xFFB7892A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGold.withValues(alpha: 0.20),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.mosque, size: iconSize, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            'محمد صلى الله عليه وسلم',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontFamily: AppConstants.arabicFont,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'خاتم الأنبياء والمرسلين، ورحمة للعالمين',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontFamily: AppConstants.secondaryFont,
              fontSize: 14,
              height: 1.7,
              color: Colors.white,
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
