//
//  GroupDetailsImageCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 25/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class GroupDetailsImageCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Const/Vars
    var group : Group! {
        didSet {
            guard let url = URL(string: group.url) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        log.verbose("")
        
    }
    
}
