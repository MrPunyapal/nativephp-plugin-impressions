<?php

declare(strict_types=1);

namespace MrPunyapal\Impressions\Components;

use Native\Mobile\Edge\Components\Native\NativeBladeComponent;

final class Impression extends NativeBladeComponent
{
    protected function elementType(): string
    {
        return 'impression';
    }
}
