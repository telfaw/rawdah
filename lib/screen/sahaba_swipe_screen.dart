import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rawdah/constants.dart';
import 'package:rawdah/error_handler.dart';
import 'package:rawdah/utils/effects.dart';
import 'package:rawdah/utils/settings_helper.dart';
import 'package:share_plus/share_plus.dart';

class SahabaSwipeScreen extends StatefulWidget {
  final int initialIndex;
  final List<String> names;

  const SahabaSwipeScreen({
    super.key,
    required this.initialIndex,
    required this.names,
  });

  @override
  State<SahabaSwipeScreen> createState() => _SahabaSwipeScreenState();
}

class _SahabaSwipeScreenState extends State<SahabaSwipeScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isSharing = false;
  double _currentScale = 1.0;
  double _fontSize = 14.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex - 1;
    _pageController = PageController(initialPage: _currentIndex);
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

  Future<void> _shareSahabi(BuildContext context) async {
    if (_isSharing || !mounted) return;

    final currentContext = context;
    final RenderBox? shareBox = currentContext.findRenderObject() as RenderBox?;
    setState(() => _isSharing = true);

    try {
      int fileId = _currentIndex + 1;
      final byteData = await rootBundle.load('assets/images/$fileId.jpg');
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/sahabi_$fileId.jpg').create();
      await file.writeAsBytes(byteData.buffer.asUint8List());

      final RenderBox? box = shareBox;
      if (box == null) throw Exception('RenderBox not found');

      final Offset position = box.localToGlobal(Offset.zero);
      final Size size = box.size;

      await SharePlus.instance.share(
        ShareParams(
          text:
              '🌟 من تطبيق الروضة الشريفة:\n'
              '${widget.names[_currentIndex + 1]} رضي الله عنه\n'
              '#الروضة_الشريفة #الصحابة #الإسلام',
          files: [XFile(file.path)],
          sharePositionOrigin: position & size,
        ),
      );

      if (!mounted || !currentContext.mounted) return;
      ErrorHandler.showSuccess(currentContext, 'تم المشاركة بنجاح');
    } catch (e) {
      ErrorHandler.logError(
        'Share error: $e',
        e is Error ? (e.stackTrace ?? StackTrace.current) : StackTrace.current,
      );
      if (mounted && currentContext.mounted) {
        ErrorHandler.showError(currentContext, 'فشلت مشاركة الصورة');
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _showSahabiInfo() {
    if (!mounted) return;

    final currentSahabi = AppConstants.sahabaData[_currentIndex];

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppConstants.primaryGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentSahabi['name'],
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        currentSahabi['bio'],
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: _fontSize,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'رضي الله عنهم وأرضاهم، هم خير القرون.',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _shareSahabi(context),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A130F),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFE6D5B8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShineEffect(
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  key: ValueKey<int>(_currentIndex),
                  widget.names[_currentIndex + 1],
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE6D5B8),
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
              ),
              const Text(
                "رَضِيَ اللَّهُ عَنْهُ وَأَرْضَاهُ",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 14,
                  color: Color(0xFFE6D5B8),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFFE6D5B8)),
            onPressed: _showSahabiInfo,
          ),
          IconButton(
            icon: _isSharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE6D5B8),
                      ),
                    ),
                  )
                : const Icon(Icons.share_rounded, color: Color(0xFFE6D5B8)),
            onPressed: _isSharing ? null : () => _shareSahabi(context),
          ),
          const SizedBox(width: 10),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.names.length - 1,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              int imageNum = index + 1;
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                onInteractionUpdate: (details) {
                  setState(() {
                    _currentScale = details.scale;
                  });
                },
                child: Center(
                  child: Hero(
                    tag: 'image$imageNum',
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/$imageNum.jpg",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            ErrorHandler.logError(
                              "Image load error: $imageNum",
                              stackTrace!,
                            );
                            return Container(
                              width: double.infinity,
                              height: 400,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D1B10),
                                borderRadius: BorderRadius.circular(20),
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
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'صورة الصحابي غير متوفرة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
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
              );
            },
          ),
          if (_currentScale != 1.0)
            Positioned(
              top: 120,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.zoom_in,
                        color: Color(0xFFD4AF37),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (_currentScale - 0.5) / 3.5,
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  const Text(
                    "يمكنك تكبير الصورة أو السحب للتنقل",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.names.length - 1,
                      (index) => GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentIndex == index ? 25 : 8,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? const Color(0xFFE6D5B8)
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      key: ValueKey<int>(_currentIndex),
                      '${_currentIndex + 1} من ${widget.names.length - 1}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              onPressed: _showNavigationMenu,
              backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.8),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showNavigationMenu() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF2D1B10),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'الانتقال السريع',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: widget.names.length - 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.names[index + 1],
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                    trailing: _currentIndex == index
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFFD4AF37),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
