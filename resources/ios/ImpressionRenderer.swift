import SwiftUI

struct ImpressionRenderer: View {
    let node: NativeUINode
    @Environment(\.scenePhase) private var scenePhase
    @State private var scrollVisible = false
    @State private var visible = false
    @State private var fired = false

    private var identity: String { node.props.getString("identity", default: "") }
    private var enabled: Bool { node.props.getBool("enabled", default: true) }
    private var threshold: CGFloat { CGFloat(node.props.getFloat("threshold", default: 0.5)) }
    private var dwell: Int { node.props.getInt("dwell_ms", default: 500) }
    private var qualifies: Bool { enabled && visible && scrollVisible && scenePhase == .active && !fired }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(node.children) { child in NodeView(node: child) }
        }
        .onScrollVisibilityChange(threshold: 0.01) { scrollVisible = $0 }
        .onGeometryChange(for: CGRect.self) { proxy in proxy.frame(in: .global) } action: { frame in
            let screen = UIScreen.main.bounds
            let intersection = frame.intersection(screen)
            let target = min(frame.width, screen.width) * min(frame.height, screen.height)
            visible = !intersection.isNull && target > 0 && intersection.width * intersection.height >= target * threshold
        }
        .onChange(of: identity) { _, _ in fired = false }
        .task(id: qualifies) {
            guard qualifies, !identity.isEmpty else { return }
            do { try await Task.sleep(for: .milliseconds(dwell)) } catch { return }
            guard !Task.isCancelled, qualifies else { return }
            let callback = node.props.getCallbackId("on_impression")
            guard callback != 0 else { return }
            fired = true
            NativeElementBridge.sendPressEvent(callback, nodeId: node.id)
        }
    }
}
