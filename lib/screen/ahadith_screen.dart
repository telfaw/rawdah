import 'package:flutter/material.dart';
import 'package:rawdah/error_handler.dart';

// كلاس الرسم يظل كما هو
class IslamicPatternPainter extends CustomPainter {
  final Color color;
  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double step = 60.0;
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        Path path = Path();
        path.moveTo(i + step / 2, j);
        path.lineTo(i + step * 0.7, j + step * 0.3);
        path.lineTo(i + step, j + step / 2);
        path.lineTo(i + step * 0.7, j + step * 0.7);
        path.lineTo(i + step / 2, j + step);
        path.lineTo(i + step * 0.3, j + step * 0.7);
        path.lineTo(i, j + step / 2);
        path.lineTo(i + step * 0.3, j + step * 0.3);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AhadithScreen extends StatefulWidget { // تحويل إلى StatefulWidget
  const AhadithScreen({super.key});

  @override
  State<AhadithScreen> createState() => _AhadithScreenState();
}

class _AhadithScreenState extends State<AhadithScreen> {
  // القائمة الأصلية
  final List<Map<String, String>> allAhadith = const [
    {
      "title": "فضل البدء ببسم الله",
      "text": "«كُلُّ أَمْرٍ ذِي بَالٍ لا يُبْدَأُ فِيهِ بِبِسْمِ اللَّهِ فَهُوَ أَقْطَعُ»",
      "ref": "رواه أحمد",
      "explanation": "يُرشدنا الحديث إلى أهمية استهلال الأعمال الهامة بذكر الله تعالى، فكلمة 'أقطع' تعني ناقص البركة.",
    },
    {
      "title": "كفالة اليتيم",
      "text": "«أَنَا وَكَافِلُ الْيَتِيمِ فِي الْجَنَّةِ كَهَاتَيْنِ» وَأَشَارَ بِالسَّبَّابَةِ وَالْوُسْطَى.",
      "ref": "رواه البخاري",
      "explanation": "بيان للمنزلة الرفيعة والقرب من النبي ﷺ في الجنة لمن يقوم برعاية اليتيم.",
    },
    {
      "title": "الأعمال بالنيات (الأربعين النووية)",
      "text": "«إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى»",
      "ref": "متفق عليه",
      "explanation": "هذا الحديث أصل عظيم، معناه أن صلاح العمل أو فساده تابع للنية التي يحملها المؤمن في قلبه.",
    },
    {
      "title": "من حسن إسلام المرء",
      "text": "«مِنْ حُسْنِ إِسْلامِ الْمَرْءِ تَرْكُهُ مَا لا يَعْنِيهِ»",
      "ref": "رواه الترمذي",
      "explanation": "دعوة للاشتغال بما يفيد في الدين والدنيا والابتعاد عن الفضول والتدخل في شؤون الآخرين.",
    },
    {
      "title": "النهي عن الغضب",
      "text": "«لا تَغْضَبْ» (كررها مراراً)",
      "ref": "رواه البخاري",
      "explanation": "وصية نبوية جامعة، فالغضب مفتاح كل شر، وملك النفس عند الغضب من أعظم القوة.",
    },
    {
      "title": "الروضة الشريفة",
      "text": "«مَا بَيْنَ بَيْتِي وَمِنْبَرِي رَوْضَةٌ مِنْ رِيَاضِ الجَنَّةِ»",
      "ref": "متفق عليه",
      "explanation": "إثبات لفضل هذا المكان المبارك في المسجد النبوي الشريف.",
    },
    {
      "title": "الإحسان إلى الجار",
      "text": "«مَا زَالَ جِبْرِيلُ يُوصِينِي بِالْجَارِ حَتَّى ظَنَنْتُ أَنَّهُ سَيُورِّثُهُ»",
      "ref": "رواه البخاري ومسلم",
      "explanation": "النهي عن أذى الجار والحث على إكرامه والإحسان إليه.",
    },
    {
      "title": "فضل الصدقة",
      "text": "«صَدَقَةُ السِّرِّ تُطْفِئُ غَضَبَ الرَّبِّ»",
      "ref": "رواه الطبراني",
      "explanation": "الصدقة سبب لمغفرة الذنوب ورضا الرب سبحانه وتعالى.",
    },
  ];

  // قائمة النتائج المفلترة
  List<Map<String, String>> filteredAhadith = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredAhadith = allAhadith; // في البداية نعرض كل الأحاديث
  }

  // دالة البحث الذكي
  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allAhadith;
    } else {
      results = allAhadith.where((hadith) {
        final title = hadith["title"]!.toLowerCase();
        final text = hadith["text"]!.toLowerCase();
        final ref = hadith["ref"]!.toLowerCase();
        final searchLower = enteredKeyword.toLowerCase();

        // البحث في العنوان أو النص أو المرجع
        return title.contains(searchLower) ||
            text.contains(searchLower) ||
            ref.contains(searchLower);
      }).toList();
    }

    setState(() {
      filteredAhadith = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showHadithDetails(BuildContext context, Map<String, String> hadith, bool isDark) {
    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hadith['title']!,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
                  ),
                  const Divider(height: 30, color: Color(0xFFD4AF37)),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                    ),
                    child: Text(
                      hadith['text']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Amiri', fontSize: 18, height: 1.8, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(hadith['explanation']!, textAlign: TextAlign.justify, style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, height: 1.6)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                    child: const Text("إغلاق", style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      ErrorHandler.logError("Error: $e", StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color patternColor = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: IslamicPatternPainter(color: patternColor))),
          SafeArea(
            child: Column(
              children: [
                // شريط البحث المطور
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D1B10) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _runFilter(value), // استدعاء الفلترة عند كل حرف
                    decoration: InputDecoration(
                      hintText: 'ابحث عن حديث أو عنوان أو مصدر...',
                      hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _runFilter('');
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),

                // حالة عدم وجود نتائج
                if (filteredAhadith.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 10),
                          const Text("عذراً، لا توجد نتائج للبحث", style: TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                      itemCount: filteredAhadith.length,
                      itemBuilder: (context, index) {
                        return _buildHadithCard(context, filteredAhadith[index], isDark, index);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت الكارت (نفس الكود السابق مع استخدام القائمة المفلترة)
  Widget _buildHadithCard(BuildContext context, Map<String, String> hadith, bool isDark, int index) {
    return GestureDetector(
      onTap: () => _showHadithDetails(context, hadith, isDark),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D1B10) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFFD4AF37).withOpacity(0.1),
                    child: Text('${index + 1}', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(hadith['title']!, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 12),
              Text(hadith['text']!, style: TextStyle(fontFamily: 'Amiri', fontSize: 17, color: isDark ? const Color(0xFFE6D5B8) : const Color(0xFF3E2723), fontWeight: FontWeight.bold)),
              const Divider(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("المصدر: ${hadith['ref']!}", style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey)),
                  const Icon(Icons.touch_app, size: 16, color: Color(0xFFD4AF37)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}