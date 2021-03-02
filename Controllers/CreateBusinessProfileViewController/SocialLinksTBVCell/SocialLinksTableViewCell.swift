//
//  SocialLinksTableViewCell.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 10/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class SocialLinksTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var linkName: UILabel!
    
    var editButtonClosure : (() -> Void)?
    var deleteButtonClosure : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func linkEditButtonAction(_ sender: Any) {
        editButtonClosure?()
    }
    
    @IBAction func linkDeleteButtonAction(_ sender: Any) {
        deleteButtonClosure?()
    }
    
}
