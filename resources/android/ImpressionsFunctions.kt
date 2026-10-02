package com.mrpunyapal.impressions

import com.nativephp.mobile.bridge.BridgeFunction
import org.json.JSONObject

/**
 * Android bridge functions for mrpunyapal/nativephp-plugin-impressions.
 *
 * Flow:
 * PHP calls Impressions::example()
 * NativePHP invokes Impressions.Example
 * Kotlin receives the JSON payload here
 * Android APIs can be called from execute()
 * A JSONObject is returned to PHP
 */
object ImpressionsFunctions {
    class Example : BridgeFunction {
        override fun execute(parameters: Map<String, Any>): Map<String, Any> {
            return mapOf("plugin" to "Impressions", "platform" to "android", "received" to parameters)
        }
    }
}
