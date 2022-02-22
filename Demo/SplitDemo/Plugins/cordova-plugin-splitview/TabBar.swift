//
//  TabBar.swift
//
//  Created by jerry on 4/2/21.
//

import Foundation
import UIKit
import WebKit

class SpViewControllerCompact: SpViewControllerChild {
    enum ScrollEdgeState {
        case unset, isEdge, notEdge
    }
    private var scrollEdge  = ScrollEdgeState.unset

    override  func setProperties (props: String) {
        guard let parentTabBar = tabBarController as? TabBarController2  else {
            return
        }
        if parentTabBar.compactProperties.decodeProperties(json: props) {
            parentTabBar.setTabViewProperties()
        }
    }

    override  func initNavBar() {
        navigationItem.largeTitleDisplayMode = .always //navBar decides
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Force large navBar titles to lay out correctly on
    // large phone rotation. viewWillTransition handles small phone navBars where the view stays compact
    // on rotation but since viewWillTransition only gets called on transition from, not to, a large
    // device's regular view (since the compact view has disappeared) we handle the large device case
    // with viewDidAppear which doesn't happen on small phones.

    // force ScrollEdgeAppearance and NavBar size

    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
        scrollEdge  = ScrollEdgeState.unset
        // force ScrollEdgeAppearance after switching from regular view
        let wkWebView = webViewEngine?.engineWebView as? WKWebView
        if let scrollVw = wkWebView?.scrollView {
            let bottomEdge = scrollVw.contentOffset.y + scrollVw.frame.size.height
            setBarToScrollEdgeAppearance(bottomEdge >= scrollVw.contentSize.height ? ScrollEdgeState.isEdge : ScrollEdgeState.notEdge)
            }
        let navC = self.navigationController
        navC?.navigationBar.sizeToFit()
    }

    // we force ScrollEdgeAppearance after scroll but a rotation
    // can push content under the tabBar without generating a scroll event
    // we handle that case here
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let wkWebView = webViewEngine?.engineWebView as? WKWebView
           coordinator.animate(alongsideTransition: { _ in
               if let scrollVw = wkWebView?.scrollView {
                   let bottomEdge = scrollVw.contentOffset.y + scrollVw.frame.size.height
                   self.setBarToScrollEdgeAppearance(bottomEdge >= scrollVw.contentSize.height ? ScrollEdgeState.isEdge : ScrollEdgeState.notEdge)
               }
           }, completion: nil)
}

    //    force scrollEdgeAppearance
    //    Workaround for current behavior of TabBars
    //
    //    Also workaround for large-title navBars

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if preventHorizScroll {
           if scrollView.contentOffset.x != 0 {
               scrollView.contentOffset.x = 0
           }
        }
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        let yOff = scrollView.contentOffset.y
        if yOff <= 0 {
            // The following two lines handle an edge condition or two, mainly Status Bar scroll-to-top
            // which would end up with a bad offset (very noticible extra top space)
            // Since we handle DidScroll, we aren't handling
            //
            //     func scrollViewDidEndDragging(_ scrollView: UIScrollView,willDecelerate decelerate: Bool) {
            //     if !decelerate {
            //
            //     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if !( scrollView.isDragging || scrollView.isDecelerating) {
           scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            }
            let navC = self.navigationController
            navC?.navigationBar.sizeToFit()
        }
        setBarToScrollEdgeAppearance(bottomEdge >= scrollView.contentSize.height ? ScrollEdgeState.isEdge : ScrollEdgeState.notEdge)
    }

    func setBarToScrollEdgeAppearance(_ isEdge: ScrollEdgeState) {
        if #available(iOS 15.0, *) {
            if scrollEdge == isEdge {
                return
            }
            if let parentTabBar = tabBarController as? TabBarController2 {
                if parentTabBar.lockBackground {
                    return
                }
            }
            let appearance = UITabBarAppearance()
            if isEdge == ScrollEdgeState.isEdge {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithDefaultBackground()
            }
            tabBarController?.tabBar.standardAppearance = appearance
            scrollEdge = isEdge
        }
    }
}

class TabBarController2: UITabBarController, UITabBarControllerDelegate {
    var viewControllerCompact: SpViewControllerCompact
    var secondaryVC: SpViewControllerDetail
    var usesCompactViewController = true  //only option for this version
    var compactProperties = ViewProps()
    var lockBackground = false

    // should be combined -- but controller array is needed, so...
    var tabViewControllers: [UINavigationController] = []
    var navBarTitles: [String] = []

    init(_ viewControllerDetail: SpViewControllerDetail, _ compactURL: String?, properties: String? ) {
        secondaryVC = viewControllerDetail
        if let jsonAg = properties {
            if compactProperties.decodeProperties(json: jsonAg) {
            }
        }

        viewControllerCompact = SpViewControllerCompact(backgroundColor: compactProperties.backgroundColor, page: compactProperties.viewProps.compactURL ?? PluginDefaults.compactURL)
        super.init(nibName: nil, bundle: nil)
        viewControllerCompact.setScrollProperties(horizBarInvisible: compactProperties.viewProps.horizScrollBarInvisible ?? false, vertBarInvisible: compactProperties.viewProps.vertScrollBarInvisible ?? false, noHorizScroll: compactProperties.viewProps.preventHorizScroll ?? false)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func setTabViewProperties() {
        //didselect is not called if tab is selected programmatically
        if let newIndex = compactProperties.viewProps.selectedTabIndex {
            if newIndex > -1  &&  newIndex < tabViewControllers.count {
                selectedIndex = newIndex
                moveView(tabViewControllers[newIndex], index: newIndex)
            }
        }
        if let tabBarBackground = compactProperties.viewProps.tabBar?.tabBarAppearance?.background {
            setTabBarAppearance(appearance: tabBarBackground)
        }
        if let back = compactProperties.viewProps.tabBar?.tabBarAppearance?.lockBackground {
            lockBackground = back
        }
    }

    func setTabBarAppearance( appearance: String) {
        if #available(iOS 15.0, *) {
            if appearance == "transparent" {
                let appearance = UITabBarAppearance()
                appearance.configureWithTransparentBackground()
                tabBar.scrollEdgeAppearance = appearance
                tabBar.standardAppearance = appearance
            }
            if appearance == "opaque" {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                tabBar.scrollEdgeAppearance = appearance
                tabBar.standardAppearance = appearance
            }
            if appearance == "default" {
                let appearance = UITabBarAppearance()
                appearance.configureWithDefaultBackground()
                tabBar.scrollEdgeAppearance = appearance
                tabBar.standardAppearance = appearance
            }
        }
    }

    func selectTab(index: Int) {
        //didselect is not called if tab is selected programmatically
        if index >= 0 && index != selectedIndex &&  index < tabViewControllers.count {
            selectedIndex = index
            moveView(tabViewControllers[index], index: index)
        }
    }

    func moveView(_ newCtl: UINavigationController, index: Int) {
        if usesCompactViewController {
            let newV: [UIViewController] = [viewControllerCompact]
            newCtl.setViewControllers(newV, animated: false)
            newCtl.navigationBar.topItem?.title = navBarTitles[index]
        } else {
            let newV: [UIViewController] = [secondaryVC]
            newCtl.setViewControllers(newV, animated: false)
        }
    }

    //
    // if we move the view while scrolling bad things happen:
    // the main one seems to be the failure of programmatic scrolling in the web view
    // so we stop scrolling and internally fire a select after a timeout.
    // Not thrilled with the timout, but it seems to work and will stay
    // until something better appears
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else {
            return false
        }

        let wkWebView = viewControllerCompact.webViewEngine?.engineWebView as? WKWebView
        if let sview = wkWebView?.scrollView {
            if sview.isDragging || sview.isDecelerating {
                //stop scroll
                sview.setContentOffset(sview.contentOffset, animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.selectTab(index: index)
                    let tag = viewController.tabBarItem.tag
                    let newitem = String(tag)
                    self.viewControllerCompact.eventHandle(SpViewControllerCompact.ViewEvents.tabBarEvent, data: newitem)
                }
            return false
            }
        }
     return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vcc = viewController as? UINavigationController {
            moveView(vcc, index: selectedIndex)
            let tag = vcc.tabBarItem.tag
            let newitem = String(tag)
            viewControllerCompact.eventHandle(SpViewControllerCompact.ViewEvents.tabBarEvent, data: newitem)
        }
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    setTabViewProperties()
    if #available(iOS 14.0, *) {
        let sysItem: [String: UITabBarItem.SystemItem] = ["bookmarks": .bookmarks, "contacts": .contacts, "downloads": .downloads, "favorites": .favorites, "featured": .featured, "history": .history, "more": .more, "mostRecent": .mostRecent, "mostViewed": .mostViewed, "recents": .recents, "search": .search, "topRated": .topRated]

        if let barItems = compactProperties.viewProps.tabBarItems {
            tabViewControllers = barItems.map {
                let viewController = UINavigationController()
                viewController.isNavigationBarHidden = $0.hideNavBar ?? true

                if $0.systemItem != nil {
                    if let systItem = sysItem[$0.systemItem ?? ""] {
                        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: systItem, tag: $0.tag ?? 0)
                    }
                } else {
                    viewController.tabBarItem = UITabBarItem(title: $0.title, image: newImage(image: $0.image), tag: $0.tag ?? 0)
                }
                viewController.navigationBar.prefersLargeTitles = compactProperties.setNavBarAppearance(viewController, appearance: $0.navBar?.appearance)
                navBarTitles.append( $0.navBar?.title ?? "")
                return viewController
            }
        }
    }

    let newV: [UIViewController] = [viewControllerCompact]
    if let  cvc = tabViewControllers[0] as? UINavigationController {
        cvc.setViewControllers(newV, animated: false)
        cvc.navigationBar.topItem?.title = navBarTitles[0]
    }
  setViewControllers(tabViewControllers, animated: false)
      }
}
