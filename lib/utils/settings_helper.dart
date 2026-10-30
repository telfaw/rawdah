import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String keyTitleSize = 'font_title_size';
  static const String keySubtitleSize = 'font_subtitle_size';
  static const String keyBodySize = 'font_body_size';

  static const double defaultTitleSize = 22.0;
  static const double defaultSubtitleSize = 18.0;
  static const double defaultBodySize = 16.0;

  static Future<Map<String, double>> loadFontSizes() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'title': prefs.getDouble(keyTitleSize) ?? defaultTitleSize,
      'subtitle': prefs.getDouble(keySubtitleSize) ?? defaultSubtitleSize,
      'body': prefs.getDouble(keyBodySize) ?? defaultBodySize,
    };
  }

  static Future<void> saveFontSizes({
    required double title,
    required double subtitle,
    required double body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyTitleSize, title.clamp(16.0, 22.0));
    await prefs.setDouble(keySubtitleSize, subtitle.clamp(12.0, 18.0));
    await prefs.setDouble(keyBodySize, body.clamp(10.0, 16.0));
  }
}
