//
//  Embed.swift
//
//  Created by jerry on 4/27/21.
//

import Foundation

@objcMembers public class EmbedSplitColumn: NSObject {
    var splitViewJSON: String = ""
    var primaryViewJSON: String = ""
    var secondaryViewJSON: String = ""
    var supplementaryViewJSON: String = ""
    var compactViewJSON: String = ""

    @objc(showView:)
    func showView(_ appWindow: UIWindow) {
        var viewsProperties =  [String?]()
        viewsProperties.append(splitViewJSON)
        viewsProperties.append(primaryViewJSON)
        viewsProperties.append(secondaryViewJSON)
        viewsProperties.append(supplementaryViewJSON)
        viewsProperties.append(compactViewJSON)

        if #available(iOS 14.0, *) {
        let splitViewController = RtViewController( viewProperties: viewsProperties)
        appWindow.rootViewController = splitViewController
        appWindow.makeKeyAndVisible()
        }
    }

}

//
//  Embed Classic SplitView in native app
//
@objcMembers public class EmbedSplit: NSObject {

    private var initialProperties = InitialProperties()
    //
    // properties that work with objective-c; same behavior in swift.
    //
    var primaryURL: String {
        get {
            return initialProperties.masterURL
        }
        set(primary) {
            initialProperties.masterURL = primary
        }
    }
    var secondaryURL: String {
        get {
            return initialProperties.detailURL
        }
        set(secondary) {
            initialProperties.detailURL = secondary
        }
    }
    var primaryTitle: String {
        get {
            return initialProperties.masterTitle ?? ""
        }
        set(primary) {
            initialProperties.masterTitle = primary
        }
    }
    var secondaryTitle: String {
        get {
            return initialProperties.detailTitle ?? ""
        }
        set(secondary) {
            initialProperties.detailTitle = secondary
        }
    }
    var leftButtonTitle: String {
        get {
            return initialProperties.leftButtonTitle ?? ""
        }
        set(title) {
            initialProperties.leftButtonTitle = title
        }
    }
    var rightButtonTitle: String {
        get {
            return initialProperties.rightButtonTitle ?? ""
        }
        set(title) {
            initialProperties.rightButtonTitle = title
        }
    }
    var primaryColumnWidthfraction: CGFloat {
        get {
            return initialProperties.primaryColumnWidthfraction ?? 0
        }
        set(width) {
            initialProperties.primaryColumnWidthfraction = width
        }
    }
    var minimumPrimaryColumnWidth: CGFloat {
        get {
            return initialProperties.minimumPrimaryColumnWidth ?? 0
        }
        set(width) {
            initialProperties.minimumPrimaryColumnWidth = width
        }
    }
    var maximumPrimaryColumnWidth: CGFloat {
        get {
            return initialProperties.maximumPrimaryColumnWidth ?? 0
        }
        set(width) {
            initialProperties.maximumPrimaryColumnWidth = width
        }
    }
    var showDisplayModeButtonItem: Bool {
        get {
            return initialProperties.displayModeButtonItem
        }
        set(show) {
            initialProperties.displayModeButtonItem = show
        }
    }

    //there could be a second-view flash if light/dark mode is changed before second view shown
    func setPrimaryBackgroundColor(_ light: UIColor, _ dark: UIColor) {
        var initialBackground = light
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                initialBackground = dark
            }
        }
        initialProperties.masterBackgroundColor = initialBackground
    }
    func setSecondaryBackgroundColor(_ light: UIColor, _ dark: UIColor) {
        var initialBackground = light
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                initialBackground = dark
            }
        }
        initialProperties.detailBackgroundColor = initialBackground
    }

    @objc(show:)
    func show(_ appWindow: UIWindow) {
     //   var viewsProperties =  [String?]()
        initialProperties.isEmbedded = true
        let splitViewController = RtViewControllerClassic(iprop: initialProperties)
        appWindow.rootViewController = splitViewController
        appWindow.makeKeyAndVisible()
    }
}
