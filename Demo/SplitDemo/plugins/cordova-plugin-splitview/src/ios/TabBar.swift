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
            if let contentInset = parentTabBar.compactProperties.viewProps.contentInsetAdjustmentBehavior {
                contentInsetAdjustmentBehavior =? insetAdjustmentBehavior[contentInset]
            }
            parentTabBar.setTabViewProperties()
        }
    }

    override  func initNavBar() {
        navigationItem.largeTitleDisplayMode = .always //navBar decides
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let wkWebView = webViewEngine.engineWebView as? WKWebView
        if let scrollVw = wkWebView?.scrollView {
            scrollVw.contentInsetAdjustmentBehavior =  contentInsetAdjustmentBehavior
        }
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
        let wkWebView = webViewEngine.engineWebView as? WKWebView
        if let scrollVw = wkWebView?.scrollView {
            adjustBarScrollEdgeAppearance(scrollVw)
        }
        let navC = self.navigationController
        navC?.navigationBar.sizeToFit()
    }

    // we force ScrollEdgeAppearance after scroll but a rotation
    // can push content under the tabBar without generating a scroll event
    // we handle that case here
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let wkWebView = webViewEngine.engineWebView as? WKWebView
        coordinator.animate(alongsideTransition: { _ in
            if let scrollVw = wkWebView?.scrollView {
                self.adjustBarScrollEdgeAppearance(scrollVw)
            }
        }, completion: nil)
    }

    //    force scrollEdgeAppearance
    //    Workaround for current behavior of TabBars
    //
    //    Also workaround for large-title navBars

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if preventHorizScroll {
            scrollView.contentOffset.x = -scrollView.adjustedContentInset.left
        }
        if scrollView.contentOffset.y <= 0 {
            if !( scrollView.isDragging || scrollView.isDecelerating) {
                self.navigationController?.navigationBar.sizeToFit()
            }
        }
        adjustBarScrollEdgeAppearance(scrollView)
    }

    func adjustBarScrollEdgeAppearance(_ scrollView: UIScrollView) {
        if #available(iOS 15.0, *) {
            // the "never" case requires forcing edge behavior.  Otherwise, things work as expected
            // and require no intervention
            if scrollView.contentInsetAdjustmentBehavior !=  UIScrollView.ContentInsetAdjustmentBehavior.never {
                return
            }

            let edgeState = (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height ? ScrollEdgeState.isEdge : ScrollEdgeState.notEdge

            if scrollEdge == edgeState {
                return
            }
            scrollEdge = edgeState

            if let parentTabBar = tabBarController as? TabBarController2 {
                if parentTabBar.lockBackground {
                    return
                }
            }

            let appearance = UITabBarAppearance()
            if scrollEdge == ScrollEdgeState.isEdge {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithDefaultBackground()
            }
            tabBarController?.tabBar.standardAppearance = appearance
            tabBarController?.tabBar.scrollEdgeAppearance = appearance
        }
    }
}

class TabBarController2: UITabBarController, UITabBarControllerDelegate {
    var viewControllerCompact: SpViewControllerCompact
    var secondaryVC: SpViewControllerDetail
    var usesCompactViewController = true  //only option for this version
    var compactProperties = ViewProps()
    var lockBackground = false
    var shouldSelect = true

    // should be combined -- but controller array is needed, so...
    var tabViewControllers: [UINavigationController] = []
    var navBarTitles: [String] = []

    init(_ viewControllerDetail: SpViewControllerDetail, _ compactURL: String?, properties: String? ) {
        secondaryVC = viewControllerDetail
        if let jsonAg = properties {
            if compactProperties.decodeProperties(json: jsonAg) {
            }
        }

        //properties will be handled differently in future versions.
        //These changes will be part of a major expansion of compact view
        viewControllerCompact = SpViewControllerCompact(backgroundColor: compactProperties.backgroundColor,
                                                        page: compactProperties.viewProps.compactURL ?? PluginDefaults.compactURL)
        super.init(nibName: nil, bundle: nil)
        viewControllerCompact.setScrollProperties(horizBarInvisible: compactProperties.viewProps.horizScrollBarInvisible ?? false,
                                                  vertBarInvisible: compactProperties.viewProps.vertScrollBarInvisible ?? false,
                                                  noHorizScroll: compactProperties.viewProps.preventHorizScroll ?? false)
        if let contentInset =  compactProperties.viewProps.contentInsetAdjustmentBehavior {
            viewControllerCompact.contentInsetAdjustmentBehavior =? insetAdjustmentBehavior[contentInset]
        }
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
        shouldSelect =? compactProperties.viewProps.shouldSelectTab
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
                tabBar.standardAppearance = appearance
                appearance.configureWithTransparentBackground()
                tabBar.scrollEdgeAppearance = appearance
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

    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else {
            return false
        }

        if !shouldSelect {
            viewControllerCompact.eventHandle(ViewEvents.barItemSelected, data: String(viewController.tabBarItem.tag))
            return false
        }

        //A user can select a tab before "isReady".  Since there is such a small window for this
        //on a real device (is noticable on simulator), we just prevent selection until the webview is ready.
        //A more sophisticated approach would be letting "isReady" make a queued select.
        if viewControllerCompact.isReady == false {
            return false
        }

        if #available(iOS 16.0, *) {
            return true
        }

        // In previous versions of iOS
        // if we move the view while scrolling bad things happen:
        // the main one seems to be the failure of programmatic scrolling in the web view
        // so we stop scrolling and internally fire a select after a timeout.
        // Not thrilled with the timout, but it seems to work
        //
        // Can't reproduce the issue in newer versions of iOS, so this workaround only
        // applies to older versions.

        let wkWebView = viewControllerCompact.webViewEngine.engineWebView as? WKWebView
        if let sview = wkWebView?.scrollView {
            if sview.isDragging || sview.isDecelerating {
                //stop scroll
                sview.setContentOffset(sview.contentOffset, animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.selectTab(index: index)
                    let tag = viewController.tabBarItem.tag
                    let newitem = String(tag)
                    self.viewControllerCompact.eventHandle(ViewEvents.tabBarEvent, data: newitem)
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
            viewControllerCompact.eventHandle(ViewEvents.tabBarEvent, data: newitem)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setTabViewProperties()
        if #available(iOS 14.0, *) {
            let sysItem: [String: UITabBarItem.SystemItem] = ["bookmarks": .bookmarks,
                                                              "contacts": .contacts,
                                                              "downloads": .downloads,
                                                              "favorites": .favorites,
                                                              "featured": .featured,
                                                              "history": .history,
                                                              "more": .more,
                                                              "mostRecent": .mostRecent,
                                                              "mostViewed": .mostViewed,
                                                              "recents": .recents,
                                                              "search": .search,
                                                              "topRated": .topRated]

            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                let appearance1 = UITabBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance1.configureWithTransparentBackground()
                tabBarController?.tabBar.standardAppearance = appearance
                tabBarController?.tabBar.scrollEdgeAppearance = appearance1
            }

            if let barItems = compactProperties.viewProps.tabBarItems {
                tabViewControllers = barItems.map {
                    let viewController = UINavigationController()
                    viewController.isNavigationBarHidden = $0.hideNavBar ?? true

                    if $0.systemItem != nil {
                        if let systItem = sysItem[$0.systemItem ?? ""] {
                            viewController.tabBarItem = UITabBarItem(tabBarSystemItem: systItem, tag: $0.tag ?? 0)
                        }
                    } else {
                        viewController.tabBarItem = UITabBarItem(title: $0.title,
                                                                 image: newImage(image: $0.image),
                                                                 tag: $0.tag ?? 0)
                    }
                    viewController.navigationBar.prefersLargeTitles = compactProperties.setNavBarAppearance(viewController,
                                                                                                            appearance: $0.navBar?.appearance)
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
