# Flutter الأساسي
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.crypto.tink.** { *; } # إذا كنت تستخدم التشفير

# منع حذف الأسماء في موديلات الـ JSON (مهم جداً إذا كنت تستخدم حزم مثل json_serializable)
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# إذا كنت تستخدم Firebase أو Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# منع حذف الكود الخاص بالـ Platform Channels (التواصل بين Dart و Native)
-keep class * extends io.flutter.plugin.common.MethodChannel { *; }

# معالجة التحذيرات العامة التي قد توقف عملية البناء (Build)
-dontwarn javax.annotation.**
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**
# Google Play Core (Modern Split Libraries)
-keep class com.google.android.play.core.common.IntentSenderForResultStarter { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.review.** { *; }
-keep class com.google.android.play.core.install.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.assetpacks.** { *; }

-dontwarn com.google.android.play.core.**
