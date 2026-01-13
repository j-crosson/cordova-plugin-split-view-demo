//
//  SplitView.swift
//
//  Created by jerry on 12/13/19.
//

import Foundation
import UIKit
import WebKit

enum PluginDefaults {
    static let primaryURL: String = "primary.html"
    static let secondaryURL: String = "secondary.html"
    static let supplementaryURL: String = "supplementary.html"
    static let compactURL: String = "compact.html"
    static let primaryURLclassic: String = "index1.html"
    static let secondaryURLclassic: String = "index2.html"
}

enum ViewEvents: String {
    case buttonEvent = "0"
    case tabBarEvent = "1"
    case collectionEvent = "2"
    case barItemSelected = "3"
    //previous versions had separate right and left tap events as well as a menu-item-selected event
    //now each action has a unique ID
}

enum ScrollBarVisibility: String {
    case showHorizontal = "showHoriz"
    case hideHorizontal = "hideHoriz"
    case showVertical = "showVert"
    case hideVertical = "hideVert"
}

enum CollectionEvents: String {
    case selectedListItem = "0"
}

@objc public class SplitView: CDVPlugin {
    var initialProperties = InitialProperties()
    var splitProperties = ViewProps()

    @objc(showView:)
    func showView(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus.ok, messageAs: "Plugin succeeded")
        var viewsProperties =  [String?]()
        if #available(iOS 14.0, *) {
            for inx in 0...command.arguments.count-1 {
                viewsProperties.append(command.arguments[inx] as? String)
            }
            var viewMask: UIInterfaceOrientationMask = .all
            viewMask = viewController.supportedInterfaceOrientations
            
            let splitViewController = RtViewController( viewProperties: viewsProperties, splitViewMask: viewMask)
            if splitViewController.isRoot {
                viewController.view.window?.rootViewController? = splitViewController
                } else {
                    viewController.present(splitViewController, animated: true, completion: nil)
            }
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus.error, messageAs: "iOS 14 Required")
        }
        commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(setProperties:)
    func setProperties(command: CDVInvokedUrlCommand) {
        if let currentView = viewController as? SpViewControllerChild {
            if let json = command.arguments[0] as? String {
                currentView.setProperties(props: json)
            }
        }
    }

    @objc(setSplitViewProperties:)
    func setSplitViewProperties(command: CDVInvokedUrlCommand) {
        guard let props  = command.arguments[0] as? String else {
            return
        }
        if let childController = viewController as? SpViewControllerChild {
            childController.doAction(.setProperties, props, "")
        }
    }

    @objc(viewAction:)
    func action(command: CDVInvokedUrlCommand) {
        guard let gAction  = command.arguments[0] as? String else {
            return
        }
        if let childController = viewController as? SpViewControllerChild {
            if gAction == "dismiss" {
                childController.doAction(.dismiss, "", "")
            } else if gAction == "scrollBar" {
                if let gData  = command.arguments[2] as? [String] {
                    childController.doAction(.scrollBar, "", gData[0])
                }
            } else if gAction == "setCollectionProperty" {
                //for this release, there is only one CollectionView, the primary view
                if let gTarget = command.arguments[1] as? [String], let gData  = command.arguments[2] as? [String] {
                    childController.doAction(.setCollectionProperty, gTarget[0], gData[0])
                }
            } else if gAction == "fireCollectionEvent" {
                if let gTarget = command.arguments[1] as? [String], let gData  = command.arguments[2] as? [String] {
                    for target in gTarget {
                        childController.doAction(.fireCollectionEvent, target, gData[0])
                    }
                }
            }
        }
    }

    @objc(selectTab:)
    func selectTab(command: CDVInvokedUrlCommand) {
        //only applies to compact view controller
        if let currentView = viewController as? SpViewControllerCompact,
           let tabView = currentView.tabBarController as? TabBarController2,
           let index = command.arguments[0] as? Int {
            tabView.selectTab(index: index)
        }
    }

    @objc(display:)
    func display(command: CDVInvokedUrlCommand) {
        guard let visible  = command.arguments[0] as? String else {
            return
        }
        let showOrHide: SplitViewAction = visible == "show" ? .show : .hide
        guard let splitChildView = command.arguments[1] as? String else {
            return
        }
        if let childController = viewController as? SpViewControllerChild {
            childController.doAction(showOrHide, splitChildView, "")
        }
    }

    @objc(sendMessage:)
    func sendMessage(command: CDVInvokedUrlCommand) {
        guard let destination  = command.arguments[0] as? String else {
            return
        }
        guard let message = command.arguments[1] as? String else {
            return
        }
       if let childController = viewController as? SpViewControllerChild {
        childController.doAction(.sendmessage, destination, message)
        }
    }

    @objc(initChild:)
    func initChild(command: CDVInvokedUrlCommand) {
        guard let childViewController = viewController as? SpViewControllerChild else {
            return
        }
        childViewController.initChild()
    }

    //
    // classic view only ***deprecated***
    //

    @objc(primaryItemSelected:)
    func primaryItemSelected(command: CDVInvokedUrlCommand) {
        let fault = "error"
        let arg  = command.arguments[0] as? String ?? fault
        let testv = viewController as? SpViewController
        testv?.notifyDetail(arg: arg)

        //we may or may not be modal
        let spr = viewController.view.window?.rootViewController?.presentedViewController ?? viewController.view.window?.rootViewController
        if let  splitroot = spr as? RtViewControllerClassic {
        splitroot.showDetailViewController(splitroot.secondaryViewController, sender: splitroot)
        }
      }

    @objc(show:)
    func show(command: CDVInvokedUrlCommand) {
        let returnResults: (String, String) -> () = { [unowned self] in
                commandDelegate.evalJs( "cordova.plugins.SplitView.onClosed('\($0)','\($1)');")
        }
    initialProperties.masterURL =? (command.arguments[0] as? String)
    initialProperties.detailURL =? (command.arguments[1] as? String)
    let isAnimated =  (command.arguments[2] as? Bool) ?? true
    let splitViewController = RtViewControllerClassic(iprop: initialProperties)
    splitViewController.resultsClosure = returnResults

    viewController.present(splitViewController, animated: isAnimated, completion: nil)

    // Future versions can fail so we support succeed.
        let pluginResult = CDVPluginResult(status: CDVCommandStatus.ok, messageAs: "Plugin succeeded")
    // Send the function result back to Cordova.
    commandDelegate!.send(pluginResult, callbackId: command.callbackId)
  }

    @objc(primaryTitle:)
    func primaryTitle(command: CDVInvokedUrlCommand) {
        initialProperties.masterTitle = command.arguments[0] as? String
    }

    @objc(fullscreen:)
    func fullscreen(command: CDVInvokedUrlCommand) {
        initialProperties.fullscreen = command.arguments[0] as? Bool ?? false
    }

    @objc(secondaryTitle:)
    func secondaryTitle(command: CDVInvokedUrlCommand) {
        initialProperties.detailTitle = command.arguments[0] as? String
    }

    @objc(leftButtonTitle:)
    func leftButtonTitle(command: CDVInvokedUrlCommand) {
      initialProperties.leftButtonTitle = command.arguments[0] as? String
    }

    @objc(rightButtonTitle:)
    func rightButtonTitle(command: CDVInvokedUrlCommand) {
        initialProperties.rightButtonTitle = command.arguments[0] as? String
    }

    @objc(primaryBackgroundColor:)
    func primaryBackgroundColor(command: CDVInvokedUrlCommand) {
        initialProperties.masterBackgroundColor=setColor(red: command.arguments[0] as? CGFloat,
                                                         green: command.arguments[1] as? CGFloat,
                                                         blue: command.arguments[2] as? CGFloat,
                                                         alpha: 1)
    }

    @objc(secondaryBackgroundColor:)
    func secondaryBackgroundColor(command: CDVInvokedUrlCommand) {
        initialProperties.detailBackgroundColor=setColor(red: command.arguments[0] as? CGFloat,
                                                         green: command.arguments[1] as? CGFloat,
                                                         blue: command.arguments[2] as? CGFloat,
                                                         alpha: 1)
    }

    @objc(tintColor:)
    func tintColor(command: CDVInvokedUrlCommand) {
        initialProperties.tintColor=setColor(red: command.arguments[0] as? CGFloat,
                                             green: command.arguments[1] as? CGFloat,
                                             blue: command.arguments[2] as? CGFloat,
                                             alpha: 1)
    }

    @objc(barTintColor:)
    func barTintColor(command: CDVInvokedUrlCommand) {
        initialProperties.barTintColor=setColor(red: command.arguments[0] as? CGFloat,
                                                green: command.arguments[1] as? CGFloat,
                                                blue: command.arguments[2] as? CGFloat,
                                                alpha: 1)
    }

    @objc(primaryColumnWidth:)
    func primaryColumnWidth(command: CDVInvokedUrlCommand) {
        initialProperties.primaryColumnWidthfraction = command.arguments[0] as? CGFloat
    }

    @objc(minimumPrimaryColumnWidth:)
    func minimumPrimaryColumnWidth(command: CDVInvokedUrlCommand) {
        initialProperties.minimumPrimaryColumnWidth=command.arguments[0] as? CGFloat
    }

    @objc(maximumPrimaryColumnWidth:)
    func maximumPrimaryColumnWidth(command: CDVInvokedUrlCommand) {
        initialProperties.maximumPrimaryColumnWidth=command.arguments[0] as? CGFloat
    }

    @objc(displayModeButtonItem:)
    func displayModeButtonItem(command: CDVInvokedUrlCommand) {
       initialProperties.displayModeButtonItem =? (command.arguments[0] as? Bool)
     }

    @objc(useTableView:)
    func useTableView(command: CDVInvokedUrlCommand) {
        initialProperties.usesTableView =? (command.arguments[0] as? Bool)
    }

    @objc(addTableItem:)
    func addTableItem(command: CDVInvokedUrlCommand) {
        let itm = command.arguments[0] as? String ?? ""
        initialProperties.tableItems.append(itm)
        let img = command.arguments[1] as? String ?? ""
        initialProperties.tableImages.append(img)
    }

    // *** only used in classic view ***
    // "initilize" detail view
    //   user is required to call this in secondary view javascript when ready to
    //   recieve messages.
    //   handles queued message from primary view
    //   sent before "device ready" has happened in secondary webview
    //
    @objc(initSecondary:)
    func initSecondary(command: CDVInvokedUrlCommand) {
        guard let detailViewController = viewController as? SpViewControllerDetail else {
            return
        }
        detailViewController.isReady = true
        if detailViewController.queuedItem != "" {
            let theitem = detailViewController.queuedItem
            commandDelegate.evalJs( "cordova.plugins.SplitView.onSelected(\(theitem ));")
        }
    }

  @objc(setResults:)
  func setResults(command: CDVInvokedUrlCommand) {
     let detailViewController = self.viewController as? SpViewControllerDetail
     detailViewController?.detailResults = command.arguments[0] as? String ?? ""
    }

    //
    //Initilizes splitview
    //
    //clears all settings
  @objc(initSplit:)
     func initSplit(command: CDVInvokedUrlCommand) {
        initialProperties = InitialProperties()
    }

    func setColor(red: CGFloat?, green: CGFloat?, blue: CGFloat?, alpha: CGFloat?) -> UIColor? {
        guard let rrr = red, let ggg=green, let bbb=blue, let aaa=alpha else {
               return nil
           }
        return UIColor(red: rrr/255, green: ggg/255, blue: bbb/255, alpha: aaa)
    }
}

//--------  =? operator --------------
precedencegroup ConditionalAssignmentPrecedence {
    associativity: left
    assignment: true
    higherThan: AssignmentPrecedence
}

infix operator =?: ConditionalAssignmentPrecedence
// Set value of left-hand side only if right-hand side differs from `nil`
public func =? <T>(variable: inout T, value: T?) {
    if let val = value {
        variable = val
    }
}
