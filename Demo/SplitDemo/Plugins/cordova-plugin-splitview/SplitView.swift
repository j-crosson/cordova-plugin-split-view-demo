//
//  SplitView.swift
//
//  Created by jerry on 12/13/19.
//

import Foundation
import UIKit
import WebKit

@objc public class SplitView: CDVPlugin {
    var initialProperties = InitialProperties()
    
    @objc(show:)
    func show(command: CDVInvokedUrlCommand) {
        let returnResults: (String, String) -> () = { [unowned self] in
                self.commandDelegate.evalJs( "cordova.plugins.SplitView.onClosed('\($0)','\($1)');")
        }
    
    initialProperties.masterURL =? (command.arguments[0] as? String)
    initialProperties.detailURL =? (command.arguments[1] as? String)
    let isAnimated =  (command.arguments[2] as? Bool) ?? true

    let splitViewController = RtViewController(iprop: initialProperties, nibName: nil, bundle: nil)
    splitViewController.resultsClosure = returnResults

    viewController.present(splitViewController, animated: isAnimated, completion: nil)
    
    // Future versions can fail so we support succeed.
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Plugin succeeded")
    // Send the function result back to Cordova.
    commandDelegate!.send(pluginResult, callbackId: command.callbackId)
  }
    
    @objc(primaryItemSelected:)
    func primaryItemSelected(command: CDVInvokedUrlCommand) {
        let fault = "error"
        let arg  = command.arguments[0] as? String ?? fault
        let testv = viewController as? SpViewController
        testv?.notifyDetail(arg: arg)
          
        //we may or may not be modal
        let spr = viewController.view.window?.rootViewController?.presentedViewController ?? viewController.view.window?.rootViewController
        let  splitroot = spr as! RtViewController
        splitroot.showDetailViewController(splitroot.secondaryViewController, sender: splitroot)
      }
    
    //
    // Set properties
    //
    // passing array of properties possible future option
    //
    
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
        initialProperties.masterBackgroundColor=setColor(red: command.arguments[0] as? CGFloat, green: command.arguments[1] as? CGFloat, blue: command.arguments[2] as? CGFloat, alpha: 1)
    }
    
    @objc(secondaryBackgroundColor:)
    func secondaryBackgroundColor(command: CDVInvokedUrlCommand) {
        initialProperties.detailBackgroundColor=setColor(red: command.arguments[0] as? CGFloat, green: command.arguments[1] as? CGFloat, blue: command.arguments[2] as? CGFloat, alpha: 1)
    }
    
    @objc(tintColor:)
    func tintColor(command: CDVInvokedUrlCommand) {
        initialProperties.tintColor=setColor(red: command.arguments[0] as? CGFloat, green: command.arguments[1] as? CGFloat, blue: command.arguments[2] as? CGFloat, alpha: 1)
    }

    @objc(barTintColor:)
    func barTintColor(command: CDVInvokedUrlCommand) {
        initialProperties.barTintColor=setColor(red: command.arguments[0] as? CGFloat, green: command.arguments[1] as? CGFloat, blue: command.arguments[2] as? CGFloat, alpha: 1)
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

    //
    // "initilize" detail view
    //   user is required to call this in secondary view javascript when ready to
    //   recieve messages.
    //   handles queued message from primary view
    //   sent before "device ready" has happened in secondary webview
    //
    @objc(initSecondary:)
    func initSecondary(command: CDVInvokedUrlCommand) {
        let detailViewController = viewController as? SpViewControllerDetail
        
        detailViewController?.isReady = true
        if (detailViewController?.queuedItem != "") {
            let theitem = detailViewController?.queuedItem
            commandDelegate.evalJs( "cordova.plugins.SplitView.onSelected(\(theitem ?? ""));")
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

//
// Default Settings
//
//  if not set, uses Apple defaults
//
struct InitialProperties {
    var isEmbedded: Bool = false
    var masterURL: String = "index1.html"
    var detailURL: String = "index2.html"
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

//
//  Embed SPlitView in native app
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
            if(UITraitCollection.current.userInterfaceStyle == .dark) {
                initialBackground = dark
            }
        }
        initialProperties.masterBackgroundColor = initialBackground
    }
    func setSecondaryBackgroundColor(_ light: UIColor, _ dark: UIColor) {
        var initialBackground = light
        if #available(iOS 13.0, *) {
            if(UITraitCollection.current.userInterfaceStyle == .dark) {
                initialBackground = dark
            }
        }
        initialProperties.detailBackgroundColor = initialBackground
    }

    @objc(show:)
    func show(_ appWindow: UIWindow) {
        initialProperties.isEmbedded = true
        let splitViewController = RtViewController(iprop: initialProperties, nibName: nil, bundle: nil)
        appWindow.rootViewController = splitViewController
        appWindow.makeKeyAndVisible()
    }
}



//---------------------------------------------------------------
//
// split view classes
//

protocol itemSelectionDelegate: class {
  func itemSelected(_ theitem: String)
}

@objc class RtViewController: UISplitViewController {
 
    enum DismissedBy: String {
        case swipe = "0"
        case left = "1"
        case right = "2"
    }

    var viewControllerDetail: SpViewControllerDetail
    var secondaryViewController: UINavigationController
    var resultsClosure: ((_ returnString: String, String) -> ())?
    var resultsString = ""
    var exitPath = DismissedBy.swipe //buttons will set left or right
    
    init(iprop: InitialProperties, nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        
        var viewControllerMaster: SpViewController?
        var viewControllerMasterTable: SpViewControllerTable?
        var primaryViewController: UINavigationController
 
        //Master View is either a tableview or a webview depending on option
        if(iprop.usesTableView) {
            viewControllerMasterTable = SpViewControllerTable(itemArray: iprop.tableItems, imageArray: iprop.tableImages)
            primaryViewController = (UINavigationController(rootViewController: viewControllerMasterTable!))
            
        } else {
            viewControllerMaster = SpViewController(backgroundColor: iprop.masterBackgroundColor, page: iprop.masterURL, isEmbedded: iprop.isEmbedded)
            primaryViewController = (UINavigationController(rootViewController: viewControllerMaster!))
        }

        viewControllerDetail = SpViewControllerDetail(backgroundColor: iprop.detailBackgroundColor, page: iprop.detailURL)
        secondaryViewController = UINavigationController(rootViewController: viewControllerDetail)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.preferredDisplayMode = .allVisible
        if(iprop.fullscreen) {
            modalPresentationStyle = .fullScreen
        }
        if((iprop.leftButtonTitle) != nil) { //if there is a title, create button
        primaryViewController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: iprop.leftButtonTitle, style: .plain, target: self, action: #selector(leftButtonTapped))
         }
        if((iprop.rightButtonTitle) != nil) { //if there is a title, create button
        primaryViewController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: iprop.rightButtonTitle, style: .plain, target: self, action: #selector(rightButtonTapped))
        }
                
        //  titles
        primaryViewController.navigationBar.topItem?.title =? iprop.masterTitle
        secondaryViewController.navigationBar.topItem?.title =? iprop.detailTitle

        //  bar background
        primaryViewController.navigationBar.barTintColor = iprop.barTintColor
        secondaryViewController.navigationBar.barTintColor = iprop.barTintColor
   
        //  back etc.
        primaryViewController.navigationBar.tintColor = iprop.tintColor
        secondaryViewController.navigationBar.tintColor = iprop.tintColor

        // column width
        minimumPrimaryColumnWidth =? iprop.minimumPrimaryColumnWidth
        maximumPrimaryColumnWidth =? iprop.maximumPrimaryColumnWidth
        preferredPrimaryColumnWidthFraction =? iprop.primaryColumnWidthfraction
        
        if(iprop.displayModeButtonItem == true) {
            secondaryViewController.navigationBar.topItem?.leftBarButtonItem = displayModeButtonItem
        }
        secondaryViewController.navigationBar.topItem?.leftItemsSupplementBackButton = true

        viewControllers = [primaryViewController, secondaryViewController]
       
         if(iprop.usesTableView) {
            delegate = viewControllerMasterTable
            viewControllerMasterTable!.delegate = viewControllerDetail
        } else {
            delegate = viewControllerMaster
            viewControllerMaster!.delegate = viewControllerDetail
        }
      }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
     }
       
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resultsClosure!(viewControllerDetail.detailResults, exitPath.rawValue)
    }
        
    @objc func rightButtonTapped() {
        exitPath = DismissedBy.right
        dismiss(animated: true, completion: nil)
    }
    
    @objc func leftButtonTapped() {
        exitPath = DismissedBy.left
        dismiss(animated: true, completion: nil)
    }
}

//
// master view controller for table option
//
@objc class SpViewControllerTable: UITableViewController {
    var tableItems: [String]
    var tableImages: [String]
    
    weak var delegate: itemSelectionDelegate?
  
    init(itemArray: [String], imageArray: [String] ) {
        tableItems = itemArray
        tableImages = imageArray
        
    super.init(style: .plain)
    tableView.tableFooterView = UIView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
  
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    @objc func notifyDetail(arg: String) {
        delegate?.itemSelected(arg)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let selectedItem = tableItems[indexPath.row]

        cell.textLabel?.text = selectedItem
        cell.imageView?.image = UIImage(named: tableImages[indexPath.row])
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let svc = splitViewController as! RtViewController
        svc.showDetailViewController(svc.secondaryViewController, sender: svc)
        if let detailViewController = delegate as? UINavigationController {
            showDetailViewController(detailViewController, sender: nil)
        }
        
        let item = tableItems[indexPath.row]
        notifyDetail(arg: item)
    }
}

extension SpViewControllerTable: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
       let navigationController = secondaryViewController as? UINavigationController
       let detailViewController = navigationController?.topViewController
    
       return !(detailViewController?.isViewLoaded ?? true)
     }
}

@objc class SpViewController: CDVViewController {
    
    weak var delegate: itemSelectionDelegate?
    var initialBackgroundColor: UIColor?
    var embedded: Bool = false
    
    init(backgroundColor: UIColor?, page: String?, isEmbedded: Bool) {
        super.init(nibName: nil, bundle: nil)
        startPage = page
        initialBackgroundColor = backgroundColor
        embedded = isEmbedded
    }
   
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
       
    override func viewDidLoad() {
        if(!embedded) {
        launchView = UIView(frame: view.bounds)
        launchView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        super.viewDidLoad()
        if(!embedded) {
        launchView.backgroundColor = initialBackgroundColor
        view.addSubview(launchView)
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
    @objc func notifyDetail(arg: String ) {
        delegate?.itemSelected(arg)
    }
}

extension SpViewController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    let navigationController = secondaryViewController as? UINavigationController
    let detailViewController = navigationController?.topViewController
    return !(detailViewController?.isViewLoaded ?? true)
  }
}

//
// detail view controller for both table and webview masters
//

@objc class SpViewControllerDetail: CDVViewController {
   
    var isReady = false //detail webview recieved device ready?
    var queuedItem = "" //last selected item before device ready
    var detailResults = ""
    var initialBackgroundColor: UIColor?
   
    init(backgroundColor: UIColor?, page: String?) {
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
}

extension SpViewControllerDetail: itemSelectionDelegate {
  func itemSelected(_ theitem: String) {
    let newitem = "'" + theitem + "'"
    if (isReady) {
        commandDelegate.evalJs( "cordova.plugins.SplitView.onSelected(\(newitem));")
    } else {
     queuedItem = newitem
    }
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
public func =?<T>(variable: inout T, value: T?) {
    if let v = value {
        variable = v
    }
}
// Set value of left-hand side only if right-hand side differs from `nil`
public func =?<T>(variable: inout T?, value: T?) {
    if let v = value {
        variable = v
    }
}

