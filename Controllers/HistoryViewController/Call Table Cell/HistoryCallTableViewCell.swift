//
//  HistoryCallTableViewCell.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class HistoryCallTableViewCell: UITableViewCell {

    
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var buttonsStackContainer: UIStackView!
    @IBOutlet weak var wordViewContainer: CustomView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var callTypeLabel: UILabel!
    
    var infoButtonClosure : (() -> Void)?
    var saveButtonClosure : (() -> Void)?
    var blockButtonClosure : (() -> Void)?
    var callButtonClosure : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.infoImage.image = self.infoImage.image?.withRenderingMode(.alwaysTemplate)
        self.infoImage.tintColor = #colorLiteral(red: 0.1538252234, green: 0.2240419388, blue: 0.3633548617, alpha: 1)
        self.callImage.image = self.callImage.image?.withRenderingMode(.alwaysTemplate)
        self.callImage.tintColor = #colorLiteral(red: 0.1538252234, green: 0.2240419388, blue: 0.3633548617, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func infoButtonAction(_ sender: Any) {
        infoButtonClosure?()
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        saveButtonClosure?()
    }
    @IBAction func blockButtonAction(_ sender: Any) {
        blockButtonClosure?()
    }
    @IBAction func callButtonAction(_ sender: Any) {
        callButtonClosure?()
    }
}
