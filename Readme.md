# WORKBENCH

This project is a collection of good to have tricks'n'tips and useful Xcode/Swift snippets. The framework-like parts are organised in the `Dynamo` group and should be easily copied to a new project. Remember to add `#import "Dynamo-Bridging.h"` to any bridging header in a new project.

The project contains the CodeSteps utility and a CodeSteps file that contains a number of code bookmarks.

The CodeSteps utility is in the `codesteps` folder. But you can also download the latest version from [here](https://github.com/dynamomobile/Workbench-iOS/raw/master/codesteps/CodeSteps_1.0_13.zip). It is also described here http://dyna.mo/bookmarking-tool-for-code/

## Misc

Various parts make use of a couple general convinient helpers.

* `Debug.info(..)`, Log messages that can be disabled from `AppConfig.swift`
* `String.lookup(string: ..)`, Strings loaded from `Strings.json`
* `Float.constantBy(name: ..)`, Constants loaded from `Floats.json`
* Logging on `deinit { .. }` to see correct cleanups

## Classes

* AnimatedCheckmarkView, can be used to make other animated symbols
* ResponseButton, alternative UIButton that will show border response on touches
* SlideSegue, 4 way slide segues

## LaunchScreen

LaunchScreen will fade into Main screen after initial loading. See `AppDelegate`

## Design fields

In various places are IB Design fields in use.

* `Design`, colors
* `Design Title`, text on buttons, labels and text fields
* `Design Placeholder`, placeholder text for Text Fields
* `Border Width`, enable UIView borders
* `Border Color`, border color
* `Rounded Corner Radius`, radius of border

Strings and Floats lookup are also used for `Design Title`, `Border Width` and `Rounded Corner Radius`.

## Download

The download demo show a couple of different things.

* NetworkOperation, a OperationQueue based network class
* AnimatedCheckmarkView

## Context

The Context demo show a lean way to populate UI things like UILabel

The Context concept is a way to attach data on UIView elements and the IB Context field. The Context works like a dictionay. Accessing entries are handled through the Context field in IB. Things to notice in the code, setting context data with `view.setFullContext([])`. Also have a look at the 'Context' field in IB.

This part also make use of a simplified JSON parsing. See `data?.JSON()` (and `Data.JSON([])`)

## Associated

The Associated demo show a simplified API for so called associated objects. This implementation access a single dictionary that in turn can hold and easily access more data entries .

## State Machine

Yet another State Machine class. Demo also generates a `dot` file which can be used to create a PDF of the state machine to be able to look at it. The demo is a simple 3 state SM with 3 events (here emitted by buttons).

## QR Test

QR Test is a small demo of using a simple html5 based QR code generator to supply ie. test or debug data into an app. Open the `qrtest/index.html` in a browser and point the iPhone standard camera at the QR Code. The Workbench app should open and the values should have been supplied. Colors can be either hexadecimal like `00ff00` or ie. a name like `blue`. The string field respond to `big` and `small`. Fast is the speed of the ball in the QR Test screen. The QR Test screen only updates when opening so if it is aleady opened, close and open again to apply any changes.

_The word **QR Code** is registered trademark of DENSO WAVE INCORPORATED [FAQ](http://www.denso-wave.com/qrcode/faqpatent-e.html)_

## CSV

CSV is a small demo of using a Google Sheet to supply some data for the app. There is also a second usage of a Google Sheet supplied CSV file. Actually the second tab from the same sheet, which is used at compile time in a build phase step.

## Callout

Callout is a small demo showing information callouts for the things on a page. The are created via a Callout propety in InterfaceBuilder. The field should contain a string with two part seperated by a colon. Before the colon there can be an id token which is used to track which callouts has already been presented. After the colon there can be the string, or a string lookup key to be used as the callout text.
