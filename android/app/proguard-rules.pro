# ML Kit Text Recognition keep rules
# We only use the Latin script, so we ignore warnings for the others
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# General ML Kit / Firebase keep rules if needed
-keep class com.google.mlkit.** { *; }
-keep class com.google.firebase.** { *; }
