//
//  GroupDetailsLabelCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 29/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class GroupDetailsLabelCell : UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!

    // MARK: - Const/Vars
    var collectionView : UICollectionView?
    var shortTextVersion : Bool = true

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        log.verbose("")
        tag = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }

    // MARK: - methods
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        log.verbose("")
        
        if sender.state == .ended {
            if shortTextVersion {
                textLabel.numberOfLines = 0
                textLabel.lineBreakMode = .byWordWrapping
            } else {
                textLabel.numberOfLines = 2
                textLabel.lineBreakMode = .byTruncatingTail
            }
            shortTextVersion = !shortTextVersion
            self.tag = shortTextVersion == true ? 1 : 0
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
}
