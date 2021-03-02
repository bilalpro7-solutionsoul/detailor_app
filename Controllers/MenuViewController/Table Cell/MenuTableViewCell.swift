//
//  MenuTableViewCell.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTItile: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


