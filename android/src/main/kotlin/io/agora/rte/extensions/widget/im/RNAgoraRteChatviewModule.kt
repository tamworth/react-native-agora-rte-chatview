package io.agora.rte.extensions.widget.im

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule

class RNAgoraRteChatviewModule(private val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(
        reactContext
    ) {
    override fun getName(): String {
        return "RCTRteChatViewModule"
    }
}