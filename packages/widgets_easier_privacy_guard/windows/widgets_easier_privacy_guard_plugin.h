#ifndef FLUTTER_PLUGIN_WIDGETS_EASIER_PRIVACY_GUARD_PLUGIN_H_
#define FLUTTER_PLUGIN_WIDGETS_EASIER_PRIVACY_GUARD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace widgets_easier_privacy_guard {

// Keeps the Flutter window out of screenshots, recordings and screen sharing
// with SetWindowDisplayAffinity.
class WidgetsEasierPrivacyGuardPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  explicit WidgetsEasierPrivacyGuardPlugin(
      flutter::PluginRegistrarWindows *registrar);

  virtual ~WidgetsEasierPrivacyGuardPlugin();

  WidgetsEasierPrivacyGuardPlugin(const WidgetsEasierPrivacyGuardPlugin &) =
      delete;
  WidgetsEasierPrivacyGuardPlugin &operator=(
      const WidgetsEasierPrivacyGuardPlugin &) = delete;

  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  // Returns false when there is no window yet or the call failed.
  bool SetSecure(bool secure);

  flutter::PluginRegistrarWindows *registrar_;
};

}  // namespace widgets_easier_privacy_guard

#endif  // FLUTTER_PLUGIN_WIDGETS_EASIER_PRIVACY_GUARD_PLUGIN_H_
