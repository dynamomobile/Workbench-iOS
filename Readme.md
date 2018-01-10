# WORKBENCH

This project is a collection of good to have tricks'n'tips and useful Xcode/Swift snippets. The framework-like parts are organised in the `Dynamo` group and should be easily copied to a new project. Remember to add `#import "Dynamo-Bridging.h"` to any bridging header in a new project.

## Misc

Various parts make use of a couple general convinient helpers.

* `Debug.info(..)`, Log messages that can be disabled from `AppConfig.swift`
* `String.lookup(string: ..)`, Strings loaded from `Strings.json`
* `Float.constantBy(name: ..)`, Constants loaded from `Floats.json`
* Logging on `deinit { .. }` to see correct cleanups

## Classes

• AnimatedCheckmarkView, can be used to make other animated symbols
• ResponseButton, alternative UIButton that will show border response on touches
• SlideSegue, 4 way slide segues

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

The Context concept is a way to attach data on UIView elements and the IB Context field. The Context works like a dictionay. Accessing entries are handled through the Context field in IB. Things to notice in the code, setting context data with `view.setFullContext([])`, call of `view.updateContext()` in `viewDidLoad()` that updates all context entries in the view hierarchy. Also have a look at the 'Context' field in IB.

This part also make use of a simplified JSON parsing. See `data?.JSON()` (and `Data.JSON([])`)

## Associated

The Associated demo show a simplified API for so called associated objects. This implementation access a single dictionary that in turn can hold and easily access more data entries .

## State Machine

Work in progress. Should add some UI elements etc to show it working, maybe even add a download sequence state machine.