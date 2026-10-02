<?php

declare(strict_types=1);

use MrPunyapal\Impressions\Facades\Impressions;
use MrPunyapal\Impressions\Testing\BridgeFake;
use PHPUnit\Framework\AssertionFailedError;

it('binds a fake bridge into the container and returns canned responses', function (): void {
    Impressions::fake([
        'Impressions.Example' => ['ok' => true],
    ]);

    expect(Impressions::example(['message' => 'hi']))->toBe(['ok' => true]);
});

it('invokes closure stubs with the payload', function (): void {
    Impressions::fake([
        'Impressions.Example' => fn (array $payload): array => ['echo' => $payload],
    ]);

    expect(Impressions::example(['message' => 'hi']))->toBe(['echo' => ['message' => 'hi']]);
});

it('returns an empty array for unstubbed calls by default', function (): void {
    $fake = Impressions::fake();

    expect($fake->call('Impressions.Missing', []))->toBe([]);
});

it('throws on unstubbed calls when stray calls are prevented', function (): void {
    $fake = (new BridgeFake)->preventStrayCalls();

    expect(fn (): array => $fake->call('Impressions.Missing', []))
        ->toThrow(RuntimeException::class, 'The mrpunyapal/nativephp-plugin-impressions bridge received an unexpected call to [Impressions.Missing]. Stub it or allow stray calls.');
});

it('adds a stub after construction', function (): void {
    $fake = new BridgeFake;

    $fake->stub('Impressions.Example', ['stubbed' => true]);

    expect($fake->call('Impressions.Example', []))->toBe(['stubbed' => true]);
});

it('asserts a function was called, with and without a payload callback', function (): void {
    $fake = new BridgeFake;

    $fake->call('Impressions.Example', ['message' => 'hi']);

    $fake->assertCalled('Impressions.Example');
    $fake->assertCalled('Impressions.Example', fn (array $payload): bool => $payload['message'] === 'hi');
});

it('asserts a function was not called', function (): void {
    $fake = new BridgeFake;

    $fake->assertNotCalled('Impressions.Example');
});

it('asserts a function was called a given number of times', function (): void {
    $fake = new BridgeFake;

    $fake->call('Impressions.Example', []);
    $fake->call('Impressions.Example', []);

    $fake->assertCalledTimes('Impressions.Example', 2);
});

it('asserts nothing was called', function (): void {
    $fake = new BridgeFake;

    $fake->assertNothingCalled();
});

it('fails assertCalled when the function was never called', function (): void {
    $fake = new BridgeFake;

    expect(fn () => $fake->assertCalled('Impressions.Missing'))->toThrow(AssertionFailedError::class);
});

it('fails assertNotCalled when the function was called', function (): void {
    $fake = new BridgeFake;

    $fake->call('Impressions.Example', []);

    expect(fn () => $fake->assertNotCalled('Impressions.Example'))->toThrow(AssertionFailedError::class);
});

it('fails assertCalledTimes when the count does not match', function (): void {
    $fake = new BridgeFake;

    $fake->call('Impressions.Example', []);

    expect(fn () => $fake->assertCalledTimes('Impressions.Example', 2))->toThrow(AssertionFailedError::class);
});

it('fails assertNothingCalled when a call was recorded', function (): void {
    $fake = new BridgeFake;

    $fake->call('Impressions.Example', []);

    expect(fn () => $fake->assertNothingCalled())->toThrow(AssertionFailedError::class);
});

it('reports the bridge as unavailable with no binding and available after fake()', function (): void {
    expect(Impressions::isAvailable())->toBeFalse();

    Impressions::fake();

    expect(Impressions::isAvailable())->toBeTrue();
});
