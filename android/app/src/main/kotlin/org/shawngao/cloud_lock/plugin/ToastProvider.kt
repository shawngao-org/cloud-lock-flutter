package org.shawngao.cloud_lock.plugin

import android.content.Context
import android.widget.Toast
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object ToastProvider {

    private const val channelName = "org.shawngao.channel/toast"

    @JvmStatic
    fun register(context: Context, binaryMessenger: BinaryMessenger) = MethodChannel(
        binaryMessenger, channelName
    ).setMethodCallHandler { methodCall, result ->
        when (methodCall.method) {
            "showShortToast" ->
                methodCall.argument<String>("message")
                    ?.let { showToast(context, it, Toast.LENGTH_SHORT) }
            "showLongToast" ->
                methodCall.argument<String>("message")
                    ?.let { showToast(context, it, Toast.LENGTH_LONG) }
            "showToast" ->
                methodCall.argument<String>("message")
                    ?.let { methodCall.argument<Int>("duration")
                        ?.let { it1 -> showToast(context, it, it1) } }
        }
        result.success(null)
    }

    private fun showToast(context: Context, message: String, duration: Int) = Toast.makeText(
        context, message, duration
    ).show()
}
