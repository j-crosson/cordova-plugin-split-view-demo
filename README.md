# cordova-plugin-split-view-demo
Native iOS Split View Demo




## Demo


The easiest way to run the demo is to download (or clone) the repo and run the project in Demo from Xcode. 


The demo by default shows both the web and table view options in a modal view, supporting both light and dark mode. Typically the split view will be the app window's root view. 

To run the demo that simulates a root split view, rename indexRoot.html to index.html. In index.js, un-comment the line indicated in the “root demo” comment.

To demo the Split View as an actual root view, in the file AppDelegate.m comment out the current code and use the code that is currently commented out. A real app would be structured differently: the embedding demo was constructed to fit in a Cordova-generated app.


![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/landsc.png)
![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/portrait.png)


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

