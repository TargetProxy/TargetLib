package top.loafman.targetlib

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.net.VpnService
import android.util.Log

/** Foreground Android VPN host. JNI is owned exclusively by this service. */
class TargetlibVpnService : VpnService() {
    private var handle: Long = 0

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, buildNotification())
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (handle != 0L) return START_STICKY
        try {
            val preferences = getSharedPreferences(PREFERENCES, MODE_PRIVATE)
            val requestedBasePath = intent?.getStringExtra(EXTRA_BASE_PATH)
            if (!requestedBasePath.isNullOrBlank()) {
                preferences.edit().putString(KEY_BASE_PATH, requestedBasePath).apply()
            }
            val basePath = requestedBasePath
                ?: preferences.getString(KEY_BASE_PATH, null)
                ?: filesDir.resolve("TargetLib").path
            val tunnel = Builder()
                .setSession("TargetLib")
                .addAddress(TUN_IPV4_ADDRESS, TUN_IPV4_PREFIX_LENGTH)
                .addAddress(TUN_IPV6_ADDRESS, TUN_IPV6_PREFIX_LENGTH)
                .addRoute("0.0.0.0", 0)
                .addDisallowedApplication(packageName)
                .establish() ?: error("Unable to establish Android VPN interface")
            TargetlibNative.init(
                basePath = basePath,
            )
            TargetlibNative.setTunFd(tunnel.detachFd())
            handle = TargetlibNative.serve()
        } catch (error: Throwable) {
            Log.e(TAG, "Unable to start TargetLib VPN service", error)
            stopSelf(startId)
        }
        return START_STICKY
    }

    override fun onDestroy() {
        if (handle != 0L) {
            runCatching { TargetlibNative.stop(handle) }
            runCatching { TargetlibNative.freeHandle(handle) }
            handle = 0
        }
        stopForeground(STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                "Target VPN",
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = "Keeps the Target VPN connection running"
                setShowBadge(false)
            },
        )
    }

    private fun buildNotification(): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        val contentIntent = launchIntent?.let {
            PendingIntent.getActivity(
                this,
                0,
                it,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }
        val icon = applicationInfo.icon.takeIf { it != 0 }
            ?: android.R.drawable.stat_sys_warning
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setSmallIcon(icon)
            .setContentTitle("Target VPN")
            .setContentText("VPN service is running")
            .setContentIntent(contentIntent)
            .setOngoing(true)
            .setCategory(Notification.CATEGORY_SERVICE)
            .build()
    }

    companion object {
        private const val TAG = "TargetlibVpnService"
        private const val CHANNEL_ID = "targetlib_vpn"
        private const val NOTIFICATION_ID = 0x544C
        private const val PREFERENCES = "targetlib_vpn"
        private const val KEY_BASE_PATH = "base_path"
        // Must match config/build.go's Android TUN inbound prefixes.
        private const val TUN_IPV4_ADDRESS = "172.18.0.1"
        private const val TUN_IPV4_PREFIX_LENGTH = 30
        private const val TUN_IPV6_ADDRESS = "fd00:1:fd00:1::1"
        private const val TUN_IPV6_PREFIX_LENGTH = 126
        const val EXTRA_BASE_PATH = "targetlib.base_path"
    }
}
