# cordova-plugin-split-view
Native iOS Split View


Shows two WebViews (or an optional primary table view) framed as an iOS split view.  
A classic split view consists of two related views:  a primary view and a secondary view.  The views can be displayed as columns if screen real estate permits.

The plugin can simulate a Split View as root view or using the “embedding” option present the Split View as a true root view.

The [`Demo` App ](#Demo) shows the available plugin options, as well as using the plugin "embedded" (Native app with a Cordova-enabled WebView component.)

Future versions will support layout options introduced in iOS 14.


![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view/images/landsc.png)
![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view/images/portrait.png)


## Parent view methods


### show
```javascript
cordova.plugins.SplitView.show(primaryURL, secondaryURL, success, error)
```

Show modal split view

Set attributes before calling.  


| Param | Type | Description |
| --- | --- | --- |
| primaryURL | String | URL for primary view.  Default is index1.html |
| secondaryURL | String | URL for secondary view.  Default is index1.html |
| onSuccess | Function | Success callback function|
| error | Function | Error callback |


### initSplitView
```javascript
cordova.plugins.SplitView.initSplitView()
```

Initialize split view

Must be called at least once before “show”.  Sets attributes to defaults.  

## Primary view methods


### primaryItemSelected
```javascript
cordova.plugins.SplitView.primaryItemSelected(itemString)
```

Notifies Secondary View of action in Primary View

| Param | Type | Description |
| --- | --- | --- |
| itemString | String | Notification data for secondary view |


## Secondary view methods

### initSecondary
```javascript
cordova.plugins.SplitView.initSecondary(itemString)
```

Typically called  immediately after "device ready”. Call when ready to receive messages from Primary view.



### sendResults
```javascript
cordova.plugins.SplitView.sendResults(resultsString)
```

Return results to Parent View


| Param | Type | Description |
| --- | --- | --- |
| resultsString | String | Returned results |



## Properties


| Property | Type | Default |
| --- | --- | --- |
| primaryTitle | string |   |
| secondaryTitle | string |   |
| leftButtonTitle | string |   |
| rightButtonTitle | string |   |
| useTableView | bool | false |
| displayModeButtonItem | bool | true |
| fullscreen | bool | false |
| preferredPrimaryColumnWidthFraction | number | automaticDimension |
| minimumPrimaryColumnWidth | number | automaticDimension |
| maximumPrimaryColumnWidth | number | automaticDimension |
| closed | function |   |
| selected | function |   |


<strong>primaryTitle</strong>

Set  primary view NavigationBar title

```javascript
cordova.plugins.SplitView.primaryTitle = "Primary";
```

<strong>secondaryTitle</strong>

Set  secondary view NavigationBar title

```javascript
cordova.plugins.SplitView.secondaryTitle = "Secondary";
```

<strong>leftButtonTitle</strong>

Sets primary view NavigationBar left button title. If a title is not provided, the button is not shown

```javascript
cordova.plugins.SplitView.leftButtonTitle = “Left”;
```

<strong>rightButtonTitle</strong>

Sets primary view NavigationBar right button title. If a title is not provided, the button is not shown

 ```javascript
 cordova.plugins.SplitView.rightButtonTitle = “Right”;
```

<strong>useTableView</strong>

Use Table View as Primary view (true) or WebView (false)
Default is WebView

```javascript
cordova.plugins.SplitView.useTableView = true;
```

<strong>displayModeButtonItem</strong>

Changes display mode.  See Apple UISplitViewController Documentation for additional details.

```javascript
cordova.plugins.SplitView.displayModeButtonItem= false;
```

<strong>fullscreen</strong>

Changes presentation style of split view to full screen.   

Set this to make the split view full screen.  This is necessary to simulate a root view. 

```javascript
cordova.plugins.SplitView.fullscreen= true;
```

The Width properties are handled automatically by iOS unless overridden by the following properties:

<strong>preferredPrimaryColumnWidthFraction</strong>

Preferred relative width of the primary view.   Number between 0.0 and 1.0   Percentage of the overall width of the split view.
See Apple UISplitViewController Documentation for additional details.

```javascript
cordova.plugins.SplitView.preferredPrimaryColumnWidthFraction= 0.5;
```


<strong>minimumPrimaryColumnWidth</strong>

Sets min width, in points, of the primary view. See Apple UISplitViewController Documentation for additional details.

```javascript
cordova.plugins.SplitView.minimumPrimaryColumnWidth = 100.0
```

<strong>maximumPrimaryColumnWidth</strong>

Sets max width, in points, of the primary view . See Apple Documentation for UISplitViewController.

```javascript
cordova.plugins.SplitView.maximumPrimaryColumnWidth = 100.0
```

<strong>closed</strong>

 function ( results,status)

| Param | Type | Description |
| --- | --- | --- |
| results | String |results returned on close|
| status | enum | results status |

### results
String sent by “sendResults” in secondary view.

### status
SplitView.dismissType.swipe         Dismissed by swipe
SplitView.dismissType.left             Dismissed by left button
SplitView.dismissType.right           Dismissed by right button

Only available in parent view.

```javascript
var onViewClosed = function ( results,status) {
	if(status == cordova.plugins.SplitView.dismissType.left) {
		//do something
	}
}

cordova.plugins.SplitView.closed = onViewClosed;
```

<strong>selected</strong>

 function ( itemString)

| Param | Type | Description |
| --- | --- | --- |
| itemString | String | selection string |

### itemString
String sent in primary view by “primaryItemSelected”. Typically reflects an item selection but could be any action.

Only available in secondary view.

```javascript
var onSelected = function ( itemString) {
	//do something
}

cordova.plugins.SplitView.selected= onSelected;
```

### barTintColor
```javascript
cordova.plugins.SplitView.barTintColor(red,green,blue)
```

Sets Navigation Bar bar tint color (bar background) 
See Apple Docs for additional details.

| Param | Type | Description |
| --- | --- | --- |
| red | Number | red 0-255 |
| green | Number | green 0-255 |
| blue | Number | blue 0-255 |



### tintColor
```javascript
cordova.plugins.SplitView.tintColor(red,green,blue)
```

Sets Navigation Bar  tint color (bar text etc.) 
See Apple Docs for additional details.

| Param | Type | Description |
| --- | --- | --- |
| red | Number | red 0-255 |
| green | Number | green 0-255 |
| blue | Number | blue 0-255 |


### primaryBackgroundColor
```javascript
cordova.plugins.SplitView.primaryBackgroundColor(red,green,blue)
```

Sets primary view background color

| Param | Type | Description |
| --- | --- | --- |
| red | Number | red 0-255 |
| green | Number | green 0-255 |
| blue | Number | blue 0-255 |


### secondaryBackgroundColor
```javascript
cordova.plugins.SplitView.secondaryBackgroundColor(red,green,blue)
```

Sets secondary view background color

| Param | Type | Description |
| --- | --- | --- |
| red | Number | red 0-255 |
| green | Number | green 0-255 |
| blue | Number | blue 0-255 |



## Embedding Option


Present the split view as a true root view.  Using the embedded option with the plugin eliminates the startup delay of creating an extra web view. 
Embedded split view only supports a two-webview split view.  The tableview option is not supported.  

```swift
func show(_ appWindow: UIWindow)
```
Summary

shows Split View  Controller as root view controller  of appWindow

Parameters: 	appWindow    application window for split view


In the non-embedded  version,  the initial background colors of the primary and secondary views, the colors briefly displayed during WebView load,  are set by the parent WebView/Media Query.  Since the embedded case doesn’t have a parent WebView, the plugin determines light/dark mode and chooses the supplied light or dark color.  Versions of iOS that don’t support dark mode will default to light. 

```swift
func setPrimaryBackgroundColor(_ light: UIColor, _ dark: UIColor) 
```
Summary
	sets primary view background color that is displayed during WebView load. 

Parameters
	light  background color in light mode
	dark  background color in dark mode

 func setSecondaryBackgroundColor(_ light: UIColor, _ dark: UIColor)

Summary
	sets secondary background color that is displayed during WebView load. 

Parameters
	light  background color in light mode
	dark  background color in dark mode


### Properties

**primaryURL**

URL of Primary View content.

```swift
var primaryURL: String
```

  The default is “index1.html”

```swift
    embedSplit.primaryURL = @"index1.html”;   //objective-c
    embedSplit.primaryURL= "index1.html"      // swift
```
  
**secondaryURL**

URL of Primary View content.

```swift
 var secondaryURL: String
```

The default is “index2.html”

```swift
    embedSplit.secondaryURL = @"index2.html”;   //objective-c
    embedSplit.secondaryURL= "index2.html"      // swift
```

**primaryTitle**

Title of primary view.

```swift
 var primaryTitle: String
```

```swift
    embedSplit.primaryTitle = @"Primary";   //objective-c
    embedSplit.primaryTitle = "Primary"     // swift
```

**secondaryTitle**

Title of secondary view.

```swift
var secondaryTitle: String
```

```swift
    embedSplit.secondaryTitle = @"Secondary";   //objective-c
    embedSplit.secondaryTitle = "Secondary"     // swift
```

**leftButtonTitle**

Title of left button.
If a title is not provided, the button is not shown.

```swift
var leftButtonTitle: String
```

```swift
    embedSplit.leftButtonTitle = @“Left”;   //objective-c
    embedSplit.leftButtonTitle = “Left”     // swift
```

**rightButtonTitle**

Title of right button.
If a title is not provided, the button is not shown.

```swift
var rightButtonTitle: String
```

```swift
    embedSplit.rightButtonTitle = @“Right”;   //objective-c
    embedSplit.rightButtonTitle = “Right”     // swift
```

The Width properties are handled automatically by iOS unless overridden by the following properties:
***

**primaryColumnWidthfraction**

```swift
var primaryColumnWidthfraction: CGFloat 
```

Preferred relative width of the primary view controller’s content
See Apple’s docs for details

```swift
    embedSplit.primaryColumnWidthfraction = 0.5;   //objective-c
    embedSplit.primaryColumnWidthfraction = 0.5    // swift
```

**minimumPrimaryColumnWidth**

```swift
var minimumPrimaryColumnWidth: CGFloat 
```

In points, the minimum width for the primary view controller’s content
See Apple’s docs for details

```swift
    embedSplit.minimumPrimaryColumnWidth = 200.0;   //objective-c
    embedSplit.minimumPrimaryColumnWidth = 200.0    // swift
```

**maximumPrimaryColumnWidth**

```swift
var maximumPrimaryColumnWidth: CGFloat
```

In points, the maximum width for the primary view controller’s content
See Apple’s docs for details

 ```swift
     embedSplit.maximumPrimaryColumnWidth = 200.0;   //objective-c
     embedSplit.maximumPrimaryColumnWidth = 200.0    // swift
 ```

***

**showDisplayModeButtonItem**

```swift
var showDisplayModeButtonItem: Bool
```

Show button that changes the split view controller display mode 

Default is TRUE

```swift
    embedSplit.showDisplayModeButtonItem = false;   //objective-c
    embedSplit.showDisplayModeButtonItem = false		// swift
```

## Demo

- https://github.com/j-crosson/cordova-plugin-split-view/Demo

The easiest way to run the demo is to download (or clone) the entire repo and run the project in Demo from Xcode. 


The demo by default shows both the web and table view options in a modal view, supporting both light and dark mode. Typically the split view will be a root view. 

To run the demo that simulates a root split view, rename indexRoot.html to index.html. In index.js, un-comment the line indicated in the “root demo” comment.

To demo the Split View as an actual root view, in the file AppDelegate.m comment out the current code and use the code that is currently commented out.


Here’s the Demo code that launches the embedded split view:


```objective-c

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SplitDemo-Swift.h"

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.autoresizesSubviews = YES;

    EmbedSplit * es = [[EmbedSplit alloc] init];
    UIColor *colorLight = [UIColor colorWithRed:0.894 green:0.894 blue:0.894 alpha:1];
    UIColor *colorDark = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
    [es setPrimaryBackgroundColor:colorLight :colorDark];
    [es setSecondaryBackgroundColor:colorLight :colorDark];
    es.primaryTitle = @"Primary";
    es.secondaryTitle = @"Secondary";
    [es show:self.window ];
    
    return YES;
}

@end
```

