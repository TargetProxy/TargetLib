package top.loafman.targetlib

import android.content.Context
import android.content.Intent
import android.net.VpnService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TargetlibPlugin */
class TargetlibPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: android.app.Activity? = null
    private var permission: TargetlibVpnPermission? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "targetlib")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "requestVpnPermission" -> {
                val requester = permission
                if (requester == null) result.error("NO_ACTIVITY", "VPN permission requires an attached Activity", null)
                else requester.request { result.success(it) }
            }
            "startAndroidService" -> startService(call, result)
            "stopAndroidService" -> {
                val app = context
                if (app == null) result.error("NO_CONTEXT", "Plugin is detached", null)
                else result.success(app.stopService(Intent(app, TargetlibVpnService::class.java)))
            }
            else -> result.notImplemented()
        }
    }

    private fun startService(call: MethodCall, result: Result) {
        val app = context
        if (app == null) { result.error("NO_CONTEXT", "Plugin is detached", null); return }
        if (activity != null && VpnService.prepare(activity) != null) {
            result.error("VPN_PERMISSION_REQUIRED", "Request VPN permission first", null); return
        }
        val basePath = call.argument<String>("basePath")
        if (basePath.isNullOrBlank()) {
            result.error("INVALID_ARGUMENT", "basePath is required", null); return
        }
        val intent = Intent(app, TargetlibVpnService::class.java).apply {
            putExtra(TargetlibVpnService.EXTRA_BASE_PATH, basePath)
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            app.startForegroundService(intent)
        } else {
            app.startService(intent)
        }
        result.success(null)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        activity = binding.activity
        permission = TargetlibVpnPermission(binding.activity).also {
            binding.addActivityResultListener(it)
        }
    }
    private fun detachActivity() {
        permission?.let { activityBinding?.removeActivityResultListener(it) }
        activityBinding = null
        activity = null
        permission = null
    }
    override fun onDetachedFromActivityForConfigChanges() = detachActivity()
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)
    override fun onDetachedFromActivity() = detachActivity()
}
