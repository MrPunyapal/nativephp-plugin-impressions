<?php

declare(strict_types=1);

namespace MrPunyapal\Impressions\Elements;

use Native\Mobile\Edge\CallbackRegistry;
use Native\Mobile\Edge\Element;

final class Impression extends Element
{
    protected string $type = 'impression';

    /** @var array{identity: string, enabled: bool, threshold: float, dwell_ms: int} */
    private array $impressionProps = ['identity' => '', 'enabled' => true, 'threshold' => 0.5, 'dwell_ms' => 500];

    private ?string $callback = null;

    public static function make(Element ...$children): static
    {
        $element = new self;
        $element->children = $children;

        return $element;
    }

    /** @param array<string, mixed> $attrs */
    public function applyAttributes(array $attrs): void
    {
        $this->impressionProps = [
            'identity' => (string) ($attrs['identity'] ?? ''),
            'enabled' => (bool) ($attrs['enabled'] ?? true),
            'threshold' => max(0.01, min(1.0, (float) ($attrs['threshold'] ?? 0.5))),
            'dwell_ms' => max(100, min(10000, (int) ($attrs['dwell-ms'] ?? $attrs['dwell_ms'] ?? 500))),
        ];
        $this->callback = $attrs['on-impression'] ?? $attrs['on_impression'] ?? null;
        $this->applyA11yAttributes($attrs);
    }

    /** @return array<string, mixed> */
    protected function resolveProps(CallbackRegistry $registry): array
    {
        return [...$this->impressionProps, 'on_impression' => $this->callback === null ? 0 : $registry->register($this->callback)];
    }
}
