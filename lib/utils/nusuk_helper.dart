import 'package:flutter/foundation.dart';
import 'package:rawdah/error_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class NusukHelper {
  static const String androidPackageName = "com.moh.nusukapp";
  static const String androidUrl =
      "https://play.google.com/store/apps/details?id=$androidPackageName&pcampaignid=web_share";
  static const String iOSAppId = "1360011142"; // App Store ID for Nusuk

  static Future<void> openNusukInStore() async {
    if (kIsWeb) {
      return;
    }

    String url = "";
    if (defaultTargetPlatform == TargetPlatform.android) {
      url = androidUrl;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      url = "https://apps.apple.com/app/id$iOSAppId";
    }

    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      try {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      } catch (e) {
        ErrorHandler.logError("Nusuk Link Error: $e", StackTrace.current);
      }
    }
  }
}
