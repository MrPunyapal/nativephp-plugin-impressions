import Foundation
import CoreGraphics

enum ImpressionVisibility {
    static func qualifies(frame: CGRect, viewport: CGRect, clippedViewport: CGRect? = nil, threshold: CGFloat) -> Bool {
        let intersection = frame.intersection(viewport).intersection(clippedViewport ?? viewport)
        let target = min(frame.width, viewport.width) * min(frame.height, viewport.height)
        return !intersection.isNull && target > 0 && intersection.width * intersection.height >= target * threshold
    }
}

struct ImpressionDwellState {
    private var visibleSince: TimeInterval?
    private(set) var fired = false

    mutating func resetDwell() {
        visibleSince = nil
    }

    mutating func sample(qualifies: Bool, now: TimeInterval, dwell: TimeInterval) -> Bool {
        guard !fired else { return false }
        guard qualifies else {
            resetDwell()
            return false
        }
        if visibleSince == nil { visibleSince = now }
        guard let visibleSince, now - visibleSince >= dwell else { return false }
        fired = true
        return true
    }
}
