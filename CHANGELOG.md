# CHANGELOG

## [0.0.10] - 2023-10-03

### Added

- `PrivacyGuard` component to enhance privacy features within the app.
  - Automatically enables a privacy screen when the app goes into the background.
  - Provides blur effects (`blurRadius` and `blurColor`) to obscure the app's content when in privacy mode.
  - Supports disabling screenshot and recording functionalities with optional callbacks (`onScreenshot` and `onRecordingAttempt`) when such actions are attempted.
  - Callbacks for entering (`onEnterPrivacyMode`) and exiting (`onExitPrivacyMode`) privacy mode.
  - Configurable options to prevent screenshots and recordings, enhancing security and privacy compliance.

## 0.0.9

### Added

- Introduced `CascadeBottomSheet` to handle multi-level cascading menus dynamically based on the depth of the provided data.
- Added `showCascadeSheet` method in `BottomSheets` class to display cascading selection sheets.
- Implemented dynamic scroll controllers and selection lists in `CascadeBottomSheet` to support variable depth of data without causing range errors.

### Updated

- Enhanced `BottomSheets` class with additional methods `showInfoSheet` and `showConfirmSheet` for displaying informational and confirmation dialogs respectively.
- Each method now supports customization of text, colors, padding, margins, and dismissibility.
- Added error handling for depth calculations in cascading menus to prevent out-of-range access.

### Fixed

- Fixed an issue where `CascadeBottomSheet` would throw a `RangeError` when the data exceeded four levels of depth by dynamically adjusting the number of scroll controllers and selection lists based on the maximum depth of the data.

### UI Improvements

- Updated UI components in `ConfirmBottomSheet` and `IofoBottomSheet` to include optional images, customizable button texts, and improved layout handling.
- Enhanced visual feedback in `CascadeBottomSheet` with better alignment and color distinction between selected and unselected items.

### Performance

- Optimized the initialization process for `CascadeBottomSheet` to reduce setup time by calculating the maximum depth once during the initial state setup.

### Documentation

- Updated documentation and inline comments for better clarity on how the new dynamic depth handling works in `CascadeBottomSheet`.

## 0.0.8

### Added

**Tag** class, which is a Widget class designed for labeling and selection purposes. It features a `type` attribute that allows users to choose the type of tag they want to use.

## 0.0.7

Bugs Fixed.

## 0.0.6

### Added

**TipToasts** class, which is a utility class used to display temporary notifications or messages in Flutter. It can show custom toast messages at the top, center, or bottom of the screen that automatically disappear after a certain period of time. These types of notifications are commonly referred to as "toast" messages, originating from a similar concept in Android development.

## 0.0.5

### Changes

Fixes were made to the behavior of the `fit` and `alignment` properties of the Picture class. The constraints using BoxConstraints.expand() for images were removed. The method of size limitation was adjusted, as well as the arrangement within the parent container.

### Added

**NotifyToasts** class, which provides a simple and flexible way to display message notifications in your application. By customizing styles, animation effects and interactions, you can create message notifications that conform to the application design style.

## 0.0.4

### Changes

A new `width` property has been added to the **SemanticButton** widget, which is used to forcibly limit the width of the component. If a specific value is specified for this property, the `shrink` property will not occupy the entire container width even if it is set to `false`.

### Added

#### FutureDialogs

**FutureDialogs** is a type of promissory dialog that can help handle dialog application scenarios where the content of different dialogs needs to be determined by future results in a very simple way.

#### WinDialogs

**WinDialogs** is a type of dialog that mimics the Windows style.

## 0.0.3

### Added

CounterInput, which is a **Flutter** widget for numerical input and adjustment. It provides an intuitive interface that allows users to change the current value by clicking plus and minus buttons or directly inputting numbers.

## 0.0.2

### Added

#### ButtonGroup

ButtonGroup Widget is a button combination based on **SemanticButton**.

### Changes

- Added custom color and gradient color functionality to **SemanticButton**.
- Added debugging information to **SemanticButton**.
- Added the borderRadius property to **SemanticButton**, which is used to specify a finer border radius than the radius property.

## 0.0.1

- initial release.
