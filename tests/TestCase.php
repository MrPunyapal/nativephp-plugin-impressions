<?php

declare(strict_types=1);

namespace MrPunyapal\Impressions\Tests;

use Illuminate\Foundation\Application;
use MrPunyapal\Impressions\Providers\ImpressionsServiceProvider;
use Orchestra\Testbench\TestCase as Orchestra;

abstract class TestCase extends Orchestra
{
    /**
     * @param Application $app
     * @return list<class-string>
     */
    protected function getPackageProviders($app): array
    {
        return [
            ImpressionsServiceProvider::class,
        ];
    }
}
