# cordova-plugin-split-view-demo

## Native iOS Split View Demo

Showcases Split View plugin features.

The easiest way to run the demo is to download (or clone) the repo and run the project in Demo from Xcode.

## New in 2.4.4

* Updated embedded demo for Cordova iOS 8.x and later scene-based life cycle. 
* Demo of transparent background option for Webviews. For iOS26 and later Liquid Glass effects.   
* Modified the "Two Column" demo to include a secondary-column background image. In iOS 26 the image covers the entire window, extending beneath the primary column; in iOS 18 (and earlier) the image is limited to the secondary column.  If the image were limited by safe-area constraints, it would behave similarly in both versions of iOS.   

## New in 2.4.3

* Memory leak fix
* A change in a split view behavior that makes the demo perform more consistantly in both iOS 26 and earlier releases. 
* Uses latest versions of Cordova and Xcode 

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

## Demo

The demo shows both new and classic (pre iOS14) view options. 

In this demo, the split views are presented modally, allowing return to the original Webview.  There is an option to make a split view a root view (except classic split view) but that options eliminates the original webview; not useful for this demo. 
To run the demo that simulates a root split view in a standalone classic split view, rename “indexRoot.html” to “index.html”. In "index.js", un-comment one of the lines indicated in the “root demo” comment.


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


There are five Compact Tab Demos:
* Large Titles 
* Large Titles Inset Always 
* Hide Navigation Bar 
* Small Titles, Tiled
* iOS26 Transparent Background 

**Large Titles**
 
 Large Navigation Bar titles for Regular, both large and small titles for Compact.
 
 Insets:  contentInsetAdjustmentBehavior = "never"  (viewport-fit=cover.)
 
 
**Large Titles Inset Alwayss** 

 Large Navigation Bar titles for Regular, both large and small titles for Compact.
 
 Insets: contentInsetAdjustmentBehavior = "always" 
 
 Compare the scroll behavior of this example with "Large Titles"


**Hide Navigation Bar**
 
 No Bars
 

**Small Titles, Tiled**

 Small Navigation Bar titles for Regular and Compact. Also shows a tiled layout.


**iOS26 Transparent Background**

 This layout is only useful for iOS26 and later. 
 
 Version-specific styles would need to be applied to support earlier versions of iOS.  
 
 For the transparent column, set "opaque" to "false" and set a startup background color to match the composite color of the column.
 
 
### Three Column

Demonstrates the "Supplementary" column

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/threeview.png)


### Two Column

Demonstrates a split view with a  Primary and Secondary column

### Native List

![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/collectionViewFull.png)

The UICollectionView List replaces the UITableView for apps targeting iOS14 and above.

There are two size classes: Regular and Compact, which apply to width and height and depend on device size and orientation.  Horizontally Regular you would find on a large device such as an iPad or a large iPhone in landscape, and Horizontally Compact you would find on a smaller device in portrait and landscape, or an iPad running multiple apps in a split screen pre iOS26 or a resized app window post iOS26.  

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

Displays Demo App JSON in a more readable form than Demo source code.    

### Classic Split Views
![ ](https://raw.githubusercontent.com/j-crosson/cordova-plugin-split-view-demo/main/images/landsc.png)


## Embedding Option 


Used to embed plugin in a native app.  Using the Embedding Option with the plugin creates a hybrid app and eliminates the resource usage and the startup delay of creating an extra web view. 

To demo the embedded Split View, in SceneDelegate.swift and ViewController.swift comment out the current code and use the code that is currently commented out.  A real app might be structured differently: the embedding demo was constructed to fit in a Cordova-generated app. 
The demo uses the "useLaunchScreenAsBackground" option as well as a single color background (the "backgroundColor" property).  Set the "useLaunchScreenAsBackground" option to "true" and set the  "showInitialSplashScreen" property to false to prevent a webview showing a splashscreen. 

Here’s the demo code that launches the iOS 14 and later embedded split view:


```swift

//
// Post-iOS 14 multi-column Demo
//

// SceneDelegate.swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let windowsScene = scene as! UIWindowScene
        let window = UIWindow(windowScene: windowsScene)
 
        var splitViewJSON: String = ""
        var primaryViewJSON: String = ""
        var secondaryViewJSON: String = ""
        var supplementaryViewJSON: String = ""
        var compactViewJSON: String = ""

        //RtViewController is the root Split View controller
        //A "launch screen" view is displayed until webview content has been rendered
        //In the non-embedding case, this is still necessary to prevent
        //the initial display jumping/flashing.
        //Each Split View column is handled separately.  A user-controlled notification
        //is under consideration.  This would make handling all columns as a single
        //entity easier.
        //
        //There are three options for the initial RtViewController "launch screen" view:
        //
        // 1) default -- use specified background color as a single-color view
        // 2) useLaunchScreenAsBackground = true -- use launch storyboard
        // 3) showInitialSplashScreen = false
        //    The column will not show an initial screen.  Useful if you want
        //    to do other things like a single launch screen.
        //
        //  This demo uses the launch storyboard for the primary column in
        //  a compact environment (the case on most phones or a small window on an iPad)
        //  where the primary column is displayed on startup.
        //
        //  In a regular environment, the secondary column uses  the launch storyboard while the
        //  primary uses the background color.
        
        var useLaunchScreenOnPrimary = "false"
        var useLaunchScreenOnSecondary = "true"
        if windowsScene.traitCollection.horizontalSizeClass == .compact {
            useLaunchScreenOnPrimary = "true"
            useLaunchScreenOnSecondary = "false"
            }
        
        primaryViewJSON = "{\"useLaunchScreenAsBackground\":" + useLaunchScreenOnPrimary + ", \"barButtonRight\":{\"type\":\"text\",\"title\":\"Tap Me\",\"identifier\": \"rightTap\"},\"navBarAppearance\":{\"prefersLargeTitles\":true}}"
        
        secondaryViewJSON = "{\"useLaunchScreenAsBackground\":" + useLaunchScreenOnSecondary + ", \"navBarAppearance\":{\"prefersLargeTitles\":true}}"
        
        splitViewJSON = "{\"isEmbedded\":true,\"primaryTitle\":\"Primary\",\"primaryURL\":\"doublePrimaryEmbed.html\",\"topColumnForCollapsingToProposedTopColumn\":\"primary\",\"preferredSplitBehavior\":\"tile\",\"primaryEdge\":\"leading\", \"secondaryTitle\":\"Secondary\",\"secondaryURL\":\"doubleSecondary.html\", \"style\":\"doubleColumn\",\"backgroundColorLight\":[228,228,228,1],\"backgroundColorDark\":[30,30,30,1], \"preferredDisplayMode\":\"oneBesideSecondary\"}"
        
        var viewsProperties =  [String?]()
        viewsProperties.append(splitViewJSON)
        viewsProperties.append(primaryViewJSON)
        viewsProperties.append(secondaryViewJSON)
        viewsProperties.append(supplementaryViewJSON)
        viewsProperties.append(compactViewJSON)

        let splitViewController = RtViewController( viewProperties: viewsProperties)
        window.rootViewController = splitViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

// ViewController.swift

class ViewController: RtViewController {
}

```


