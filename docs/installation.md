# Installation

This template becomes installable after placeholders are replaced and the package is published.

```bash
composer require mrpunyapal/nativephp-plugin-impressions
```

Laravel auto-discovery loads `MrPunyapal\Impressions\Providers\ImpressionsServiceProvider`.

For local development inside a NativePHP Mobile app:

```json
{
  "repositories": [
    {
      "type": "path",
      "url": "../nativephp-plugin-impressions"
    }
  ]
}
```

Then install:

```bash
composer require mrpunyapal/nativephp-plugin-impressions:@dev
```
