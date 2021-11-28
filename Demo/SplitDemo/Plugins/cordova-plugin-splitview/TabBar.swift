//
//  TabBar.swift
//
//  Created by jerry on 4/2/21.
//

import Foundation
import UIKit
import WebKit

class SpViewControllerCompact: SpViewControllerChild {
    override  func setProperties (props: String) {
        guard let parentTabBar = tabBarController as? TabBarController2  else {
            return
        }
        if parentTabBar.compactProperties.decodeProperties(json: props) {
            parentTabBar.setTabViewProperties()
        }
    }
}

class TabBarController2: UITabBarController, UITabBarControllerDelegate {
    var viewControllerCompact: SpViewControllerCompact
    var secondaryVC: SpViewControllerDetail
    var usesCompactViewController = true  //only option for this version
    var currentTabIndex = -1
    var tabViewControllers: [UINavigationController] = []
    var compactProperties = ViewProps()
    struct TabBarProperties {
        let title: String
        let image: String
        let tag: Int
      }
    var tabBarsProperties: [TabBarProperties] = []

    init(_ viewControllerDetail: SpViewControllerDetail, _ compactURL: String?, properties: String? ) {
        secondaryVC = viewControllerDetail
        if let jsonAg = properties {
            if compactProperties.decodeProperties(json: jsonAg) {
            }
        }

        viewControllerCompact = SpViewControllerCompact(backgroundColor: compactProperties.backgroundColor, page: compactProperties.viewProps.compactURL ?? PluginDefaults.compactURL)
        super.init(nibName: nil, bundle: nil)
        setTabViewProperties()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func setTabViewProperties() {
        //didselect is not called if tab is selected programmatically
        var newIndex = -1
        newIndex =? compactProperties.viewProps.selectedTabIndex
        if newIndex > 0 && newIndex != currentTabIndex &&  newIndex < tabViewControllers.count {
            selectedIndex = newIndex
            moveView(tabViewControllers[newIndex])
        }
    }

    func selectTab(index: Int) {
        //didselect is not called if tab is selected programmatically
        if index >= 0 && index != currentTabIndex &&  index < tabViewControllers.count {
            selectedIndex = index
            moveView(tabViewControllers[index])
        }
    }

    func moveView(_ newCtl: UINavigationController) {
        if usesCompactViewController {
            let newV: [UIViewController] = [viewControllerCompact]
            newCtl.setViewControllers(newV, animated: false)
        } else {
            let newV: [UIViewController] = [secondaryVC]
            newCtl.setViewControllers(newV, animated: false)
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        currentTabIndex = tabBarController.selectedIndex
        if let vcc = viewController as? UINavigationController {
            moveView(vcc)
            let tag = vcc.tabBarItem.tag
            let newitem = String(tag)
            viewControllerCompact.eventHandle(SpViewControllerCompact.ViewEvents.tabBarEvent, data: newitem)
        }
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    if #available(iOS 14.0, *) {
        let sysItem: [String: UITabBarItem.SystemItem] = ["bookmarks": .bookmarks, "contacts": .contacts, "downloads": .downloads, "favorites": .favorites, "featured": .featured, "history": .history, "more": .more, "mostRecent": .mostRecent, "mostViewed": .mostViewed, "recents": .recents, "search": .search, "topRated": .topRated]

        if let barItems = compactProperties.viewProps.tabBarItems {
            tabViewControllers = barItems.map {
                let viewController = UINavigationController()
                viewController.isNavigationBarHidden = true

                if $0.systemItem != nil {
                    if let systItem = sysItem[$0.systemItem ?? ""] {
                        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: systItem, tag: $0.tag ?? 0)
                    }
                } else {
                    viewController.tabBarItem = UITabBarItem(title: $0.title, image: newImage(image: $0.image), tag: $0.tag ?? 0)
                }
                return viewController
            }
        }
    }

    let newV: [UIViewController] = [viewControllerCompact]
    if let  cvc = tabViewControllers[0] as? UINavigationController {
        cvc.setViewControllers(newV, animated: false)
    }
  setViewControllers(tabViewControllers, animated: true)
      }
}
