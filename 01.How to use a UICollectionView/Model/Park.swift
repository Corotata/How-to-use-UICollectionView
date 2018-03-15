//
//  Park.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/14.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit

class Park {
    var name: String
    var state: String
    var date: String
    var photo: String
    var index: Int

    init(name: String, state: String, date: String, photo: String, index: Int) {
        self.name = name
        self.state = state
        self.date = date
        self.photo = photo
        self.index = index
    }
    
    init(dict: NSDictionary) {
        self.name = dict["name"] as! String
        self.state = dict["state"] as! String
        self.date = dict["date"] as! String
        self.photo = dict["photo"] as! String
        self.index = dict["index"] as! Int
    }
    
    convenience init(copying park: Park) {
        self.init(name: park.name, state: park.state, date: park.date, photo: park.photo, index: park.index)
    }
}
    
