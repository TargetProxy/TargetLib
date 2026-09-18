import Flutter
import UIKit

public class TargetlibPlugin: NSObject, FlutterPlugin {
  private var hostRunning = false
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "targetlib", binaryMessenger: registrar.messenger())
    let instance = TargetlibPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "hostStatus":
      result(hostRunning ? "running" : "stopped")
    case "startHost":
      hostRunning = true
      result(nil)
    case "stopHost":
      hostRunning = false
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
