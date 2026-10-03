# iOS Packaging

NativePHP Mobile plugins keep installable iOS source in `resources/ios`.

`resources/ios/ImpressionRenderer.swift` renders the `<native:impression>` container. `ImpressionVisibility.swift` implements viewport qualification and continuous dwell timing. NativePHP copies both into the generated iOS project and registers `ImpressionRenderer` through the manifest's `ios_renderer` field.

The renderer uses the actual window and clipping scroll ancestors, caps tall posts to the viewport, and cancels dwell when the app backgrounds or the row leaves the viewport. It fires once per mounted identity after the configured threshold and dwell period.

`ImpressionsFunctions.Example` is a legacy example bridge, not the impressions implementation.

Run `swift test` on macOS for geometry and dwell regressions. A rebuilt app is required for device testing; stock Jump does not load custom native renderers.
