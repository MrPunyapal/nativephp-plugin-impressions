import XCTest
@testable import ImpressionVisibility

final class ImpressionVisibilityTests: XCTestCase {
    func testOnlyTheScrollViewportCounts() {
        let viewport = CGRect(x: 0, y: 100, width: 300, height: 500)
        XCTAssertFalse(ImpressionVisibility.qualifies(frame: CGRect(x: 0, y: 50, width: 300, height: 80), viewport: viewport, threshold: 0.5))
        XCTAssertTrue(ImpressionVisibility.qualifies(frame: CGRect(x: 0, y: 60, width: 300, height: 80), viewport: viewport, threshold: 0.5))
        XCTAssertFalse(ImpressionVisibility.qualifies(frame: CGRect(x: 0, y: 650, width: 300, height: 80), viewport: viewport, threshold: 0.5))
    }

    func testTallPostsUseTheViewportAsTheirTargetArea() {
        XCTAssertTrue(ImpressionVisibility.qualifies(frame: CGRect(x: 0, y: -500, width: 300, height: 2000), viewport: CGRect(x: 0, y: 100, width: 300, height: 500), threshold: 0.5))
        XCTAssertFalse(ImpressionVisibility.qualifies(frame: .zero, viewport: .zero, threshold: 0.5))
        XCTAssertFalse(ImpressionVisibility.qualifies(frame: CGRect(x: 0, y: 0, width: 300, height: 80), viewport: .null, threshold: 0.5))
    }

    func testClippedAncestorsDoNotShrinkTheTargetArea() {
        XCTAssertFalse(ImpressionVisibility.qualifies(frame: CGRect(x: 0, y: 100, width: 300, height: 100), viewport: CGRect(x: 0, y: 100, width: 300, height: 500), clippedViewport: CGRect(x: 0, y: 100, width: 300, height: 20), threshold: 0.5))
    }

    func testContinuousDwellAndDeduplication() {
        var state = ImpressionDwellState()
        XCTAssertFalse(state.sample(qualifies: true, now: 10, dwell: 0.5))
        XCTAssertFalse(state.sample(qualifies: true, now: 10.49, dwell: 0.5))
        XCTAssertTrue(state.sample(qualifies: true, now: 10.5, dwell: 0.5))
        XCTAssertFalse(state.sample(qualifies: true, now: 20, dwell: 0.5))
    }

    func testLeavingViewportOrBackgroundingRestartsDwell() {
        var state = ImpressionDwellState()
        XCTAssertFalse(state.sample(qualifies: true, now: 10, dwell: 0.5))
        XCTAssertFalse(state.sample(qualifies: false, now: 10.4, dwell: 0.5))
        XCTAssertFalse(state.sample(qualifies: true, now: 10.5, dwell: 0.5))
        state.resetDwell()
        XCTAssertFalse(state.sample(qualifies: true, now: 20, dwell: 0.5))
        XCTAssertTrue(state.sample(qualifies: true, now: 20.5, dwell: 0.5))
    }
}
