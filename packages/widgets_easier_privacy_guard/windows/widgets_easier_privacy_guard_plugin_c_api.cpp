#include "include/widgets_easier_privacy_guard/widgets_easier_privacy_guard_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "widgets_easier_privacy_guard_plugin.h"

void WidgetsEasierPrivacyGuardPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  widgets_easier_privacy_guard::WidgetsEasierPrivacyGuardPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
