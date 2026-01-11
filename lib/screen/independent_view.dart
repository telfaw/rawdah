import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class IndependentView extends StatelessWidget {
  final String imageName;
  final String title;

  const IndependentView({super.key, required this.imageName, required this.title});

  // دالة المشاركة الخاصة بالصفحات الثابتة
  Future<void> _shareImage() async {
    try {
      final byteData = await rootBundle.load('assets/images/$imageName.jpg');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$imageName.jpg');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: '$title \nمن تطبيق الروضة الشريفة',
      );
    } catch (e) {
      debugPrint("خطأ في المشاركة: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A130F), // خلفية داكنة لإبراز المحتوى
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Amiri', color: Color(0xFFE6D5B8), fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFE6D5B8)), // أيقونة إغلاق
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Color(0xFFE6D5B8)),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: 'image$imageName', // لدعم تأثير الانتقال
            child: Image.asset(
              "assets/images/$imageName.jpg",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}