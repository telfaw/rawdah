import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/painters.dart';

class GhazawatTreeScreen extends StatefulWidget {
  const GhazawatTreeScreen({super.key});

  @override
  State<GhazawatTreeScreen> createState() => _GhazawatTreeScreenState();
}

class _GhazawatTreeScreenState extends State<GhazawatTreeScreen> {
  final ScrollController _scrollController = ScrollController();

  static int get _ghazawatTitleIndex => 1 + _battleStories.length;
  static int get _sarayaTitleIndex =>
      _ghazawatTitleIndex + 1 + AppConstants.ghazawatData.length;

  late final List<GlobalKey> _sectionKeys = List.generate(
    _sarayaTitleIndex + 1 + AppConstants.sarayaData.length,
    (_) => GlobalKey(),
  );

  static const List<_BattleStory> _battleStories = [
    _BattleStory(
      title: 'غزوة بدر الكبرى',
      content:
          'وقعت غزوة بدر في السنة الثانية للهجرة، وكانت أول معركة كبرى بين المسلمين وقريش. خرج المسلمون في الأصل لاعتراض قافلة لقريش، ثم تطور الأمر إلى مواجهة عسكرية. وأيد الله المسلمين بنصره، وكانت بدر يومًا عظيمًا في تاريخ الإسلام، وأظهرت ثبات المؤمنين وتوكلهم على الله.',
      icon: Icons.military_tech,
    ),
    _BattleStory(
      title: 'غزوة أحد',
      content:
          'وقعت غزوة أحد في السنة الثالثة للهجرة، وجاءت قريش تريد الثأر لهزيمتها في بدر. بدأ المسلمون متفوقين، ثم تغيرت نتيجة المعركة بسبب مخالفة بعض الرماة أمر النبي ﷺ. واستشهد عدد من الصحابة، ومن أشهرهم حمزة بن عبد المطلب رضي الله عنه. وكانت أحد درسًا عظيمًا في الطاعة والثبات والصبر.',
      icon: Icons.shield_outlined,
    ),
    _BattleStory(
      title: 'غزوة بني النضير',
      content:
          'وقعت أحداث بني النضير بعد غزوة أحد، وكان من أسبابها نقض العهد ومحاولة الغدر بالنبي ﷺ. فحاصرهم المسلمون حتى انتهى الأمر بخروجهم من المدينة. وكانت هذه الأحداث جزءًا من مرحلة تثبيت المجتمع الإسلامي وحماية المدينة من الأخطار الداخلية والخارجية.',
      icon: Icons.security,
    ),
    _BattleStory(
      title: 'غزوة الخندق',
      content:
          'في السنة الخامسة للهجرة اجتمعت قبائل عديدة لمحاربة المسلمين، فأشار سلمان الفارسي رضي الله عنه بحفر الخندق حول المدينة، فأخذ النبي ﷺ بالمشورة وشارك أصحابه في الحفر. وحاصر الأحزاب المدينة، ثم صرفهم الله عنها بالريح والخوف دون أن يحققوا هدفهم. وكانت الغزوة درسًا في التخطيط والصبر والتوكل على الله.',
      icon: Icons.landscape,
    ),
    _BattleStory(
      title: 'بني قريظة',
      content:
          'جاءت أحداث بني قريظة عقب غزوة الخندق، بعد أن وقع نقض للعهد في ظرف بالغ الخطورة على المسلمين. وحاصرهم المسلمون، ثم نزلوا على حكم سعد بن معاذ رضي الله عنه، فحكم فيهم بحكم وافق ما كان في شريعتهم في شأن الخيانة في الحرب، ونفذ الحكم وفق ما ورد في كتب السيرة والحديث.',
      icon: Icons.gavel,
    ),
    _BattleStory(
      title: 'صلح الحديبية وبيعة الرضوان',
      content:
          'خرج رسول الله ﷺ وأصحابه في السنة السادسة للهجرة يريدون العمرة، فصدتهم قريش عن دخول مكة. وجرى صلح الحديبية، وكان في ظاهره بعض الشروط التي شقّت على المسلمين، لكنه كان فتحًا عظيمًا للدعوة؛ فقد أمن الناس مدة من الحرب، وانتشر الإسلام بين القبائل. وفي الحديبية وقعت بيعة الرضوان تحت الشجرة.',
      icon: Icons.handshake_outlined,
    ),
    _BattleStory(
      title: 'غزوة خيبر',
      content:
          'وقعت غزوة خيبر في السنة السابعة للهجرة، وانتهت بفتح حصونها ودخولها تحت حكم المسلمين. وكانت خيبر محطة مهمة في تثبيت الدولة الإسلامية وتأمين المدينة، ثم عاد النبي ﷺ إلى المدينة بعد ذلك، واستمرت الدعوة في الانتشار.',
      icon: Icons.castle,
    ),
    _BattleStory(
      title: 'عمرة القضاء',
      content:
          'في السنة السابعة للهجرة خرج رسول الله ﷺ وأصحابه إلى مكة لأداء العمرة وفاءً لما تم الاتفاق عليه في صلح الحديبية. فدخل المسلمون مكة وأدوا العمرة، ثم عادوا إلى المدينة، وكانت هذه العمرة من الأحداث المهمة التي سبقت فتح مكة.',
      icon: Icons.hiking,
    ),
    _BattleStory(
      title: 'غزوة مؤتة',
      content:
          'وقعت غزوة مؤتة في السنة الثامنة للهجرة، وأرسل النبي ﷺ جيشًا إلى الشام، وكان من قادته زيد بن حارثة وجعفر بن أبي طالب وعبد الله بن رواحة رضي الله عنهم، واستشهد القادة الثلاثة، ثم أخذ الراية خالد بن الوليد رضي الله عنه، وقاد الجيش حتى عاد به إلى المدينة.',
      icon: Icons.flag,
    ),
    _BattleStory(
      title: 'فتح مكة',
      content:
          'في السنة الثامعة للهجرة نقضت قريش العهد عندما أعانت حلفاءها على خزاعة، وكانت خزاعة في عهد رسول الله ﷺ. فخرج النبي ﷺ إلى مكة بجيش كبير، ودخلها في رمضان، وكان فتح مكة من أعظم أحداث السيرة. ودخل ﷺ مكة متواضعًا لله، وأزال الأصنام من حول الكعبة، وعفا عن عامة أهلها، فكان الفتح مثالًا عظيمًا في الرحمة والعفو عند المقدرة.',
      icon: Icons.location_city,
    ),
    _BattleStory(
      title: 'غزوة حنين',
      content:
          'بعد فتح مكة، اجتمعت هوازن وثقيف لمحاربة المسلمين، فخرج إليهم النبي ﷺ في غزوة حنين. ووقع في بداية المعركة اضطراب لبعض المسلمين بسبب كثرة عددهم، ثم ثبت رسول الله ﷺ وثبت معه عدد من أصحابه، وعاد المسلمون إلى القتال حتى نصرهم الله تعالى. وكانت حنين درسًا في أن النصر ليس بكثرة العدد وإنما بتوفيق الله.',
      icon: Icons.security,
    ),
    _BattleStory(
      title: 'غزوة الطائف',
      content:
          'بعد حنين توجه رسول الله ﷺ إلى الطائف، حيث تحصن أهلها في حصونهم. واستمر الحصار مدة ثم عاد المسلمون دون فتحها، ثم أسلم أهل الطائف بعد ذلك، وأقبلت قبائل كثيرة على الإسلام.',
      icon: Icons.fort,
    ),
    _BattleStory(
      title: 'غزوة تبوك',
      content:
          'كانت غزوة تبوك في السنة التاسعة للهجرة، وخرج المسلمون في ظروف شديدة من الحر وقلة الزاد وبعد المسافة. ولم يقع قتال مباشر مع الروم، لكن الغزوة أظهرت قوة الدولة الإسلامية، وكشفت صدق المؤمنين، ثم عاد النبي ﷺ إلى المدينة.',
      icon: Icons.directions,
    ),
  ];

  bool _showHint = false;
  double _currentScale = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() {
    try {
      _triggerHint();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      ErrorHandler.logError(
        'Screen initialization error: $e',
        StackTrace.current,
      );
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _triggerHint() {
    if (!mounted) return;

    setState(() => _showHint = true);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showHint = false);
      }
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() => _currentScale = details.scale);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark
        ? const Color(0xFF1A130F)
        : const Color(0xFFF7F3E9);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: scaffoldBg,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: scaffoldBg,
          body: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppConstants.darkBackgroundGradient
                  : AppConstants.lightBackgroundGradient,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      _buildHeader(isDark),
                      const SizedBox(height: 16),
                      _buildInteractiveImage(isDark),
                      const SizedBox(height: 20),
                      Container(
                        key: _sectionKeys[0],
                        child: _buildSectionTitle(
                          'مراحل الجهاد في السيرة',
                          isDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._battleStories.asMap().entries.map((entry) {
                        final index = entry.key;
                        final story = entry.value;
                        return Container(
                          key: _sectionKeys[1 + index],
                          child: _buildNarrativeCard(story, isDark),
                        );
                      }),
                      const SizedBox(height: 20),
                      Container(
                        key: _sectionKeys[_ghazawatTitleIndex],
                        child: _buildSectionTitle('الغزوات الكبرى', isDark),
                      ),
                      const SizedBox(height: 12),
                      ...AppConstants.ghazawatData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Container(
                          key: _sectionKeys[_ghazawatTitleIndex + 1 + index],
                          child: _buildInfoCard(item, isDark),
                        );
                      }),
                      const SizedBox(height: 20),
                      Container(
                        key: _sectionKeys[_sarayaTitleIndex],
                        child: _buildSectionTitle('السرايا والبعوث', isDark),
                      ),
                      const SizedBox(height: 12),
                      ...AppConstants.sarayaData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Container(
                          key: _sectionKeys[_sarayaTitleIndex + 1 + index],
                          child: _buildInfoCard(item, isDark, isSaraya: true),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF1E1713),
                  Color(0xFF382B21),
                  Color(0xFF1A120F),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF5F4337),
                  Color(0xFF4A3229),
                  Color(0xFF2F201B),
                ],
              ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
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
                  gradient: AppConstants.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const ShineEffect(
                  child: Icon(Icons.flag_rounded, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'غزوات وسرايا النبي ﷺ',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE6D5B8)
                        : const Color(0xFFE6D5B8),
                    // ? const Color(0xFFE6D5B8)
                    //                     : const Color(0xFF3E2723),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'معلومات موجزة عن أهم الغزوات والبعوث العسكرية في صدر الإسلام، مع تاريخها، قائدها، هدفها، والفائدة التي تحققت منها.',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              height: 1.8,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF1E4D1) : const Color(0xFFffff1B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF5B3B2F), Color(0xFF2B1B16)],
              )
            : const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF6C4C3C), Color(0xFF3A2A23)],
              ),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? const Color(0xFFF8F0E0) : const Color(0xFFF8F0E0),
        ),
      ),
    );
  }

  Widget _buildInteractiveImage(bool isDark) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: IslamicPatternPainter(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
            ),
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD4AF37),
              strokeWidth: 2,
            ),
          )
        else
          GestureDetector(
            onTap: _triggerHint,
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 6.0,
                boundaryMargin: const EdgeInsets.all(20),
                onInteractionUpdate: _onScaleUpdate,
                child: Hero(
                  tag: 'ghazawat_image',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/c.jpg',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          ErrorHandler.logError(
                            'Image load error: Ghazawat tree',
                            stackTrace ?? StackTrace.current,
                          );
                          return Container(
                            width: 300,
                            height: 400,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2D1B10)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(
                                  0xFFD4AF37,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black26,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'صورة شجرة الغزوات غير متوفرة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: 12,
          right: 12,
          child: FloatingActionButton(
            mini: true,
            onPressed: _showInfoDialog,
            backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.8),
            child: const Icon(Icons.info_outline, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 18,
          left: 20,
          right: 20,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _showHint ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2D1B10)
                    : const Color(0xFF5D4037),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.pinch_rounded,
                    color: Color(0xFFD4AF37),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'استخدم إصبعين للتكبير (${(_currentScale * 100).toStringAsFixed(0)}%)',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFFE6D5B8),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!_isLoading && _currentScale != 1.0)
          Positioned(
            top: 80,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: (isDark ? Colors.black : Colors.white).withValues(
                  alpha: 0.8,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.zoom_in, color: Color(0xFFD4AF37), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentScale - 0.5) / 5.5,
                      backgroundColor: const Color(
                        0xFFD4AF37,
                      ).withValues(alpha: 0.2),
                      color: const Color(0xFFD4AF37),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(_currentScale * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNarrativeCard(_BattleStory story, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF2B1D16), Color(0xFF1F170F)],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFFFFDF7), Color(0xFFF7E7C6)],
              ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppConstants.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(story.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFF7EED7)
                        : const Color(0xFF2E201B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  story.content,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    height: 1.9,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFECDDB7)
                        : const Color(0xFF3D2A24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    Map<String, String> item,
    bool isDark, {
    bool isSaraya = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A1B13), Color(0xFF1B130F)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF9F0), Color(0xFFF7E7C3)],
              ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.10 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'] ?? '',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFF8F0E2) : const Color(0xFF2E201B),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('التاريخ', item['date'] ?? '', isDark),
          _buildInfoRow('القائد', item['leader'] ?? '', isDark),
          _buildInfoRow('الهدف', item['purpose'] ?? '', isDark),
          _buildInfoRow('الفائدة', item['benefit'] ?? '', isDark),
          if (isSaraya)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'السرية: بعثة صغيرة تُرسل لغرض محدد من الاستطلاع أو الهجوم أو الحماية.',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFF3E6C8)
                      : const Color(0xFF3E2B25),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: 'Cairo',
                height: 1.8,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF2F201B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFD4AF37)),
              SizedBox(width: 10),
              Text(
                'عن شجرة الغزوات',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تُظهر هذه الصفحة أبرز الغزوات والسرايا في عهد النبي ﷺ، مع توضيح وظيفتها العسكرية والفائدة العلمية والشرعية التي حققتها للمسلمين.',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
                SizedBox(height: 12),
                _InfoItem(
                  icon: Icons.touch_app,
                  text: 'استخدم إصبعين للتكبير والتصغير.',
                ),
                _InfoItem(
                  icon: Icons.pan_tool,
                  text: 'اسحب الصورة للتنقل في الحقول والرسوم.',
                ),
                _InfoItem(
                  icon: Icons.history_edu,
                  text: 'المعلومات هنا موجزة لكنها تاريخية ومفيدة.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }
}

class _BattleStory {
  final String title;
  final String content;
  final IconData icon;

  const _BattleStory({
    required this.title,
    required this.content,
    required this.icon,
  });
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
