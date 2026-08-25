package top.loafman.targetlib

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

/** Requests the system VPN approval without starting the VPN service. */
class TargetlibVpnPermission(private val activity: Activity) : ActivityResultListener {
    private var callback: ((Boolean) -> Unit)? = null

    fun request(onResult: (granted: Boolean) -> Unit) {
        val intent: Intent? = VpnService.prepare(activity)
        if (intent == null) {
            onResult(true)
            return
        }
        callback = onResult
        activity.startActivityForResult(intent, REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE) return false
        val granted = resultCode == Activity.RESULT_OK && VpnService.prepare(activity) == null
        callback?.invoke(granted)
        callback = null
        return true
    }

    companion object {
        private const val REQUEST_CODE = 0x544C
    }
}
