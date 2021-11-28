# cordova-plugin-split-view-demo

## Native iOS Split View Demo

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/demoselections.png)

The easiest way to run the demo is to download (or clone) the repo and run the project in Demo from Xcode. 


The demo shows both new and classic view options in a modal view, supporting both light and dark mode. Typically a split view will be the app window's root view but a modal view allows all options to be presented in the demo without restart. 

There is now an option to make the split view a root view but this does not apply to the classic split view.
To run the demo that simulates a root split view in classic split view, rename “indexRoot.html” to “index.html”. In "index.js", un-comment one of the lines indicated in the “root demo” comment.

## New in 2.1
* Navigation Bar buttons and context menus. 
* Additional Tab-Bar options, updated interface

The Two Column option demos System-Item buttons in the primary view and buttons with context menu in the secondary view. 
The Tab Bar System-Item option can be demoed by switching out commented-out code in index.js.



### Compact Tab
**Regular size**

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view/main/images/regulariPad.png)

**Compact size**

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view/main/images/compactiPad.png)


### Classic Split Views
![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/landsc.png)
![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/threeview.png)



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

