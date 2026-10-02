<?php

declare(strict_types=1);

use MrPunyapal\Impressions\Elements\Impression;
use Native\Mobile\Edge\CallbackRegistry;
use Native\Mobile\Edge\Elements\Text;

it('serializes an impression container without changing its children', function (): void {
    $element = Impression::make(Text::make('A post'));
    $element->applyAttributes(['identity' => 'post-1', 'on-impression' => "seen('post-1')"]);
    $registry = new CallbackRegistry;
    $tree = $element->toArray($registry);

    expect($tree['type'])->toBe('impression')
        ->and($tree['props'])->toMatchArray(['identity' => 'post-1', 'enabled' => true, 'threshold' => 0.5, 'dwell_ms' => 500])
        ->and($tree['props']['on_impression'])->toBe($registry->register("seen('post-1')"))
        ->and($tree['children'][0]['type'])->toBe('text');
});

it('clamps malformed thresholds and dwell periods and supports disabling tracking', function (): void {
    $element = Impression::make();
    $element->applyAttributes(['enabled' => false, 'threshold' => 12, 'dwell-ms' => -1]);
    expect($element->toArray(new CallbackRegistry)['props'])->toMatchArray(['enabled' => false, 'threshold' => 1.0, 'dwell_ms' => 100, 'on_impression' => 0]);
});
