//
//  CreateBusinessKeywordCollectionViewCell.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 09/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class CreateBusinessKeywordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var keywordLabel: UILabel!
    
    var deleteButtonClosure : (() -> Void)?
    
    @IBAction func deleteKeywordsButtonAction(_ sender: Any) {
        deleteButtonClosure?()
    }
    
}
