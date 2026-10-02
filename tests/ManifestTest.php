<?php

declare(strict_types=1);

use MrPunyapal\Impressions\Support\Manifest;

it('ships a valid NativePHP manifest', function (): void {
    $path = __DIR__.'/../nativephp.json';

    expect($path)->toBeFile();

    /** @var array<string, mixed> $manifest */
    $manifest = json_decode((string) file_get_contents($path), true, flags: JSON_THROW_ON_ERROR);
    $typedManifest = new Manifest($manifest);

    expect($typedManifest->namespace())->toBe('Impressions')
        ->and($typedManifest->bridgeFunctions())->toHaveCount(1)
        ->and($typedManifest->bridgeFunctions()[0]['name'])->toBe('Impressions.Example')
        ->and($typedManifest->bridgeFunctions()[0]['android'])->toContain('ImpressionsFunctions.Example')
        ->and($typedManifest->bridgeFunctions()[0]['ios'])->toBe('ImpressionsFunctions.Example')
        ->and($manifest['components'][0]['type'])->toBe('impression')
        ->and($manifest['components'][0]['self_closing'])->toBeFalse();
});

it('contains no unconfigured manifest or package placeholders', function (): void {
    $files = [
        __DIR__.'/../composer.json',
        __DIR__.'/../nativephp.json',
        __DIR__.'/../docs/manifest-fields.md',
    ];

    expect(implode("\n", array_map(fn (string $file): string => (string) file_get_contents($file), $files)))->not->toContain('{{ vendor }}', '{{ plugin }}', '{{ namespace }}');
});
