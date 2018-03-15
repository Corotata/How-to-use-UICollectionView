//
//  CustomCollectionReusableView.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/14.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit

class CustomCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    var section: Section? {
        didSet{
            label.text = section?.title
        }
    }
}
