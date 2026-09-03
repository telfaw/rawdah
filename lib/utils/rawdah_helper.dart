import 'dart:io';
import 'package:rawdah/error_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class RawdahHelper {
  static const String androidPackageName = "com.calc.rawdah";
  // يمكنك إضافة معرف App Store لاحقاً إذا توفر
  static const String iOSAppId = "";

  static Future<void> openAppInStore() async {
    String url = "";
    if (Platform.isAndroid) {
      url = "https://play.google.com/store/apps/details?id=$androidPackageName";
    } else if (Platform.isIOS && iOSAppId.isNotEmpty) {
      url = "https://apps.apple.com/app/id$iOSAppId";
    }

    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      try {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      } catch (e) {
        ErrorHandler.logError(
          "Rawdah Store Link Error: $e",
          StackTrace.current,
        );
      }
    }
  }
}
