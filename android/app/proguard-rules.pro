# Keep Flutter classes and methods intact
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }

# Keep your main activity
-keep class com.antywayco.ponte_glam.MainActivity { *; }

# Firebase Authentication
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Required for OAuth and Google Sign-In
-keep class com.google.api.client.googleapis.extensions.android.gms.auth.** { *; }
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.api.** { *; }
-keep class com.google.android.play.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
# Stripe rules
-keep class com.stripe.android.** { *; }
-keep class com.stripe.android.payments.paymentlauncher.** { *; }

-keepattributes Exceptions, InnerClasses, Signature, Deprecated, SourceFile, LineNumberTable, *Annotation*, EnclosingMethod
-dontwarn com.google.android.play.**
-dontwarn com.stripe.android.**