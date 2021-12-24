//
//  RootView.swift
//
//  Created by jerry on 4/25/21.
//

import Foundation

enum SplitViewAction {
    case sendmessage, show, hide, setProperties
}
@available(iOS 14.0, *)
@objc class RtViewController: UISplitViewController, UISplitViewControllerDelegate {
    enum DismissedBy: String {
        case swipe = "0"
        case left = "1"
        case right = "2"
    }
    var viewControllerDetail: SpViewControllerDetail
    var secondaryViewController: UINavigationController
    var supplementaryViewController: UINavigationController?
    var viewControllerSupplementary: SpViewControllerSupplementary?
    var compactTabBarController: TabBarController2?
    var resultsClosure: ((_ returnString: String, String) -> Void)?
    var resultsString = ""
    var exitPath = DismissedBy.swipe //buttons will set left or right
    var viewControllerMaster: SpViewController?
    var rootProperties = ViewProps()
    var usesCompact = false
    var isClassic = true
    var isEmbedded = false
    var isDouble = true
    var isRoot = false
    @available(iOS 14.0, *)
    private(set) lazy var topColForCollapsToProposedTopCol: UISplitViewController.Column? = nil
    private(set) lazy var dispModeForExpandingToProposedDispMode: UISplitViewController.DisplayMode? = nil

    init(viewProperties: [String?]) {
        if !viewProperties.isEmpty {
            if let jsonAg = viewProperties[0] {
                if rootProperties.decodeProperties(json: jsonAg) {
                    isClassic = (rootProperties.viewProps.style == "classic") ? true : false
                    isDouble = !(rootProperties.viewProps.style == "tripleColumn")
                    isEmbedded =? rootProperties.viewProps.isEmbedded
                }
            }
        }

        var primaryViewController: UINavigationController

        viewControllerMaster = SpViewController(backgroundColor: rootProperties.backgroundColor, page: rootProperties.viewProps.primaryURL ?? PluginDefaults.primaryURL, isEmbedded: isEmbedded)
        viewControllerDetail = SpViewControllerDetail(backgroundColor: rootProperties.backgroundColor, page: rootProperties.viewProps.secondaryURL ?? PluginDefaults.secondaryURL)

        primaryViewController = (UINavigationController(rootViewController: viewControllerMaster!))
        secondaryViewController = UINavigationController(rootViewController: viewControllerDetail)

        if let propertiesString = viewProperties[1] {
                viewControllerMaster?.setProperties(props: propertiesString)
        }

        if let propertiesString = viewProperties[2] {
                viewControllerDetail.setProperties(props: propertiesString)
        }

        if !isDouble {
            viewControllerSupplementary = SpViewControllerSupplementary(backgroundColor: rootProperties.backgroundColor, page: rootProperties.viewProps.supplementaryURL ?? PluginDefaults.supplementaryURL)

            //view-specific properties override root properties
            supplementaryViewController = UINavigationController(rootViewController: viewControllerSupplementary!)
            supplementaryViewController?.navigationBar.topItem?.title =? rootProperties.viewProps.supplementaryTitle
            supplementaryViewController?.navigationBar.tintColor = rootProperties.setColor(rootProperties.viewProps.tintColor)
            supplementaryViewController?.navigationBar.barTintColor = rootProperties.setColor(rootProperties.viewProps.barTintColor)
            if  let propertiesString = viewProperties[3] {
                    viewControllerSupplementary?.setProperties(props: propertiesString)
            }
        }

            super.init(style: isDouble ? .doubleColumn : .tripleColumn)

            setSplitViewProperties()

            let sendMessage: (String, String, SplitViewAction) -> Void = { [unowned self] in
                let childViews: [String: UISplitViewController.Column] = ["primary": .primary, "secondary": .secondary, "supplementary": .supplementary, "compact": .compact]
                if $2 == SplitViewAction.sendmessage {
                    switch $0 {
                    case "primary":
                       viewControllerMaster?.getMsg(msg: $1)
                    case "secondary":
                        viewControllerDetail.getMsg(msg: $1)
                    case "supplementary":
                        viewControllerSupplementary?.getMsg(msg: $1)
                    case "compact":
                        compactTabBarController?.viewControllerCompact.getMsg(msg: $1)
                    default:
                        return
                    }
                } else if $2 == SplitViewAction.show {
                        if let childView = childViews[$0] {
                            show(childView)
                        }
                    } else if $2 == SplitViewAction.hide {
                        if let childView = childViews[$0] {
                            hide(childView)
                        }
                    } else if $2 == SplitViewAction.setProperties {
                        rootProperties.decodeProperties(json: $0)
                        setSplitViewProperties()
                    }
            }

            viewControllerMaster?.webViewMessage = sendMessage
            viewControllerDetail.webViewMessage = sendMessage
            viewControllerSupplementary?.webViewMessage = sendMessage

            primaryViewController.navigationBar.topItem?.title =? rootProperties.viewProps.primaryTitle
            secondaryViewController.navigationBar.topItem?.title =? rootProperties.viewProps.secondaryTitle
            primaryViewController.navigationBar.barTintColor = rootProperties.setColor(rootProperties.viewProps.barTintColor)
            secondaryViewController.navigationBar.barTintColor = rootProperties.setColor(rootProperties.viewProps.barTintColor)
            primaryViewController.navigationBar.tintColor =  rootProperties.setColor(rootProperties.viewProps.tintColor)
            secondaryViewController.navigationBar.tintColor =  rootProperties.setColor(rootProperties.viewProps.tintColor)

            setViewController(primaryViewController, for: .primary)
            setViewController(secondaryViewController, for: .secondary)
            if usesCompact {
                compactTabBarController =  TabBarController2(viewControllerDetail, "xx", properties: viewProperties[4])
                setViewController(compactTabBarController, for: .compact)
                compactTabBarController?.viewControllerCompact.webViewMessage = viewControllerMaster?.webViewMessage
            }
            if !isDouble {
                setViewController(supplementaryViewController, for: .supplementary)
            }
      }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
         super.viewDidLoad()
         self.delegate = self
     }

    func setSplitViewProperties() {
            let behave: [String: UISplitViewController.SplitBehavior] = ["automatic": .automatic, "displace": .displace, "overlay": .overlay, "tile": .tile]
            let displayMode: [String: UISplitViewController.DisplayMode] = ["automatic": .automatic, "secondaryOnly": .secondaryOnly, "oneBesideSecondary": .oneBesideSecondary, "oneOverSecondary": .oneOverSecondary, "twoBesideSecondary": .twoBesideSecondary, "twoOverSecondary": .twoOverSecondary, "twoDisplaceSecondary": .twoDisplaceSecondary]
            let priEdge: [String: UISplitViewController.PrimaryEdge] = ["leading": .leading, "trailing": .trailing]
            let columnType: [String: UISplitViewController.Column] = ["primary": .primary, "supplementary": .supplementary, "secondary": .secondary, "compact": .compact]

            if let splitB = rootProperties.viewProps.preferredSplitBehavior, let behaveEnum = behave[splitB] {
                preferredSplitBehavior = behaveEnum
            }
            if let splitD = rootProperties.viewProps.preferredDisplayMode, let displayEnum = displayMode[splitD] {
                preferredDisplayMode = displayEnum
            }
            if let topCol = rootProperties.viewProps.topColumnForCollapsingToProposedTopColumn {
                    topColForCollapsToProposedTopCol = columnType[topCol]
            }
            if let dispMode = rootProperties.viewProps.displayModeForExpandingToProposedDisplayMode {
                dispModeForExpandingToProposedDispMode = displayMode[dispMode]
            }
            if let primaryE = rootProperties.viewProps.primaryEdge, let priEnum = priEdge[primaryE] {
                primaryEdge = priEnum
            }

            preferredPrimaryColumnWidthFraction =? rootProperties.viewProps.primaryColumnWidthFraction
            preferredPrimaryColumnWidth =? rootProperties.viewProps.preferredPrimaryColumnWidth
            minimumPrimaryColumnWidth =? rootProperties.viewProps.minimumPrimaryColumnWidth
            maximumPrimaryColumnWidth =? rootProperties.viewProps.maximumPrimaryColumnWidth

            // =? operator will fail in this case when not triple column
            // preferredSupplementaryColumnWidthFraction =? rootProperties.viewProps.supplementaryColumnWidthFraction

            if let widFrac = rootProperties.viewProps.supplementaryColumnWidthFraction {
                preferredSupplementaryColumnWidthFraction = widFrac
            }
            if let colWid = rootProperties.viewProps.supplementaryColumnWidth {
                preferredSupplementaryColumnWidth = colWid
            }
            if let maxWid = rootProperties.viewProps.maximumSupplementaryColumnWidth {
                maximumSupplementaryColumnWidth = maxWid
            }
            if let minWid = rootProperties.viewProps.minimumSupplementaryColumnWidth {
                minimumSupplementaryColumnWidth = minWid
            }

            usesCompact =? rootProperties.viewProps.usesCompact
            presentsWithGesture =? rootProperties.viewProps.presentsWithGesture
            showsSecondaryOnlyButton =? rootProperties.viewProps.showsSecondaryOnlyButton
            if rootProperties.viewProps.fullscreen == true {
                modalPresentationStyle = .fullScreen
            }
            if rootProperties.viewProps.makeRoot == true {
                isRoot = true
            }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resultsClosure?(viewControllerDetail.detailResults, exitPath.rawValue)
    }

    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn
        proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return topColForCollapsToProposedTopCol ?? proposedTopColumn
    }
    func splitViewController(_ svc: UISplitViewController,
                             displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        return dispModeForExpandingToProposedDispMode ?? proposedDisplayMode
    }
}
