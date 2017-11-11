//
//  ProductViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 04/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit


class ProductViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Vars/ Const
//    
//    var productCellWidth : CGFloat! {
//        return tableView.frame.width
//    }
//    let heightToWidthFactor : CGFloat = 0.66
    let heightFactor : CGFloat = 0.8
//    var productCellHeight : CGFloat! {
//        return tableView.frame.height * heightFactor
//    }
    
    var animator : ImageZoomAnimator!
    var product : Product!
    var items : [ProductSectionItem] = []
    func indexOfItem(type : ProductItemType) -> Int? {
        
        let index = items.index(where: { (item) -> Bool in item.type == type })
        return index?.hashValue
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        
        //  Register custom section header
        tableView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        tableView.register(UINib(nibName: "ProductAttributeCell", bundle: nil), forCellReuseIdentifier: "attributeCell")
        
        // Reflect View Structure here
        let imageSectionItem = ImagesSectionItem(product : product)
        let priceWithNoteItem = PriceWithNoteSectionItem(product: product)
        let descriptionSectionItem = DescriptionSectionItem(description: product.longDescription)
        let attributesSectionItem = AttributesSectionItem(attributes: product.attributes)
        let bottomSectionItem = BottomSectionItem()
        items = [imageSectionItem, priceWithNoteItem, descriptionSectionItem, attributesSectionItem, bottomSectionItem]

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    deinit {
        log.verbose("")
    }
    
    // MARK: - Methods
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Product", bundle: nil)) -> ProductViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        return controller
    }
    
}

// MARK: - UITableViewDataSource
extension ProductViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let item = items[section]
        return item.rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = items[indexPath.section]
        switch item.type {
        case .image:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ProductImageCell {
                cell.delegate = self
                cell.item = item
                return cell
            }
        case .priceWithNote:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? ProductCell {
                cell.item = item
                return cell
            }
        case .description:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? ProductCell {
                cell.item = item
                return cell
            }
        case .attributes:
            
            if let item = item as? AttributesSectionItem,
                let cell = tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath) as? ProductAttributeCell {
                cell.attribute = item.attributes[indexPath.row]
                
                return cell
            }
        case .bottom:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? ProductCell {
                cell.item = item
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
    
}

extension ProductViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = items[indexPath.section]
        return item.cellHeight(tableSize: tableView.frame.size, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

//        var heightForHeader : CGFloat = 0.001
//        if section == sections.descriptionSection.rawValue {
//            heightForHeader = 30.0
//        }
//        if section == sections.attributesSection.rawValue {
//            heightForHeader = 30.0
//        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let item = items[section]
        return item.title
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
        
}


extension ProductViewController : ProductImageTapped {

    func product(images: [UIImage], tappedIn atIndex: Int) {
        let controller = ImageZoomingViewController.fromStoryboard()
        controller.currentIndex = atIndex
        controller.images = images
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        // Present View modally
        self.present(controller, animated: true)
    }
}

extension ProductViewController : UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator = ImageZoomAnimator(fromViewController: source)
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}


// MARK: - ProductSectionItems classes

enum ProductItemType : Int {
    case image
    case priceWithNote
    case description
    case attributes
    case bottom
}

protocol ProductSectionItem {
    
    var title : String { get }
    var type : ProductItemType { get }
    var rows : Int { get }
    func cellHeight(tableSize: CGSize, cellForRowAt indexPath: IndexPath) -> CGFloat
    
}

extension ProductSectionItem {
    
    var title : String {
        return ""
    }
    var rows : Int {
        return 1
    }
}



class ImagesSectionItem : ProductSectionItem {
    
    let heightFactor : CGFloat = 0.8
    func cellHeight(tableSize: CGSize, cellForRowAt indexPath: IndexPath) -> CGFloat {
        return tableSize.height * heightFactor
    }
    
    var type: ProductItemType {
        return .image
    }
    
    let product : Product
    init(product : Product) {
        self.product = product
    }
}

class PriceWithNoteSectionItem : ProductSectionItem {
    
    func cellHeight(tableSize: CGSize, cellForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    var type: ProductItemType {
        return .priceWithNote
    }

    let product : Product
    init(product : Product) {
        self.product = product

    }
}

class DescriptionSectionItem : ProductSectionItem {
    
    func cellHeight(tableSize: CGSize, cellForRowAt indexPath: IndexPath) -> CGFloat {
        let inset = 10.0
        let labelWidth = tableSize.width - CGFloat(2 * inset)
        let labelHeight = self.description.height(constraintedWidth: labelWidth, font: Utils.getDefaultFont(size: 13.0))
        return labelHeight
    }
    
    var type: ProductItemType {
        return .description
    }
    var title: String {
        return "Description"
    }
    
    let description : String
    init(description : String) {
        self.description = description
    }
}

class AttributesSectionItem : ProductSectionItem {
    
    func cellHeight(tableSize: CGSize, cellForRowAt indexPath: IndexPath) -> CGFloat {
        
        let attribute = attributes[indexPath.row]
        
        // Calculate cell height depends on text
        let inset = 10.0
        let labelWidth = (tableSize.width / 2) - CGFloat(1.5 * inset)
        let keyTextSize = attribute.key.height(constraintedWidth: labelWidth, font: Utils.getDefaultFont(size: 13.0))
        let valueTextSize = attribute.value.height(constraintedWidth: labelWidth, font: Utils.getDefaultFont(size: 13.0))
        
        return max(keyTextSize, valueTextSize) + 10.0

    }

    var rows: Int {
        return attributes.count
    }
    var type: ProductItemType {
        return .attributes
    }
    var title: String {
        return "Specification"
    }

    let attributes : [Attribute]
    init(attributes : [Attribute]) {
        self.attributes = attributes
    }
}

class BottomSectionItem : ProductSectionItem {
    func cellHeight(tableSize: CGSize, cellForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    var type: ProductItemType {
        return .bottom
    }
}
