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
    var productCellHeight : CGFloat! {
        return productCellWidth * heightToWidthFactor
    }
    
    let imageCellIndex = 0
    
    var animator : ImageZoomAnimator!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  Register custom section header
        tableView.register(UINib(nibName: "ProductPageTableViewCell", bundle: nil), forCellReuseIdentifier: "pageCell")
        
        
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
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : UITableViewCell!
        if indexPath.row == imageCellIndex {
            let productCell = tableView.dequeueReusableCell(withIdentifier: "pageCell", for: indexPath) as! ProductPageTableViewCell
            productCell.delegate = self
            productCell.product = product
            productCell.cellFrameSize = CGSize(width: productCellWidth, height: productCellHeight)
            return productCell
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ProductTableViewCell
        }
        
        return cell
    }
    
}

extension ProductViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == imageCellIndex {
            return productCellHeight
        }
        else {
            return 100
        }
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


