# NativePHP Impressions

Visibility callbacks for NativePHP Mobile 4.5+ EDGE components on Android and iOS.

Wrap a post or another native element in `<native:impression>`. Fetching or composing an off-screen item does not count: the callback requires at least 50% of its visible target area for 500 milliseconds while the application is active. On iOS the target is capped to the clipping scroll viewport; on Android it is capped to the root view size, so tall posts can still qualify.

## Installation

For local development, check out this repository in the workspace's packages directory and add a Composer path repository (adjust the relative path for your application):

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../../packages/nativephp-plugin-impressions",
            "options": { "symlink": false, "reference": "none" }
        }
    ],
    "require": {
        "mrpunyapal/nativephp-plugin-impressions": "dev-main"
    }
}
```

Install with Composer and register `MrPunyapal\Impressions\Providers\ImpressionsServiceProvider` in the app's native plugin provider list. Validate from the application:

```bash
php artisan native:plugin:validate ../../../packages/nativephp-plugin-impressions
```

The custom renderers require a rebuilt application. Stock Jump does not include this plugin. A CI build using the path repository must provide the plugin at the relative path configured by the application; local-only plugin commits are not available to a GitHub runner.

## Usage

```blade
<native:impression
    native:key="impression-{{ $post['id'] }}"
    identity="{{ $post['id'] }}"
    :enabled="true"
    :threshold="0.5"
    :dwell-ms="500"
    on-impression="recordPostView('{{ $post['id'] }}')"
    class="w-full"
>
    <native:text :text="$post['answer']" />
</native:impression>
```

The callback fires once per identity while that native element remains mounted. Re-entering the screen or remounting a virtualized row can fire it again. The application and server must deduplicate impressions using their own viewer identity and retention window. Send the API request asynchronously; do not count all prefetched posts or block scrolling while recording a view.

`threshold` is clamped to `0.01–1`, and `dwell-ms` to `100–10000`. Android requires API 26+, and iOS requires 18.2+. Visibility is geometric, not proof that the user read the content or that every possible overlay is absent.

## Verification

```bash
composer validate --strict
composer test
composer analyse
```

PHP tests verify element serialization and manifest wiring. Native compilation and real-device scrolling/background testing remain necessary before release.
