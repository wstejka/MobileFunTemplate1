//
//  ProductAttributeTableViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 07/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ProductAttributeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var attributeKeyLabel: UILabel!
    @IBOutlet weak var attributeValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
