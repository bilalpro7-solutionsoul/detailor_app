//
//  OtherLinksTableViewCell.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 10/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class OtherLinksTableViewCell: UITableViewCell {

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
    @IBAction func deleteButtonAction(_ sender: Any) {
        deleteButtonClosure?()
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        editButtonClosure?()
    }
    
}
