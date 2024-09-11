#include "include/widgets_easier/widgets_easier_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "widgets_easier_plugin.h"

void WidgetsEasierPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  widgets_easier::WidgetsEasierPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
