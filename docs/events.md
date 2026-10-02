# Events

Use events when native code needs to notify the Laravel application about asynchronous state.

The template includes:

```php
MrPunyapal\Impressions\Events\ImpressionsEvent
```

Events listed in `nativephp.json` document the package-level event surface:

```json
"events": [
  "MrPunyapal\Impressions\\Events\\ImpressionsEvent"
]
```

Keep event payloads serializable because mobile events can cross process and platform boundaries.
