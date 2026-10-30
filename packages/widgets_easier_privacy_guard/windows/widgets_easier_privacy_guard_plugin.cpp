#include "widgets_easier_privacy_guard_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

// Older SDKs lack the constant; the value is fixed by the Win32 ABI.
#ifndef WDA_EXCLUDEFROMCAPTURE
#define WDA_EXCLUDEFROMCAPTURE 0x00000011
#endif

namespace widgets_easier_privacy_guard {

// static
void WidgetsEasierPrivacyGuardPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "tech.thispage.widgets_easier_privacy_guard",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<WidgetsEasierPrivacyGuardPlugin>(registrar);

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

WidgetsEasierPrivacyGuardPlugin::WidgetsEasierPrivacyGuardPlugin(
    flutter::PluginRegistrarWindows *registrar)
    : registrar_(registrar) {}

WidgetsEasierPrivacyGuardPlugin::~WidgetsEasierPrivacyGuardPlugin() {}

bool WidgetsEasierPrivacyGuardPlugin::SetSecure(bool secure) {
  flutter::FlutterView *view = registrar_->GetView();
  if (view == nullptr) return false;
  HWND window = ::GetAncestor(view->GetNativeWindow(), GA_ROOT);
  if (window == nullptr) return false;
  if (!secure) return ::SetWindowDisplayAffinity(window, WDA_NONE) != 0;
  // WDA_EXCLUDEFROMCAPTURE needs Windows 10 2004. Before that, WDA_MONITOR
  // still blanks the window in captures, just as a black rectangle.
  return ::SetWindowDisplayAffinity(window, WDA_EXCLUDEFROMCAPTURE) != 0 ||
         ::SetWindowDisplayAffinity(window, WDA_MONITOR) != 0;
}

void WidgetsEasierPrivacyGuardPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const std::string &method = method_call.method_name();
  if (method == "setSecure") {
    const auto *secure = std::get_if<bool>(method_call.arguments());
    if (secure == nullptr) {
      result->Error("INVALID_ARGUMENTS", "setSecure expects a bool");
      return;
    }
    if (!SetSecure(*secure)) {
      result->Error("UNAVAILABLE", "SetWindowDisplayAffinity failed");
      return;
    }
    result->Success();
  } else if (method == "getCapabilities") {
    result->Success(flutter::EncodableValue(flutter::EncodableMap{
        {flutter::EncodableValue("preventScreenshot"),
         flutter::EncodableValue(true)},
        {flutter::EncodableValue("hideInRecents"),
         flutter::EncodableValue(false)},
        {flutter::EncodableValue("screenshotDetection"),
         flutter::EncodableValue(false)},
        {flutter::EncodableValue("recordingDetection"),
         flutter::EncodableValue(false)},
        {flutter::EncodableValue("iosSecureLayer"),
         flutter::EncodableValue(false)},
    }));
  } else {
    result->NotImplemented();
  }
}

}  // namespace widgets_easier_privacy_guard
