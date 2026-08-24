#include "include/targetlib/targetlib_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "targetlib_plugin.h"

void TargetlibPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  targetlib::TargetlibPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
