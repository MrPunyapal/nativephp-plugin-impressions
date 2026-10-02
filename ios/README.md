# iOS Packaging

NativePHP Mobile plugins keep installable iOS source in `resources/ios`.

The file `resources/ios/ImpressionsFunctions.swift` is copied into the generated iOS project when `mrpunyapal/nativephp-plugin-impressions` is installed in a NativePHP Mobile app.

Use the Swift symbol from `nativephp.json`:

```json
"ios": "ImpressionsFunctions.Example"
```

When replacing placeholders, keep the Swift type and manifest bridge target in sync.
