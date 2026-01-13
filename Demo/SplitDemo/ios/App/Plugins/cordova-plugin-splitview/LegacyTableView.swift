//
//  LegacyTableView.swift
//
//  Created by jerry on 5/4/21.
//

import Foundation

//
// master view controller for table option
//
@objc class SpViewControllerTable: UITableViewController, UISplitViewControllerDelegate {
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
        if let svc = splitViewController as? RtViewControllerClassic {
            svc.showDetailViewController(svc.secondaryViewController, sender: svc)
            if let detailViewController = delegate as? UINavigationController {
                showDetailViewController(detailViewController, sender: nil)
            }
        }
        let item = tableItems[indexPath.row]
        notifyDetail(arg: item)
    }
}
