# Release build proguard/R8 rules (US-122).
#
# The Flutter Gradle plugin already applies its own keep rules for the
# engine and platform channels; this file only covers this app's extra
# dependencies with reflection/JNI surfaces that R8 cannot see through
# statically.

# sqlite3 (via drift): the native bindings are loaded through FFI, not
# reflection, but keep the package's public API in case a future dependency
# reflects into it.
-keep class io.sqlite3.** { *; }

# Keep annotation-derived metadata (freezed/json_serializable) if any
# generated class is ever reached only through reflection at runtime.
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses

# Uncomment and extend if a release build crashes only in --release (never
# in --debug) with a ClassNotFoundException/NoSuchMethodError — that is the
# signature of an over-aggressive strip; add the specific class here rather
# than disabling shrinking.
