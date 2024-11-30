# cordova-plugin-split-view-demo

## Native iOS Split View Demo

Showcases Split View plugin features.

The easiest way to run the demo is to download (or clone) the repo and run the project in Demo from Xcode. 


The demo shows both new and classic view options in a modal view, supporting both light and dark mode. Typically a split view will be the app window's root view but a modal view allows all options to be presented in the demo without restart. 

There is an option to make the split view a root view but this does not apply to the classic split view. An alternative option is to make the modal view full screen.  This option is used for the post-iOS14 demos. 
To run the demo that simulates a root split view in classic split view, rename “indexRoot.html” to “index.html”. In "index.js", un-comment one of the lines indicated in the “root demo” comment.

## New in 2.4.2
* iOS 7 & 8 fixes

A more flexible demo is in the future, but for now the demo likes to live in Documents/workspace  

## New in 2.4
* New inset options
* Hide-Navigation-Bar option
* New TabBar options

## New in 2.3
* Collection View List (replaces classic-view TableView option)

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/collectionViewFull.png)

## New in 2.2
* Large Navigation Bar Titles in Primary View
* Navigation Bar for Tab View
* Tab Bar Appearance options
* Scrollbar  options
* iOS 15 Appearance updates

## New in 2.1
* Navigation Bar buttons and context menus. 
* Additional Tab-Bar options, updated interface

The Two Column option demos System-Item buttons in the primary view and buttons with context menu in the secondary view. 
The Tab Bar System-Item option can be demoed by switching out commented-out code in index.js.


### Demos
![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/demoselections.png)

The first five options are for apps targeting iOS14 and above; the two "Classic" options are for apps targeting earlier versions of iOS.

### Compact Tab

There are two size classes: Regular and Compact, which apply to width and height and depend on device size and orientation.  Horizontally Regular you would find on a large device such as an iPad or a large iPhone in landscape, and Horizontally Compact you would find on a smaller device in portrait and landscape, or an iPad running multiple apps in a split screen.  

The plug-in has the option of using a TabView for the Compact Size. The view will dynamically switch to/from a split view as the size class changes.  For example, when a large iPhone is rotated from portrait to landscape or when a second app shares the screen on an iPad. 


**Regular size**

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view/main/images/regulariPad.png)

**Compact size**

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view/main/images/compactiPad.png)


### Compact Tab Demo


There are four Compact Tab Demos:
* Large Titles 
* Large Titles Inset Always 
* Hide Navigation Bar 
* Small Titles 

**Large Titles**
 
 Large Navigation Bar titles for Regular, both large and small titles for Compact.
 
 Insets:  contentInsetAdjustmentBehavior = "never"  (viewport-fit=cover.)
 
 
**Large Titles Inset Alwayss** 

 Large Navigation Bar titles for Regular, both large and small titles for Compact.
 
 Insets: contentInsetAdjustmentBehavior = "always" 
 
 Compare the scroll behavior of this example with "Large Titles"


**Hide Navigation Bar**
 
 No Bars
 

**Small Titles**

 Small Navigation Bar titles for Regular and Compact.



### Three Column

Demonstrates the "Supplementary" column

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/threeview.png)


### Two Column

Demonstrates a split view with a  Primary and Secondary column

### Native List

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/collectionViewFull.png)

The UICollectionView List replaces the UITableView for apps targeting iOS14 and above.

There are two size classes: Regular and Compact, which apply to width and height and depend on device size and orientation.  Horizontally Regular you would find on a large device such as an iPad or a large iPhone in landscape, and Horizontally Compact you would find on a smaller device in portrait and landscape, or an iPad running multiple apps in a split screen.  

**Regular Size**

In this Demo for the Regular size class there are two columns: the primary is a Native List (UICollectionView), the secondary a webView. The menu demonstrates selecting list items in the primary view from the secondary webView.  

| Menu Selection | Action |
| --- | --- | 
| none |  Selects "Listen Now" without scrolling. | 
| bottom | Selects "Playlist 4", scrolls to bottom. | 
| top | Selects  "Playlist 7", scrolls to top. | 
| centered | Selects  "Playlist 8", centers selection. | 
| Exit | Returns to main menu. | 


If a section is collapsed, the section will be expanded before selecting an item.

**Compact Size**

The Compact display is a three-tab tabView.  The tabs are synced to the Native List:  selections are preserved when switching back and forth.

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/collectionViewSplit.png)


**View JSON**

Displays Demo App JSON in a more readable form than Demo source code.  This demo option uses some features that will appear in the next version of the plugin in somewhat different form:  this demo option isn't supported by the current plugin.   

### Classic Split Views
![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/landsc.png)


## Embedding Option 


Used to embed plugin in a native app.  Using the Embedding Option with the plugin creates a hybrid app and eliminates the startup delay of creating an extra web view. 

To demo the embedded Split View, in AppDelegate.m comment out the current code and use the code that is currently commented out.  Post-iOS 14 multi-column Demo for the new stuff, Classic for the old.   A real app would be structured differently: the embedding demo was constructed to fit in a Cordova-generated app. 

Here’s the demo code that launches the iOS 14 embedded split view:


```objective-c


//
// Post-iOS 14 multi-column Demo
//
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

    EmbedSplitColumn * es = [[EmbedSplitColumn alloc] init];
     
    es.splitViewJson = @"{\"isEmbedded\":true,\"primaryTitle\":\"Primary\",\"primaryURL\":\"indexTriple.html\",\"topColumnForCollapsingToProposedTopColumn\":\"primary\", \"secondaryTitle\":\"Secondary\",\"secondaryURL\":\"indexTriple2.html\", \"Style\":\"tripleColumn\",\"backgroundColorLight\":[228,228,228,1],\"backgroundColorDark\":[30,30,30,1], \"showsSecondaryOnlyButton\":true,\"preferredDisplayMode\":\"twoBesideSecondary\",\"supplementaryTitle\":\"Supplementary\"}";
    [es showView:self.window ];
    
    return YES;
}

@end

```

