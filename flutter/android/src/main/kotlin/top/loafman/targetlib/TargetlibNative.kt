package top.loafman.targetlib

/** Minimal JNI facade for the native TargetLib service lifecycle. */
object TargetlibNative {
    init {
        System.loadLibrary("targetlib")
        System.loadLibrary("targetlib_jni")
    }

    @JvmStatic
    external fun init(
        basePath: String,
        workingPath: String = "",
        tempPath: String = "",
        locale: String = "",
        logMaxLines: Int = 0,
        debug: Boolean = false,
        oomKillerEnabled: Boolean = false,
        oomKillerDisabled: Boolean = false,
    )

    @JvmStatic
    external fun start(configJson: String): Long

    @JvmStatic
    external fun serve(): Long

    @JvmStatic
    external fun setTunFd(fd: Int)

    @JvmStatic
    external fun stop(handle: Long)

    @JvmStatic
    external fun freeHandle(handle: Long)
}
