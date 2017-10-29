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
    var collectionView : UICollectionView?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        log.verbose("")
//        longDescription.backgroundColor = .orange
//        longDescription.textColor = .black
        tag = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - methods
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        log.verbose("")
        
        if sender.state == .ended {
            let descriptionTapped = longDescription.touched(in: sender.location(in: self))
            if descriptionTapped == true {
                if isShortDescription {
                    longDescription.numberOfLines = 0
                    longDescription.lineBreakMode = .byWordWrapping
                } else {
                    longDescription.numberOfLines = 2
                    longDescription.lineBreakMode = .byTruncatingTail
                }
                isShortDescription = !isShortDescription
                self.tag = isShortDescription == true ? 1 : 0
                collectionView?.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        log.verbose("")
//    }
    
}
