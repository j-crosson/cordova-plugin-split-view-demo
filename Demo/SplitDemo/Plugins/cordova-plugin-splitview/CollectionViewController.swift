//
//  CollectionViewController.swift
//  
//  Created by jerry on 4/27/22.
//

import UIKit

@available(iOS 14.0, *)
func createLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout {section, layoutEnvironment in
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.headerMode = section == 0 ? .none : .firstItemInSection
        return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
    }
}

private let reuseIdentifier = "Cell"

@available(iOS 14.0, *)
private var childProperties = ViewProps()

struct CollectionMessage: Codable {

    struct Select: Codable {
        var section: Int?
        var row: Int?
        var scrollPosition: String?
    }

    var id: String?
    var select: Select?
}

class SpCollectionViewController: UICollectionViewController {

    @available(iOS 14.0, *)
    private(set) lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil

    private var navBarPrefersLargeTitles = false
    private var initialSection = 0
    private var initialRow = 0
    private var sectionItemCount: [Int] = []
    private var clearsSelection = false
    private var messageTargets: [String] = []

    var collectionData = [Section]()
    var webViewMessage: ((String, String, SplitViewAction) -> Void)?

    init(properties: String?, collectionViewLayout: UICollectionViewLayout) {

        super.init(collectionViewLayout: collectionViewLayout)

        if #available(iOS 14.0, *) {
            if let props = properties {
                setProperties(props: props)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = clearsSelection
        // Register cell classes, not really used yet
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionItemCount.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionItemCount[section]
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Configure cell
        return cell
    }

    let scrollPosition: [String: UICollectionView.ScrollPosition] = ["top": .top, "bottom": .bottom, "centeredVertically": .centeredVertically]

    @available(iOS 14.0, *)
    func getMsg(msg: String) {
        var collectionMessage =  CollectionMessage()
        guard let jsonData = msg.data(using: .utf8) else {
                return
        }
        do {
            collectionMessage = try JSONDecoder().decode(CollectionMessage.self, from: jsonData)

            guard let msg = collectionMessage.id, let row = collectionMessage.select?.row, let section = collectionMessage.select?.section  else {
                return
            }
            switch msg {
            case "selectListItem" :
                // See if section is expanded.  Selecting hidden row will crash
                var snap = dataSource.snapshot(for: collectionData[section])
                if let itemID = dataSource.itemIdentifier(for: IndexPath(row: 0, section: section)) {
                    //expandable section?
                    let snap1 = snap.snapshot(of: itemID, includingParent: false)
                    let expandable = snap1.items.count > 0
                    if expandable {
                        if !snap.isExpanded(itemID) {
                            snap.expand([itemID])
                            dataSource.apply(snap, to: collectionData[section])
                        }
                    }
                }

                if let scrollPos = collectionMessage.select?.scrollPosition, let scrollOption = scrollPosition[scrollPos] {
                    collectionView?.selectItem( at: IndexPath(row: row, section: section), animated: false, scrollPosition: scrollOption)
                } else {
                collectionView?.selectItem( at: IndexPath(row: row, section: section), animated: false, scrollPosition: [])
                }
            default:
                return
            }
        } catch {
            return
        }
    }

    @available(iOS 14.0, *)
    func setNavProperties() {
        guard let navController = navigationController else {
            return
        }
        navBarPrefersLargeTitles = childProperties.setNavBarAppearance(navController, appearance: childProperties.viewProps.navBarAppearance)

        if navBarPrefersLargeTitles {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        } else {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
        collectionView?.selectItem( at: IndexPath(row: initialRow, section: initialSection), animated: false, scrollPosition: [])
    }

    @available(iOS 14.0, *)
    func setProperties (props: String) {
        if props.isEmpty {
            return
        }
        guard  childProperties.decodeProperties(json: props) else {
            return
        }

        initialSection =? childProperties.viewProps.views?.primaryCollection?.config?.initialSection
        initialRow =? childProperties.viewProps.views?.primaryCollection?.config?.initialRow
        messageTargets =? childProperties.viewProps.views?.primaryCollection?.config?.messageTargets
        clearsSelection =? childProperties.viewProps.views?.primaryCollection?.config?.clearsSelection

        if let secs = childProperties.viewProps.views?.primaryCollection?.sections {
            for section in secs {
                if let sectionItems = section.listItems {
                    var sItem = [Item]()
                    for sectionItem in sectionItems {
                        sItem.append(Item(title: sectionItem.listText, image: newImage(image: sectionItem.listImage)))
                    }
                    let cSection = Section(title: section.header, items: sItem)
                    collectionData.append(cSection)
                    sectionItemCount.append(cSection.items.count)
                }
            }
        }
    }

     func configureDataSource() {
         // Configure cells
        if #available(iOS 14.0, *) {
            let headerRegistration = UICollectionView.CellRegistration <UICollectionViewListCell, Item> {(cell, indexPath, item) in
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                cell.contentConfiguration = content
                cell.accessories = [.outlineDisclosure()]
            }

         let cellRegistration = UICollectionView.CellRegistration <UICollectionViewListCell, Item> {(cell, indexPath, item) in
             var content = cell.defaultContentConfiguration()
             content.text = item.title
             content.image = item.image
             cell.contentConfiguration = content
             cell.accessories = []
         }

         // Create datasource
         dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView!) {
             (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
             if indexPath.item == 0 && indexPath.section != 0 {
                 return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
             } else {
                 return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
             }
         }

        for collectionSection in collectionData {
            if collectionSection.title != nil {
                let headerItem = Item(title: collectionSection.title, image: nil)
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
                sectionSnapshot.append([headerItem])
                sectionSnapshot.append(collectionSection.items, to: headerItem)
                sectionSnapshot.expand([headerItem])
                dataSource.apply(sectionSnapshot, to: collectionSection)
            } else {
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
                sectionSnapshot.append(collectionSection.items)
                dataSource.apply(sectionSnapshot, to: collectionSection)
            }
        }
     }
 }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectItem = CollectionMessage(id: CollectionEvents.selectedListItem.rawValue, select: CollectionMessage.Select(section: indexPath.section, row: indexPath.row))
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(selectItem)
            if let jsonString = String(data: data, encoding: .utf8) {
                for message in messageTargets {
                webViewMessage?(message, jsonString, .listItemSelected)
                }
            }
        } catch { // we could forward an error message here
        }
    }
}

struct Item: Hashable {
    let title: String?
    let image: UIImage?
    private let identifier = UUID()
}

class Section: Hashable {
    var id = UUID()
    var title: String?
    var items: [Item]

    init(title: String?, items: [Item]) {
        self.title = title
        self.items = items
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Section, rhs: Section) -> Bool {
         lhs.id == rhs.id
    }
}
