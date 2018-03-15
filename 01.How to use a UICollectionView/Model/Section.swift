//
//  Section.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/15.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit

class Section {
    let title: String
    var cells: [Park] = [Park]()
    init(title: String) {
        self.title = title
    }
}

