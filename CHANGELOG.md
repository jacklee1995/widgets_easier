## 0.0.1

* initial release.

## 0.0.2 

### Added

#### ButtonGroup

ButtonGroup Widget is a button combination based on **SemanticButton**.

### Changes
- Added custom color and gradient color functionality to **SemanticButton**.
- Added debugging information to **SemanticButton**.
- Added the borderRadius property to **SemanticButton**, which is used to specify a finer border radius than the radius property.

## 0.0.3
### Added

CounterInput, which is a **Flutter** widget for numerical input and adjustment. It provides an intuitive interface that allows users to change the current value by clicking plus and minus buttons or directly inputting numbers.

## 0.0.4

### Changes

A new `width` property has been added to the **SemanticButton** widget, which is used to forcibly limit the width of the component. If a specific value is specified for this property, the `shrink` property will not occupy the entire container width even if it is set to `false`.

### Added

#### FutureDialogs

**FutureDialogs** is a type of promissory dialog that can help handle dialog application scenarios where the content of different dialogs needs to be determined by future results in a very simple way.

#### WinDialogs

**WinDialogs** is a type of dialog that mimics the Windows style.


## 0.0.5

### Changes

Fixes were made to the behavior of the `fit` and `alignment` properties of the Picture class. The constraints using BoxConstraints.expand() for images were removed. The method of size limitation was adjusted, as well as the arrangement within the parent container.

### Added

**NotifyToasts** class, which provides a simple and flexible way to display message notifications in your application. By customizing styles, animation effects and interactions, you can create message notifications that conform to the application design style.


## 0.0.6


### Added 

**TipToasts** class, which is a utility class  used to display temporary notifications or messages in Flutter. It can show custom toast messages at the top, center, or bottom of the screen that automatically disappear after a certain period of time. These types of notifications are commonly referred to as "toast" messages, originating from a similar concept in Android development.