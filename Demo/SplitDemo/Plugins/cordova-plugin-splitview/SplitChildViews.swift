//
//  SplitChildViews.swift
//
//  Created by jerry on 4/9/21.
//

import Foundation
import UIKit
import WebKit

class SpViewControllerChild: CDVViewController {
    var initialBackgroundColor: UIColor?
    var isReady = false //set when webview wants messages
    var queuedMessage = "" //last message sent before device ready/ init
    var webViewMessage: ((String, String, SplitViewAction) -> Void)?
    var childProperties = ViewProps()

    enum ViewEvents: String {
        case buttonEvent = "0"
        case tabBarEvent = "1"
        //previous versions had separate right and left tap events as well as a menu-item-selected event
        //now each action has a unique ID 
   }

    init(backgroundColor: UIColor?, page: String) {
        super.init(nibName: nil, bundle: nil)
        startPage = page
        initialBackgroundColor = backgroundColor
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

   override func viewDidLoad() {
        launchView = UIView(frame: view.bounds)
        launchView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.viewDidLoad()
        view.backgroundColor = initialBackgroundColor
        launchView.backgroundColor = initialBackgroundColor
        view.addSubview(launchView)
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
            navigationController?.navigationBar.tintColor =? childProperties.setColor(childProperties.viewProps.tintColor)
            navigationController?.navigationBar.barTintColor =? childProperties.setColor(childProperties.viewProps.barTintColor)
            if let rightButton = childProperties.viewProps.barButtonRight {
                setButton(navController, buttonItem: rightButton, isRight: true, leftItemsSuppBack: false)
            }
            if let leftButton = childProperties.viewProps.barButtonLeft {
                setButton(navController, buttonItem: leftButton, isRight: false, leftItemsSuppBack: childProperties.viewProps.barButtonLeft?.leftItemsSupplementBackButton ?? false)
            }
        }
    }

    func setButton(_ navController: UINavigationController, buttonItem: ViewProperties.BarButtonItem, isRight: Bool, leftItemsSuppBack: Bool) {
        //
        // system items for buttons
        //
        let sysItem: [String: UIBarButtonItem.SystemItem] = ["done": .done, "cancel": .cancel, "edit": .edit, "save": .save, "add": .add, "compose": .compose, "reply": .reply, "action": .action, "organize": .organize, "bookmarks": .bookmarks, "search": .search, "refresh": .refresh, "stop": .stop, "camera": .camera, "trash": .trash, "play": .play, "pause": .pause, "rewind": .rewind, "fastForward": .fastForward, "undo": .undo, "redo": .redo]

        guard let buttonType = buttonItem.type else {
            return
        }
        //
        // this allows the left button to coexist with rather than replace a system left button
        //
        navController.navigationBar.topItem?.leftItemsSupplementBackButton = leftItemsSuppBack
        if #available(iOS 14.0, *) {
        let menuAttributes: [String: UIMenuElement.Attributes] = ["destructive": .destructive, "disabled": .disabled, "hidden": .hidden]
        var primaryAct: UIAction?
        var barButtonItm: UIBarButtonItem?
        var theMenu: UIMenu?

        primaryAct =  UIAction( identifier: UIAction.Identifier(buttonItem.identifier ?? ""), handler: buttonHandler)
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
                menuChildren.append( UIAction(title: item.title ?? "", image: newImage(image: item.menuImage), identifier: UIAction.Identifier(item.identifier ?? ""), attributes: atts, handler: buttonHandler))
            }
            theMenu = UIMenu(title: buttonItem.menuTitle ?? "", options: .displayInline, children: menuChildren)
            //we don't test for all bad behavior, in those cases we default to "menu"
            if buttonItem.menuType == "menuLongPress" {
                primaryAct =  UIAction(identifier: UIAction.Identifier(buttonItem.identifier ?? ""), handler: buttonHandler)
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
            barButtonItm = UIBarButtonItem( image: newImage(image: buttonItem.image), primaryAction: primaryAct, menu: theMenu)

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

    @available(iOS 14.0, *)
    func buttonHandler(from action: UIAction) {
        eventHandle(ViewEvents.buttonEvent, data: action.identifier.rawValue)
    }

    //
    // handles all child events
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
