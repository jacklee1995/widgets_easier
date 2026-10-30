# widgets_easier_privacy_guard_example

A page of fake card details wrapped in `PrivacyGuard`.

```sh
flutter run
```

Two things to try:

1. Send the app to the background. The content blurs, and the blur also covers
   the preview in the task switcher.
2. Take a screenshot. On Android it is blocked while the switch is on. On iOS
   the switch is disabled, because the platform has no public API for it.
