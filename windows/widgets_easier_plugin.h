#ifndef FLUTTER_PLUGIN_WIDGETS_EASIER_PLUGIN_H_
#define FLUTTER_PLUGIN_WIDGETS_EASIER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace widgets_easier {

class WidgetsEasierPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WidgetsEasierPlugin();

  virtual ~WidgetsEasierPlugin();

  // Disallow copy and assign.
  WidgetsEasierPlugin(const WidgetsEasierPlugin&) = delete;
  WidgetsEasierPlugin& operator=(const WidgetsEasierPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace widgets_easier

#endif  // FLUTTER_PLUGIN_WIDGETS_EASIER_PLUGIN_H_
