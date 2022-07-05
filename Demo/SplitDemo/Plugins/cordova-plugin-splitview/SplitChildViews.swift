//
//  SplitChildViews.swift
//
//  Created by jerry on 4/9/21.
//

import Foundation
import UIKit
import WebKit

private let sysItem: [String: UIBarButtonItem.SystemItem] = ["done": .done,
                                                             "cancel": .cancel,
                                                             "edit": .edit,
                                                             "save": .save,
                                                             "add": .add,
                                                             "compose": .compose,
                                                             "reply": .reply,
                                                             "action": .action,
                                                             "organize": .organize,
                                                             "bookmarks": .bookmarks,
                                                             "search": .search,
                                                             "refresh": .refresh,
                                                             "stop": .stop,
                                                             "camera": .camera,
                                                             "trash": .trash,
                                                             "play": .play,
                                                             "pause": .pause,
                                                             "rewind": .rewind,
                                                             "fastForward": .fastForward,
                                                             "undo": .undo,
                                                             "redo": .redo]

class SpViewControllerChild: CDVViewController, UIScrollViewDelegate {
    var initialBackgroundColor: UIColor?
    var isReady = false //set when webview wants messages
    var queuedMessage = "" //last message sent before device ready/ init
    var webViewMessage: ((String, String, SplitViewAction) -> Void)?
    var childProperties = ViewProps()
    var navBarPrefersLargeTitles = false
    var horizScrollBarInvisible = false
    var vertScrollBarInvisible = false
    var preventHorizScroll = false

    init(backgroundColor: UIColor?, page: String) {
        super.init(nibName: nil, bundle: nil)
        startPage = page
        initialBackgroundColor = backgroundColor
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func initNavBar() {
        if navBarPrefersLargeTitles {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        } else {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
    }

   override func viewDidLoad() {
       initNavBar()
       launchView = UIView(frame: view.bounds)
       launchView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       super.viewDidLoad()
       view.backgroundColor = initialBackgroundColor
       launchView.backgroundColor = initialBackgroundColor
       view.addSubview(launchView)

       let wkWebView = webViewEngine?.engineWebView as? WKWebView
       if let scrollVw = wkWebView?.scrollView {
           scrollVw.contentInsetAdjustmentBehavior =  UIScrollView.ContentInsetAdjustmentBehavior.never

           // fixes scrolledge,large titles, etc.
           scrollVw.delegate = self
           scrollVw.showsHorizontalScrollIndicator = !horizScrollBarInvisible
           scrollVw.showsVerticalScrollIndicator = !vertScrollBarInvisible
           if preventHorizScroll {
               scrollVw.isDirectionalLockEnabled = true //seems to slightly improve things
           }
       }
    }

    //needed for correct scrolledge on rotation
    //there are non-rotating cases where we don't want the sizing to happen
    //but handling those cases is for a future version
    //or if we're lucky the need for this workaround will go away
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let navCtl = self.navigationController
           coordinator.animate(alongsideTransition: { _ in
               navCtl?.navigationBar.sizeToFit()
           }, completion: nil)
       }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let navCtl = self.navigationController
        navCtl?.navigationBar.sizeToFit()
    }

    //
    //workaround for large-title navBars
    //

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    }

    //
    //  Workaround for a leak.
    //  When fixed, this can go.
    //
    deinit {
         let wkWebView = webViewEngine?.engineWebView as? WKWebView
         wkWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "cordova")
     }

    func doAction(_ splitAction: SplitViewAction, _ arg0: String, _ arg1: String ) {
        webViewMessage?(arg0, arg1, splitAction)
    }

    func getMsg(msg: String) {

        if isReady {
            commandDelegate.evalJs("cordova.plugins.SplitView.onMessage('\(msg)');")
        } else {
            queuedMessage = msg
        }
    }

    func setProperties (props: String) {
        if props.isEmpty {
            return
        }
        guard let navController = navigationController else {
            return
        }

        if childProperties.decodeProperties(json: props) {
            setScrollProperties(horizBarInvisible: childProperties.viewProps.horizScrollBarInvisible ?? false,
                                vertBarInvisible: childProperties.viewProps.vertScrollBarInvisible ?? false,
                                noHorizScroll: childProperties.viewProps.preventHorizScroll ?? false)
            navigationController?.navigationBar.tintColor =? childProperties.setColor(childProperties.viewProps.tintColor)
            navigationController?.navigationBar.barTintColor =? childProperties.setColor(childProperties.viewProps.barTintColor)
            if let rightButton = childProperties.viewProps.barButtonRight {
                setButton(navController, buttonItem: rightButton, isRight: true, leftItemsSuppBack: false)
            }
            if let leftButton = childProperties.viewProps.barButtonLeft {
                setButton(navController,
                          buttonItem: leftButton,
                          isRight: false,
                          leftItemsSuppBack: childProperties.viewProps.barButtonLeft?.leftItemsSupplementBackButton ?? false)
            }
            navBarPrefersLargeTitles = childProperties.setNavBarAppearance(navController,
                                                                           appearance: childProperties.viewProps.navBarAppearance)
        }
    }

    func setScrollProperties( horizBarInvisible: Bool, vertBarInvisible: Bool, noHorizScroll: Bool) {
        // can modify to set properties dynamically but now we only set on creation
        horizScrollBarInvisible = horizBarInvisible
        vertScrollBarInvisible = vertBarInvisible
        preventHorizScroll = noHorizScroll
    }

    func setButton(_ navController: UINavigationController,
                   buttonItem: ViewProperties.BarButtonItem,
                   isRight: Bool,
                   leftItemsSuppBack: Bool) {
        //
        // system items for buttons
        //
        guard let buttonType = buttonItem.type else {
            return
        }
        //
        // this allows the left button to coexist with rather than replace a system left button
        //
        navController.navigationBar.topItem?.leftItemsSupplementBackButton = leftItemsSuppBack
        if #available(iOS 14.0, *) {
        let menuAttributes: [String: UIMenuElement.Attributes] = ["destructive": .destructive,
                                                                  "disabled": .disabled,
                                                                  "hidden": .hidden]
        var primaryAct: UIAction?
        var barButtonItm: UIBarButtonItem?
        var theMenu: UIMenu?

        primaryAct = UIAction( ) { [unowned self]  _ in
                eventHandle(ViewEvents.buttonEvent, data: buttonItem.identifier  ?? "")
        }
        if let menuElements = buttonItem.menuElements {
            var menuChildren = [UIAction]()
            for item in menuElements {
                var  atts: UIKit.UIMenuElement.Attributes = []
                if let attributes = item.attributes {
                    for attribute in attributes {
                        if let menuAttribute = menuAttributes[attribute] {
                            atts.insert(menuAttribute)
                        }
                    }
                }
                menuChildren.append( UIAction(title: item.title ?? "",
                                              image: newImage(image: item.menuImage),
                                              identifier: UIAction.Identifier(item.identifier ?? ""),
                                              attributes: atts, handler: {  [unowned self] (_) in eventHandle(ViewEvents.buttonEvent, data: item.identifier  ?? "")
                }))
            }
            theMenu = UIMenu(title: buttonItem.menuTitle ?? "", options: .displayInline, children: menuChildren)
            //we don't test for all bad behavior, in those cases we default to "menu"
            if buttonItem.menuType == "menuLongPress" {
            } else {
                primaryAct = nil
            }
        }

        switch buttonType {
        case "text":
            guard let bartext = buttonItem.title else {
                return
            }
            barButtonItm = UIBarButtonItem( title: bartext, primaryAction: primaryAct, menu: theMenu)

        case "system":
            guard let sysitem = buttonItem.title, let sysEnum = sysItem[sysitem] else {
                return
            }
            barButtonItm = UIBarButtonItem( systemItem: sysEnum, primaryAction: primaryAct, menu: theMenu)

        case  "image":
            barButtonItm = UIBarButtonItem( image: newImage(image: buttonItem.image),
                                            primaryAction: primaryAct,
                                            menu: theMenu)

        default:
            return
        }

        if isRight {
            navController.navigationBar.topItem?.rightBarButtonItem = barButtonItm
            } else {
            navController.navigationBar.topItem?.leftBarButtonItem = barButtonItm
            }
        }
    }

    //
    // handles all child events
    //
    // this will be replaced in a future version which
    // will update event handling
    //
    func eventHandle(_ event: ViewEvents, data: String = "" ) {
        commandDelegate.evalJs( "cordova.plugins.SplitView.onAction('\(event.rawValue)','\(data)');")
    }

    func initChild() {
        isReady = true
        if queuedMessage != "" {
            commandDelegate.evalJs("cordova.plugins.SplitView.onMessage('\(queuedMessage)');")
        }
    }
}

@objc class SpViewController: SpViewControllerChild, UISplitViewControllerDelegate {
    var embedded: Bool = false
    weak var delegate: itemSelectionDelegate?

    init(backgroundColor: UIColor?, page: String, isEmbedded: Bool) {
        super.init(backgroundColor: backgroundColor, page: page)
        embedded = isEmbedded
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    @objc func notifyDetail(arg: String ) {
        delegate?.itemSelected(arg)
    }
}

@objc class SpViewControllerSupplementary: SpViewControllerChild {

}

//
// *** deprecated *** View Controllers for classic view
//

//
// detail view controller for both table and webview masters
//

@objc class SpViewControllerDetail: SpViewControllerChild {

    var queuedItem = "" //last selected item before device ready
    var detailResults = ""
}

extension SpViewControllerDetail: itemSelectionDelegate {
  func itemSelected(_ theitem: String) {
    let newitem = "'" + theitem + "'"
    if isReady {
        commandDelegate.evalJs( "cordova.plugins.SplitView.onSelected(\(newitem));")
    } else {
     queuedItem = newitem
    }
  }
}

protocol itemSelectionDelegate: AnyObject {
  func itemSelected(_ theitem: String)
}
