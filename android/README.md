# Android Packaging

NativePHP Mobile plugins keep installable Android source in `resources/android`.

The file `resources/android/ImpressionsFunctions.kt` is copied into the generated Android project when `mrpunyapal/nativephp-plugin-impressions` is installed in a NativePHP Mobile app.

Use the package name from `nativephp.json`:

```json
"android": "com.mrpunyapal.impressions.ImpressionsFunctions.Example"
```

When replacing placeholders, keep the Kotlin package and manifest bridge target in sync.
