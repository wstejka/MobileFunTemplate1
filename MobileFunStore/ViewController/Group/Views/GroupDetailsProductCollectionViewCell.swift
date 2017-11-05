//
//  GroupDetailsProductCollectionViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 03/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class GroupDetailsProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    
    // MARK: Vars/Consts
    var product : Product? {
        didSet {
            
            guard let product = product else { return }
            shortDescription.text = product.title
            price.text = "price: " + String(product.price)
            // Get first image from image's array
            if product.urls.count == 0 { return }
            let url = URL(string: product.urls[0])
            imageView.sd_setImage(with: url)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        log.verbose("")
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
//        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(tapGesture)
    }

//    // MARK: - Methods
//    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
//        log.verbose("")
//        
//    }

    
}
