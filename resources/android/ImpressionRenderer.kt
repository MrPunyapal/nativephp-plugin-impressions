package com.mrpunyapal.impressions

import android.view.ViewTreeObserver
import androidx.compose.foundation.layout.Column
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.findRootCoordinates
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.findViewTreeLifecycleOwner
import com.nativephp.mobile.ui.nativerender.NativeElementBridge
import com.nativephp.mobile.ui.nativerender.NativeUINode
import com.nativephp.mobile.ui.nativerender.NodeView
import kotlinx.coroutines.delay
import kotlin.math.min

object ImpressionRenderer {
    @Composable
    fun Render(node: NativeUINode, modifier: Modifier) {
        val identity = node.props.getString("identity", "")
        val enabled = node.props.getBool("enabled", true)
        val threshold = node.props.getFloat("threshold", 0.5f).coerceIn(0.01f, 1f)
        val dwell = node.props.getInt("dwell_ms", 500).coerceIn(100, 10000)
        val callback by rememberUpdatedState(node.props.getCallbackId("on_impression"))
        val view = LocalView.current
        val lifecycle = view.findViewTreeLifecycleOwner()?.lifecycle
        var focused by remember(view) { mutableStateOf(view.hasWindowFocus()) }
        var resumed by remember(lifecycle) { mutableStateOf(lifecycle?.currentState?.isAtLeast(Lifecycle.State.RESUMED) == true) }
        var visible by remember(identity) { mutableStateOf(false) }
        var fired by remember(identity) { mutableStateOf(false) }

        DisposableEffect(lifecycle) {
            val observer = LifecycleEventObserver { _, _ ->
                resumed = lifecycle?.currentState?.isAtLeast(Lifecycle.State.RESUMED) == true
            }
            lifecycle?.addObserver(observer)
            onDispose { lifecycle?.removeObserver(observer) }
        }

        DisposableEffect(view) {
            val observer = view.viewTreeObserver
            val listener = ViewTreeObserver.OnWindowFocusChangeListener { focused = it }
            observer.addOnWindowFocusChangeListener(listener)
            onDispose {
                if (observer.isAlive) observer.removeOnWindowFocusChangeListener(listener)
            }
        }

        // boundsInWindow is clipped by the list's viewport; composition alone
        // is not an impression. Cap the target size for posts taller than it.
        Column(modifier.onGloballyPositioned { coordinates ->
            if (!coordinates.isAttached) {
                visible = false
            } else {
                val bounds = coordinates.boundsInWindow()
                val root = coordinates.findRootCoordinates().size
                val targetWidth = min(coordinates.size.width, root.width).toFloat()
                val targetHeight = min(coordinates.size.height, root.height).toFloat()
                val targetArea = targetWidth * targetHeight
                visible = targetArea > 0 && bounds.width * bounds.height >= targetArea * threshold
            }
        }) {
            node.children.forEach { child -> NodeView(node = child) }
        }

        LaunchedEffect(identity, enabled, visible, resumed, focused, fired, dwell, threshold) {
            if (identity.isNotEmpty() && enabled && visible && resumed && focused && !fired && callback != 0) {
                delay(dwell.toLong())
                if (view.isShown && view.hasWindowFocus()) {
                    fired = true
                    NativeElementBridge.sendPressEvent(callback, node.id)
                }
            }
        }
    }
}
