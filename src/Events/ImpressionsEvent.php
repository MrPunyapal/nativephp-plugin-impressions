<?php

declare(strict_types=1);

namespace MrPunyapal\Impressions\Events;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

final readonly class ImpressionsEvent
{
    use Dispatchable;
    use SerializesModels;

    /**
     * @param array<string, mixed> $payload
     */
    public function __construct(
        public string $name,
        public array $payload = [],
    ) {}
}
