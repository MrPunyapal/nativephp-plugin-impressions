import SwiftUI
import UIKit

struct ImpressionRenderer: View {
    let node: NativeUINode
    @Environment(\.scenePhase) private var scenePhase
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(node.children) { child in NodeView(node: child) }
        }
        .background {
            ImpressionProbe(
                identity: node.props.getString("identity", default: ""),
                enabled: node.props.getBool("enabled", default: true) && appeared && scenePhase == .active,
                threshold: CGFloat(node.props.getFloat("threshold", default: 0.5)),
                dwell: Double(node.props.getInt("dwell_ms", default: 500)) / 1000,
                callback: node.props.getCallbackId("on_impression"),
                nodeId: node.id
            )
            .allowsHitTesting(false)
        }
        .onAppear { appeared = true }
        .onDisappear { appeared = false }
    }
}

private struct ImpressionProbe: UIViewRepresentable {
    let identity: String
    let enabled: Bool
    let threshold: CGFloat
    let dwell: TimeInterval
    let callback: Int
    let nodeId: Int

    func makeUIView(context: Context) -> ImpressionProbeView {
        ImpressionProbeView()
    }

    func updateUIView(_ view: ImpressionProbeView, context: Context) {
        view.configure(identity: identity, enabled: enabled, threshold: threshold, dwell: dwell, callback: callback, nodeId: nodeId)
    }

    static func dismantleUIView(_ view: ImpressionProbeView, coordinator: Void) {
        view.stop()
    }
}

private final class ImpressionProbeView: UIView {
    private var identity = ""
    private var enabled = false
    private var threshold: CGFloat = 0.5
    private var dwell: TimeInterval = 0.5
    private var callback = 0
    private var nodeId = 0
    private var state = ImpressionDwellState()
    private var displayLink: CADisplayLink?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        window == nil ? stop() : start()
    }

    func configure(identity: String, enabled: Bool, threshold: CGFloat, dwell: TimeInterval, callback: Int, nodeId: Int) {
        if self.identity != identity {
            state = ImpressionDwellState()
        } else if self.enabled != enabled || self.threshold != threshold || self.dwell != dwell || self.callback != callback {
            state.resetDwell()
        }

        self.identity = identity
        self.enabled = enabled
        self.threshold = max(0.01, min(1, threshold))
        self.dwell = max(0.1, min(10, dwell))
        self.callback = callback
        self.nodeId = nodeId

        enabled && callback != 0 ? start() : stop()
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        state.resetDwell()
    }

    private func start() {
        guard window != nil, enabled, callback != 0, !identity.isEmpty, !state.fired, displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(sample))
        link.preferredFrameRateRange = CAFrameRateRange(minimum: 10, maximum: 10, preferred: 10)
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    @objc private func sample() {
        guard let window, window.isKeyWindow, window.windowScene?.activationState == .foregroundActive else {
            state.resetDwell()
            return
        }

        let frame = convert(bounds, to: window)
        var viewport = window.bounds.inset(by: window.safeAreaInsets)
        var clippedViewport = viewport
        var ancestor: UIView? = self

        while let view = ancestor {
            if view.isHidden || view.alpha < 0.01 {
                state.resetDwell()
                return
            }
            let bounds = view.convert(view.bounds, to: window)
            if view.clipsToBounds {
                clippedViewport = clippedViewport.intersection(bounds)
            }
            if view is UIScrollView {
                viewport = viewport.intersection(bounds)
            }
            ancestor = view.superview
        }

        let visible = ImpressionVisibility.qualifies(frame: frame, viewport: viewport, clippedViewport: clippedViewport, threshold: threshold)
        if state.sample(qualifies: visible, now: ProcessInfo.processInfo.systemUptime, dwell: dwell) {
            stop()
            NativeElementBridge.sendPressEvent(callback, nodeId: nodeId)
        }
    }
}
