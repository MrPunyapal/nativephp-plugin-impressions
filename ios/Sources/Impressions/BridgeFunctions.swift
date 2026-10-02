import Foundation

/// Standalone iOS starter for mrpunyapal/nativephp-plugin-impressions.
///
/// NativePHP consumes the installable bridge implementation from
/// resources/ios/ImpressionsFunctions.swift. This file documents a conventional
/// Swift package source layout for maintainers who later split native code into
/// a dedicated iOS module.
public final class BridgeFunctions {
    public init() {}

    public func example(payload: [String: Any]) -> [String: Any] {
        [
            "plugin": "Impressions",
            "platform": "ios",
            "received": payload,
        ]
    }
}
