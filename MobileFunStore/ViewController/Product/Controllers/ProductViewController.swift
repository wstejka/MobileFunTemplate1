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
    weak var value : UIView!

    // MARK: - Vars/ Const
    var product : Product!
    var productCellWidth : CGFloat! {
        return tableView.frame.width
    }
    let heightToWidthFactor : CGFloat = 0.66
    let heightFactor : CGFloat = 0.8
    var productCellHeight : CGFloat! {
//        return productCellWidth * heightToWidthFactor
        return tableView.frame.height * heightFactor
    }
    
    let imageCellIndex = 0
    let bottomImageCellPlaceholdersNumber = 1
    let detailsCellPlaceholdersNumber = 1
    let defaultFontSize : CGFloat = 13.0
    var defaultFont : UIFont {
        return UIFont(name: "AvenirNext-Regular", size: defaultFontSize)!
    }
    var animator : ImageZoomAnimator!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        //  Register custom section header
        tableView.register(UINib(nibName: "ProductPageTableViewCell", bundle: nil), forCellReuseIdentifier: "pageCell")
        tableView.register(UINib(nibName: "ProductAttributeTableViewCell", bundle: nil), forCellReuseIdentifier: "attributeCell")
        
        
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
        return imageCellIndex + 1 + detailsCellPlaceholdersNumber + product.specification.count + bottomImageCellPlaceholdersNumber
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : UITableViewCell!
        if indexPath.row < imageCellIndex {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ProductTableViewCell
            cell.backgroundColor = .blue
            
        }
        else if indexPath.row == imageCellIndex {
            let productCell = tableView.dequeueReusableCell(withIdentifier: "pageCell", for: indexPath) as! ProductPageTableViewCell
            productCell.delegate = self
            productCell.product = product
            productCell.cellFrameSize = CGSize(width: productCellWidth, height: productCellHeight)
            return productCell
        }
        else if indexPath.row == imageCellIndex + 1 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ProductTableViewCell

        }
        else if (indexPath.row > imageCellIndex + detailsCellPlaceholdersNumber) &&
            (indexPath.row <= imageCellIndex + detailsCellPlaceholdersNumber + product.specification.count) {
            
            let specIndex = indexPath.row - (imageCellIndex + detailsCellPlaceholdersNumber + 1)
            let attribute = product.specification[specIndex].first
            let attributeCell = tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath) as! ProductAttributeTableViewCell
            attributeCell.attributeKeyLabel.text = attribute?.key
            attributeCell.attributeValueLabel.text = attribute?.value
            
            return attributeCell
        }
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ProductTableViewCell
        }

        return cell
    }
    
}

extension ProductViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row < imageCellIndex {
            
            return 100.0
        }
        else if indexPath.row == imageCellIndex {
            return productCellHeight
        }
        else if indexPath.row == imageCellIndex + 1 {
                return max(100.0, tableView.frame.height - productCellHeight)
        }
        else if (indexPath.row > imageCellIndex + detailsCellPlaceholdersNumber) &&
            (indexPath.row <= imageCellIndex + detailsCellPlaceholdersNumber + product.specification.count) {
            
            let specIndex = indexPath.row - (imageCellIndex + detailsCellPlaceholdersNumber + 1)
            let attribute = product.specification[specIndex].first
//            let cellFrame = tableView.rectForRow(at: indexPath)
            

            // Calculate cell height depends on text
            let inset = 10.0
            let labelWidth = (tableView.frame.width / 2) - CGFloat(1.5 * inset)
            let keyTextSize = attribute?.key.height(constraintedWidth: labelWidth, font: defaultFont)
            let valueTextSize = attribute?.value.height(constraintedWidth: labelWidth, font: defaultFont)
            
            return max(keyTextSize!, valueTextSize!) + 5.0
        }
        
        return 100.0
    }
    
}

extension ProductViewController : ProductImageTapped {

    func product(images: [UIImage], tappedIn atIndex: Int) {
        let controller = ImageZoomingViewController.fromStoryboard()
        controller.currentIndex = atIndex
        controller.images = images
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        self.present(controller, animated: true)
//        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProductViewController : UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        log.verbose("")
        animator = ImageZoomAnimator(fromViewController: source)
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}


