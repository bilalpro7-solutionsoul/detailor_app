//
//  AddLinkButtonTableViewCell.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 26/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class AddLinkButtonTableViewCell: UITableViewCell {

    var addButtonClosure : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addSocialLinkButtonAction(_ sender: Any) {
        addButtonClosure?()
    }
    
}
