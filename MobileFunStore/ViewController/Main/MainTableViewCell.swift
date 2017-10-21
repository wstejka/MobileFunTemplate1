//
//  MainTableViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 10/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewHandler: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewHandler.sd_cancelCurrentImageLoad()
    }
}
