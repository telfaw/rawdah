import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawdah/screen/about_app_screen.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:rawdah/screen/sahaba_swipe_screen.dart';

import 'package:rawdah/screen/tasbih_screen.dart';

import 'ahadith_screen.dart';
import 'developer_screen.dart';
import 'ghazawat_tree_screen.dart';


class SahabaGallery extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SahabaGallery({super.key, required this.toggleTheme});

  @override
  State<SahabaGallery> createState() => _SahabaGalleryState();
}

class _SahabaGalleryState extends State<SahabaGallery> {
  final PageController _mainPageController = PageController();
  double _currentPageValue = 0.0;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false; // للتأكد من توفر الميزة

  final List<Map<String, dynamic>> sahabaList = [
    {"name": "أبو بكر الصديق", "id": "1"},
    {"name": "عمر بن الخطاب", "id": "2"},
    {"name": "عثمان بن عفان", "id": "3"},
    {"name": "علي بن أبي طالب", "id": "4"},
    {"name": "طلحة بن عبيد الله", "id": "5"},
    {"name": "سعيد بن زيد", "id": "6"},
    {"name": "الزبير بن العوام", "id": "7"},
    {"name": "أبو عبيدة الجراح", "id": "8"},
    {"name": "عبد الرحمن بن عوف", "id": "9"},
    {"name": "سعد بن أبي وقاص", "id": "10"},
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _mainPageController.addListener(() {
      if (mounted) setState(() => _currentPageValue = _mainPageController.page ?? 0.0);
    });
  }

  // دالة الاستماع مع حماية من الأخطاء
  void _listen() async {
    if (!_isListening) {
      try {
        _speechEnabled = await _speech.initialize(
          onError: (val) => debugPrint('Error Speech: $val'),
          onStatus: (val) => debugPrint('Status Speech: $val'),
        );

        if (_speechEnabled) {
          setState(() => _isListening = true);
          _speech.listen(
            localeId: 'ar_SA',
            onResult: (val) {
              if (val.finalResult) _processVoiceSearch(val.recognizedWords);
            },
          );
        } else {
          _showNoMicMessage();
        }
      } catch (e) {
        debugPrint("Speech recognition not available: $e");
        _showNoMicMessage();
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _showNoMicMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("عذراً، ميزة البحث الصوتي غير مدعومة على هذا الجهاز",
            textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Cairo')),
      ),
    );
  }

  void _processVoiceSearch(String text) {
    for (var sahabi in sahabaList) {
      if (text.contains(sahabi['name'].split(' ')[0])) {
        _navigateToSahabi(sahabi);
        break;
      }
    }
    setState(() => _isListening = false);
  }

  void _navigateToSahabi(Map<String, dynamic> item) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SahabaSwipeScreen(
        initialIndex: int.parse(item['id']),
        names: const ["بشارة نبوية", "أبو بكر الصديق", "عمر بن الخطاب", "عثمان بن عفان", "علي بن أبي طالب", "طلحة بن عبيد الله", "سعيد بن زيد", "الزبير بن العوام", "أبو عبيدة الجراح", "عبد الرحمن بن عوف", "سعد بن أبي وقاص"],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    int activePageIndex = _currentPageValue.round();
    List<String> titles = ["العشرة المبشرون", "احاديث و فضائل الروضة", "المسبحة الذكية", "شجرة الغزوات"];

    Color scaffoldBg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFCF9F2);
    Color appBarColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFF5D4037);
    Color textColor = isDark ? const Color(0xFFE6D5B8) : Colors.white;

    return Directionality(
      textDirection: TextDirection.rtl, // دعم العربية لكامل التطبيق
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: scaffoldBg,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 4,
            centerTitle: true,
            title: Text(titles[activePageIndex.clamp(0, 3)],
                style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
            actions: [
              IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : textColor),
                  onPressed: _listen
              ),
              IconButton(
                  icon: Icon(Icons.brightness_6, color: textColor),
                  onPressed: widget.toggleTheme
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF5D4037)),
                  child: Center(child: Text("تطبيق الروضة", style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Amiri'))),
                ),
                ListTile(
                  title: Text("عن التطبيق"),
                  leading: Icon(Icons.info),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutAppScreen())),
                ),
                ListTile(
                  title: Text("عن المبرمج"),
                  leading: Icon(Icons.code),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DeveloperScreen())),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              PageView(
                controller: _mainPageController,
                children: [
                  _buildSahabaGrid(isDark),
                  const AhadithScreen(),
                  const TasbihScreen(),
                  const GhazawatTreeScreen(),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildFloatingIndicator(activePageIndex, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingIndicator(int activeIndex, bool isDark) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF262626) : const Color(0xFF5D4037),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: activeIndex == index ? 25 : 8,
            height: 8,
            decoration: BoxDecoration(
                color: activeIndex == index ? const Color(0xFFD4AF37) : Colors.white24,
                borderRadius: BorderRadius.circular(5)
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildSahabaGrid(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.85
      ),
      itemCount: sahabaList.length,
      itemBuilder: (context, index) => _buildFancyCard(sahabaList[index], isDark),
    );
  }

  Widget _buildFancyCard(Map<String, dynamic> item, bool isDark) {
    Color cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color nameTagBg = isDark ? const Color(0xFF2D1B10) : const Color(0xFF5D4037);

    return InkWell(
      onTap: () => _navigateToSahabi(item),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Hero(
                  tag: 'image${item['id']}',
                  child: Image.asset("assets/images/${item['id']}.jpg", fit: BoxFit.cover, width: double.infinity),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: nameTagBg,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: Text(
                item['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE6D5B8)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}