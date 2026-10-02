# Bridge Functions

A bridge function connects PHP to native platform code.

## PHP to Android

```text
MrPunyapal\Impressions\Facades\Impressions::example()
  -> MrPunyapal\Impressions\Plugin::example()
  -> "Impressions.Example"
  -> com.mrpunyapal.impressions.ImpressionsFunctions.Example
  -> Android platform logic
  -> JSONObject response
```

## PHP to iOS

```text
MrPunyapal\Impressions\Facades\Impressions::example()
  -> MrPunyapal\Impressions\Plugin::example()
  -> "Impressions.Example"
  -> ImpressionsFunctions.Example
  -> iOS platform logic
  -> dictionary response
```

## Adding A Function

1. Add a `bridge_functions` entry to `nativephp.json`.
2. Add the Kotlin class under `resources/android`.
3. Add the Swift class under `resources/ios`.
4. Add a PHP method on `MrPunyapal\Impressions\Contracts\ImpressionsContract`.
5. Implement the method on `MrPunyapal\Impressions\Plugin`.
6. Add tests for the manifest and PHP call.
