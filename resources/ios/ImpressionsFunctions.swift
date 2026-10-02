import Foundation

/// iOS bridge functions for mrpunyapal/nativephp-plugin-impressions.
///
/// Flow:
/// PHP calls Impressions::example()
/// NativePHP invokes Impressions.Example
/// Swift receives the payload here
/// iOS APIs can be called from execute()
/// A dictionary is returned to PHP
enum ImpressionsFunctions {
    class Example: BridgeFunction {
        func execute(parameters: [String: Any]) throws -> [String: Any] {
            return [
                "plugin": "Impressions",
                "platform": "ios",
                "received": parameters,
            ]
        }
    }
}
