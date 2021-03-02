//
//  DailerCell.swift
//  DailerApp
//
//  Created by Bilal on 03/09/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class DailerCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
