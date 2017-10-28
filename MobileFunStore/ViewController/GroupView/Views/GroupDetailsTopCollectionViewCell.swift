//
//  GroupDetailsTopCollectionViewCEll.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 25/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class GroupDetailsTopCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var shortDecription: UILabel!
    @IBOutlet weak var longDescription: UILabel!
    
    // MARK: - Const/Vars
    private var isShortDescription : Bool = true
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        log.verbose("")
        longDescription.backgroundColor = .orange
        longDescription.textColor = .black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - methods
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        log.verbose("")
        
        if sender.state == .ended {
            log.verbose("touched: \(longDescription.touched(in: sender.location(in: self)))")
            if isShortDescription {
                
            } else {
                
            }
            
            isShortDescription = !isShortDescription
        }
    }
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        log.verbose("")
//    }
    
}
