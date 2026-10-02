<?php

declare(strict_types=1);

namespace MrPunyapal\Impressions\Providers;

use Illuminate\Support\ServiceProvider;
use MrPunyapal\Impressions\Contracts\ImpressionsContract;
use MrPunyapal\Impressions\Plugin;

final class ImpressionsServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->singleton('nativephp-plugin-impressions', fn ($app): Plugin => new Plugin($app));
        $this->app->alias('nativephp-plugin-impressions', ImpressionsContract::class);
    }

    public function boot(): void
    {
        $this->publishes([
            dirname(__DIR__, 2).'/nativephp.json' => base_path('nativephp/nativephp-plugin-impressions.json'),
        ], 'nativephp-plugin-impressions-nativephp-manifest');
    }
}
