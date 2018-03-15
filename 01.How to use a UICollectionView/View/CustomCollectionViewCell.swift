//
//  CustomCollectionViewCell.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/13.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var park: Park? {
        didSet {
            if let park = park {
                self.backgroundImageView.image = UIImage(named:park.photo)
                self.titleLabel.text = park.name
                
            }
            
        }
    }
    var isEditting: Bool = false{
        didSet {
             selectionImage.isHidden = !isEditting
            if isEditting {
                selectionImage.image = isSelected ? #imageLiteral(resourceName: "Checked") : #imageLiteral(resourceName: "Unchecked")
            }else {
                isSelected = false
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectionImage.image = isSelected ? #imageLiteral(resourceName: "Checked") : #imageLiteral(resourceName: "Unchecked")
        }
    }
    
    
    
}
