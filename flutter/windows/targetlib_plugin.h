#ifndef FLUTTER_PLUGIN_TARGETLIB_PLUGIN_H_
#define FLUTTER_PLUGIN_TARGETLIB_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace targetlib {

class TargetlibPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TargetlibPlugin();

  virtual ~TargetlibPlugin();

  // Disallow copy and assign.
  TargetlibPlugin(const TargetlibPlugin&) = delete;
  TargetlibPlugin& operator=(const TargetlibPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace targetlib

#endif  // FLUTTER_PLUGIN_TARGETLIB_PLUGIN_H_
