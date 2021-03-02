//
//  SearchCollectionViewCell.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: CustomView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessRating: CosmosView!
    
    @IBAction func sendButtonAction(_ sender: Any) {
    }
    
}
