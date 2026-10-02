<?php

declare(strict_types=1);

use MrPunyapal\Impressions\Contracts\ImpressionsContract;
use MrPunyapal\Impressions\Facades\Impressions;

it('registers the plugin contract and facade accessor', function (): void {
    $bridge = new class
    {
        /**
         * @param array<string, mixed> $payload
         * @return array<string, mixed>
         */
        public function call(string $function, array $payload): array
        {
            return [
                'function' => $function,
                'payload' => $payload,
                'platform' => 'test',
            ];
        }
    };

    app()->instance('nativephp.mobile.bridge', $bridge);

    expect(app(ImpressionsContract::class))->toBe(app('nativephp-plugin-impressions'))
        ->and(Impressions::example(['message' => 'Native visibility impressions for NativePHP Mobile EDGE components']))->toBe([
            'function' => 'Impressions.Example',
            'payload' => ['message' => 'Native visibility impressions for NativePHP Mobile EDGE components'],
            'platform' => 'test',
        ]);
});
