package top.loafman.targetlib

/** Minimal JNI facade for the native TargetLib service lifecycle. */
object TargetlibNative {
    init {
        System.loadLibrary("targetlib")
        System.loadLibrary("targetlib_jni")
    }

    @JvmStatic
    external fun start(
        basePath: String,
        workingPath: String = "",
        tempPath: String = "",
        locale: String = "",
        logMaxLines: Int = 0,
        debug: Boolean = false,
        oomKiller: Boolean = false,
    )

    @JvmStatic
    external fun setTunFd(fd: Int)

    @JvmStatic
    external fun stop()
}
