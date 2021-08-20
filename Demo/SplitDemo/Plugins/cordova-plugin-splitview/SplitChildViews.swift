//
//  SplitChildViews.swift
//  SplitDemo
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
        if childProperties.decodeProperties(json: props) {
            navigationController?.navigationBar.tintColor =? childProperties.setColor(childProperties.viewProps.tintColor)
            navigationController?.navigationBar.barTintColor =? childProperties.setColor(childProperties.viewProps.barTintColor)
        }
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
