# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt

# Keep AR Sceneform classes
-keep class com.google.ar.sceneform.** { *; }
-dontwarn com.google.ar.sceneform.**

# Keep AR Core classes
-keep class com.google.ar.core.** { *; }
-dontwarn com.google.ar.core.**

# Keep Filament classes (used by Sceneform)
-keep class com.google.android.filament.** { *; }
-dontwarn com.google.android.filament.**

# Keep animation classes
-keep class com.google.ar.sceneform.animation.** { *; }
-dontwarn com.google.ar.sceneform.animation.**

# Keep assets classes
-keep class com.google.ar.sceneform.assets.** { *; }
-dontwarn com.google.ar.sceneform.assets.**

# Keep rendering classes
-keep class com.google.ar.sceneform.rendering.** { *; }
-dontwarn com.google.ar.sceneform.rendering.**

# Keep utilities classes
-keep class com.google.ar.sceneform.utilities.** { *; }
-dontwarn com.google.ar.sceneform.utilities.**

# Keep desugar runtime
-keep class com.google.devtools.build.android.desugar.runtime.** { *; }
-dontwarn com.google.devtools.build.android.desugar.runtime.**

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Preserve annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod
