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
    var product : Product!
    var productCellWidth : CGFloat! {
        return tableView.frame.width
    }
    let heightToWidthFactor : CGFloat = 0.66
    var productCellHeight : CGFloat! {
        return productCellWidth * heightToWidthFactor
    }
    
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
        if indexPath.row == 0 {
            let productCell = tableView.dequeueReusableCell(withIdentifier: "pageCell", for: indexPath) as! ProductPageTableViewCell
            productCell.product = product
            productCell.tableCellFrameSize = CGSize(width: productCellWidth, height: productCellHeight)
            return productCell
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ProductTableViewCell
            cell.backgroundColor = .green
        }
        
        return cell
    }
    
}

extension ProductViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return productCellHeight
        }
        else {
            return 100
        }
    }
    
}


