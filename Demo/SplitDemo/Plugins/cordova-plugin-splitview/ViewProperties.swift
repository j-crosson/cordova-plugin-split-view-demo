//
//  ViewProperties.swift
//
//  Created by jerry on 5/18/22.
//

import Foundation
struct ViewProps {
    var viewProps =  ViewProperties()
    var lastError: String = "no error"
    mutating func decodeProperties(json: String) -> Bool {
        guard let jsonData = json.data(using: .utf8) else {
            lastError = "malformed"
            return false
        }
        do {
            viewProps = try JSONDecoder().decode(ViewProperties.self, from: jsonData)
            return true
        } catch {
            lastError = "decode failed"
            return false
       }
    }

    func setColor(_ color: [CGFloat?]?) -> UIColor? {
        guard color?.count == 4 else {
         return nil
        }
        guard let rrr = color?[0], let ggg=color?[1], let bbb=color?[2], let aaa=color?[3] else {
               return nil
           }
        return UIColor(red: rrr/255, green: ggg/255, blue: bbb/255, alpha: aaa)
    }

    var backgroundColor: UIColor? {
        //backgroundColor overrides light/dark
        if let back = setColor(viewProps.backgroundColor) {
            return back
        }
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return setColor(viewProps.backgroundColorDark)
            } else {
                return setColor(viewProps.backgroundColorLight)
            }
        }
        return nil
    }

    func setNavBarAppearance(_ navController: UINavigationController,
                             appearance: ViewProperties.NavBarAppearance?) -> Bool {
        var navBarPrefersLargeTitles = false
        navBarPrefersLargeTitles =? appearance?.prefersLargeTitles
        if #available(iOS 14.0, *) {
            if appearance?.background == "transparent" {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                navController.navigationBar.scrollEdgeAppearance = appearance
                navController.navigationBar.standardAppearance = appearance
            }
            if appearance?.background == "opaque" {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                navController.navigationBar.scrollEdgeAppearance = appearance
                navController.navigationBar.standardAppearance = appearance
            }
            if appearance?.background == "default" {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                navController.navigationBar.scrollEdgeAppearance = appearance
                navController.navigationBar.standardAppearance = appearance
            }
        }
        return navBarPrefersLargeTitles
    }
}

struct ViewProperties: Codable {

    struct TabBar: Codable {
        var tabBarAppearance: TabBarAppearance?
    }

    struct NavBar: Codable {
        var appearance: NavBarAppearance?
        var title: String?
    }

    struct NavBarAppearance: Codable {
        var prefersLargeTitles: Bool?
        var background: String?
    }

    struct TabBarAppearance: Codable {
        var background: String?
        var lockBackground: Bool?
    }

    struct Configuration: Codable {
        var type: String?
        var value: String?
    }

    struct Image: Codable {
        var type: String?
        var name: String?
        var symbolConfig: [Configuration]?
    }

    struct  MenuElement: Codable {
        var title: String?
        var identifier: String?
        var menuImage: Image?
        var attributes: [String]?
    }

    struct  BarButtonItem: Codable {
        var type: String?
        var title: String?
        var image: Image?
        var menuType: String?
        var leftItemsSupplementBackButton: Bool?
        var menuElements: [MenuElement]?
        var menuTitle: String?
        var identifier: String?
    }

    struct  TabBarItem: Codable {
        var hideNavBar: Bool?
        var navBar: NavBar?
        var title: String?
        var image: Image?
        var systemItem: String?
        var tag: Int?
    }

    struct ListItem: Codable {
        var listImage: Image?
        var listText: String?
    }

    struct Section: Codable {
        var header: String?
        var listItems: [ListItem]?
    }

    struct Collection: Codable {
        var sections: [Section]?
        var config: CollectionConfig?
    }

    struct Views: Codable {
        var primaryCollection: Collection?
    }

    struct CollectionConfig: Codable {
        var type: String?
        var initialSection: Int?
        var initialRow: Int?
        var clearsSelection: Bool?
        var messageTargets: [String]?
    }

    struct ViewConfig: Codable {
        var primary: String?
        var secondary: String?
        var supplementary: String?
    }

    var primaryURL: String?
    var secondaryURL: String?
    var supplementaryURL: String?
    var compactURL: String?
    var primaryTitle: String?
    var secondaryTitle: String?
    var supplementaryTitle: String?

    var style: String?  // doubleColumn, tripleColumn
    var preferredSplitBehavior: String?
    var preferredDisplayMode: String?
    var primaryColumnWidthFraction: CGFloat?
    var preferredPrimaryColumnWidth: CGFloat?
    var minimumPrimaryColumnWidth: CGFloat?
    var maximumPrimaryColumnWidth: CGFloat?
    var supplementaryColumnWidthFraction: CGFloat?
    var supplementaryColumnWidth: CGFloat?
    var maximumSupplementaryColumnWidth: CGFloat?
    var minimumSupplementaryColumnWidth: CGFloat?
    var primaryEdge: String?
    var presentsWithGesture: Bool?
    var showsSecondaryOnlyButton: Bool?
    var contentInsetAdjustmentBehavior: String?
    var hideNavigationBar: Bool?

    var backgroundColor: [CGFloat]?
    var backgroundColorLight: [CGFloat]?
    var backgroundColorDark: [CGFloat]?

    var barButtonRight: BarButtonItem?
    var barButtonLeft: BarButtonItem?

    var navBarAppearance: NavBarAppearance?
    var tintColor: [CGFloat]?  //will move into NavBarAppearance
    var barTintColor: [CGFloat]? //will move into NavBarAppearance

    var tabBarItems: [TabBarItem]?
    var tabBar: TabBar?
    var selectedTabIndex: Int?
    var shouldSelectTab: Bool?

    var topColumnForCollapsingToProposedTopColumn: String?
    var displayModeForExpandingToProposedDisplayMode: String?

    var viewConfig: ViewConfig?
    var views: Views?

    var usesCompact: Bool?
    var isEmbedded: Bool?
    var fullscreen: Bool?
    var makeRoot: Bool?
    var horizScrollBarInvisible: Bool?
    var vertScrollBarInvisible: Bool?
    var preventHorizScroll: Bool?
}

//
// Only used for Classic View and will be phased out after iOS 14 becomes minimum supported version
//
// Default Settings
//
//  if not set, uses Apple defaults
//
struct InitialProperties {

    var isEmbedded: Bool = false
    var isDouble: Bool = true
    var masterURL: String = PluginDefaults.primaryURLclassic
    var detailURL: String = PluginDefaults.secondaryURLclassic
    var primaryColumnWidthfraction: CGFloat?
    var masterTitle: String?
    var detailTitle: String?
    var barTintColor: UIColor?
    var tintColor: UIColor?
    var minimumPrimaryColumnWidth: CGFloat?
    var maximumPrimaryColumnWidth: CGFloat?
    var displayModeButtonItem: Bool = true
    var leftButtonTitle: String?
    var rightButtonTitle: String?
    var fullscreen: Bool = false            //meaningless for embedded case
    var masterBackgroundColor: UIColor?
    var detailBackgroundColor: UIColor?

    // Tableview data.  Unused in  embedded case
    //   maybe go with something less primitive if we add options
    var usesTableView: Bool = false
    var tableItems: [String] = []
    var tableImages: [String] = []
}
