/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
*/


import Cordova

class SceneDelegate: CDVSceneDelegate {
}



 // To demonstrate "embedding", comment out the preceeding code and replace with the following code.
 // You will also need to modify "ViewController.swift" as instructed in that file.
 //
 // This demo creates a two column split view framing two webviews.  Embedding eliminates the startup
 // time and extra resources consumed by creating an extra web view.

/*

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

*/
