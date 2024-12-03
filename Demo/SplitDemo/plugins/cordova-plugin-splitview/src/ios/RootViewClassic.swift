//
//  RootViewClassic.swift
//
//  Created by jerry on 5/16/21.
//

import Foundation

@objc class RtViewControllerClassic: UISplitViewController, UISplitViewControllerDelegate {

    enum DismissedBy: String {
        case swipe = "0"
        case left = "1"
        case right = "2"
    }

    var viewControllerDetail: SpViewControllerDetail
    var secondaryViewController: UINavigationController
    var resultsClosure: ((_ returnString: String, String) -> Void)?
    var resultsString = ""
    var exitPath = DismissedBy.swipe //buttons will set left or right

    init(iprop: InitialProperties) {

        var viewControllerMaster: SpViewController?
        var viewControllerMasterTable: SpViewControllerTable?
        var primaryViewController: UINavigationController

        //Master View is either a tableview or a webview depending on option
        if iprop.usesTableView {
            viewControllerMasterTable = SpViewControllerTable(itemArray: iprop.tableItems,
                                                              imageArray: iprop.tableImages)
            primaryViewController = (UINavigationController(rootViewController: viewControllerMasterTable!))
        } else {
            viewControllerMaster = SpViewController(backgroundColor: iprop.masterBackgroundColor,
                                                    page: iprop.masterURL,
                                                    isEmbedded: iprop.isEmbedded)
            primaryViewController = (UINavigationController(rootViewController: viewControllerMaster!))
        }

        viewControllerDetail = SpViewControllerDetail(backgroundColor: iprop.detailBackgroundColor,
                                                      page: iprop.detailURL)
        secondaryViewController = UINavigationController(rootViewController: viewControllerDetail)

        super.init(nibName: nil, bundle: nil)
        self.preferredDisplayMode = .allVisible
        if iprop.fullscreen {
            modalPresentationStyle = .fullScreen
        }
        if iprop.leftButtonTitle != nil { //if there is a title, create button
        primaryViewController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: iprop.leftButtonTitle,
                                                                                         style: .plain, target: self,
                                                                                         action: #selector(leftButtonTapped))
         }
        if iprop.rightButtonTitle != nil { //if there is a title, create button
        primaryViewController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: iprop.rightButtonTitle,
                                                                                          style: .plain, target: self,
                                                                                          action: #selector(rightButtonTapped))
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

        if iprop.displayModeButtonItem == true {
            secondaryViewController.navigationBar.topItem?.leftBarButtonItem = displayModeButtonItem
        }
        secondaryViewController.navigationBar.topItem?.leftItemsSupplementBackButton = true

        viewControllers = [primaryViewController, secondaryViewController]

         if iprop.usesTableView {
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
         self.delegate = self
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

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
      let navigationController = secondaryViewController as? UINavigationController
      let detailViewController = navigationController?.topViewController
      return !(detailViewController?.isViewLoaded ?? true)
    }
}
