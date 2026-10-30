import 'package:flutter/material.dart';
import 'package:rawdah/utils/settings_helper.dart';

void showAppSettingsDialog(
  BuildContext context, {
  required VoidCallback onUpdated,
  VoidCallback? onToggleTheme,
  VoidCallback? onVoiceSearch,
}) {
  showDialog(
    context: context,
    builder: (context) => _SettingsDialogContent(
      onToggleTheme: onToggleTheme,
      onVoiceSearch: onVoiceSearch,
    ),
  ).then((_) => onUpdated());
}

class _SettingsDialogContent extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final VoidCallback? onVoiceSearch;

  const _SettingsDialogContent({
    this.onToggleTheme,
    this.onVoiceSearch,
  });

  @override
  State<_SettingsDialogContent> createState() => _SettingsDialogContentState();
}

class _SettingsDialogContentState extends State<_SettingsDialogContent> {
  double _titleSize = AppSettings.defaultTitleSize;
  double _subtitleSize = AppSettings.defaultSubtitleSize;
  double _bodySize = AppSettings.defaultBodySize;

  @override
  void initState() {
    super.initState();
    _loadSizes();
  }

  Future<void> _loadSizes() async {
    final sizes = await AppSettings.loadFontSizes();
    if (mounted) {
      setState(() {
        _titleSize = sizes['title'] ?? AppSettings.defaultTitleSize;
        _subtitleSize = sizes['subtitle'] ?? AppSettings.defaultSubtitleSize;
        _bodySize = sizes['body'] ?? AppSettings.defaultBodySize;
      });
    }
  }

  Future<void> _save() async {
    await AppSettings.saveFontSizes(
      title: _titleSize,
      subtitle: _subtitleSize,
      body: _bodySize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color gold = Color(0xFFD4AF37);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            const Icon(Icons.settings_rounded, color: gold),
            const SizedBox(width: 8),
            Text(
              'إعدادات التطبيق والمظهر',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: _titleSize > 22 ? 22 : _titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.onToggleTheme != null || widget.onVoiceSearch != null) ...[
                const Text(
                  'خيارات المظهر والبحث الصوتي:',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (widget.onToggleTheme != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            widget.onToggleTheme!();
                            setState(() {});
                          },
                          icon: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            size: 18,
                            color: gold,
                          ),
                          label: Text(
                            isDark ? 'الوضع النهاري' : 'الوضع الليلي',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: gold,
                            side: const BorderSide(color: gold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    if (widget.onToggleTheme != null && widget.onVoiceSearch != null)
                      const SizedBox(width: 8),
                    if (widget.onVoiceSearch != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onVoiceSearch!();
                          },
                          icon: const Icon(Icons.mic, size: 18),
                          label: const Text(
                            'البحث الصوتي',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const Divider(height: 24),
              ],
              Text(
                'التحكم بحجم الخط (الرئيسية 22 كحد أقصى، الفرعية 18، والمواضيع 16 بفارق 2):',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: _subtitleSize,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildSizeRow(
                'العناوين الرئيسية (الحد الأقصى 22)',
                _titleSize,
                22.0,
                16.0,
                (val) {
                  setState(() {
                    _titleSize = val.clamp(16.0, 22.0);
                    _subtitleSize = (_titleSize - 4).clamp(12.0, 18.0);
                    _bodySize = (_titleSize - 6).clamp(10.0, 16.0);
                  });
                  _save();
                },
              ),
              const Divider(height: 20),
              _buildSizeRow(
                'العناوين الفرعية (الحد الأقصى 18)',
                _subtitleSize,
                18.0,
                12.0,
                (val) {
                  setState(() {
                    _subtitleSize = val.clamp(12.0, 18.0);
                    _titleSize = (_subtitleSize + 4).clamp(16.0, 22.0);
                    _bodySize = (_subtitleSize - 2).clamp(10.0, 16.0);
                  });
                  _save();
                },
              ),
              const Divider(height: 20),
              _buildSizeRow(
                'نصوص الموضوع (الحد الأقصى 16)',
                _bodySize,
                16.0,
                10.0,
                (val) {
                  setState(() {
                    _bodySize = val.clamp(10.0, 16.0);
                    _titleSize = (_bodySize + 6).clamp(16.0, 22.0);
                    _subtitleSize = (_bodySize + 2).clamp(12.0, 18.0);
                  });
                  _save();
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _titleSize = AppSettings.defaultTitleSize;
                _subtitleSize = AppSettings.defaultSubtitleSize;
                _bodySize = AppSettings.defaultBodySize;
              });
              await _save();
            },
            child: const Text('إعادة الافتراضي', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: gold),
            child: const Text('حفظ وإغلاق', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeRow(
    String label,
    double currentSize,
    double maxLimit,
    double minLimit,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.remove_circle_outline,
                color: currentSize > minLimit ? const Color(0xFFD4AF37) : Colors.grey,
                size: 22,
              ),
              onPressed: currentSize > minLimit
                  ? () => onChanged(currentSize - 2)
                  : null,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${currentSize.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.add_circle_outline,
                color: currentSize < maxLimit ? const Color(0xFFD4AF37) : Colors.grey,
                size: 22,
              ),
              onPressed: currentSize < maxLimit
                  ? () => onChanged(currentSize + 2)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
