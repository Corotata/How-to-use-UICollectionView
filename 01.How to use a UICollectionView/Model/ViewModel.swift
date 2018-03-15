
//
//  DataSource.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/14.
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

class DataSource {
    private var parks = [Park]()
    private var sections = [Section]()
    private var immutableParks = [Park]()
    
    var count: Int {
        return sections.count
    }
    

    func numberOfSections(section: Int) -> Int{
        return sections[section].cells.count
    }
    
    init() {
        parks = loadParksFromDisk()
        immutableParks = parks
        sections = loadSections(parks: parks)
    }
    
    func newRandomPark() -> IndexPath {
        let index = Int(arc4random_uniform(UInt32(immutableParks.count - 1)))
        let copyPark = Park(copying: immutableParks[index])
        
        var mSectionCount = 0
        for (i, section) in sections.enumerated() {
            if section.title == copyPark.state {
                mSectionCount = i
                section.cells.append(copyPark)
                break
            }
        }
        return IndexPath(item: sections[mSectionCount].cells.count - 1, section: mSectionCount)
    }
    
    func deleteItemAtIndexPaths(_ indexPaths: [IndexPath]){
        for indexPath in indexPaths.sorted().reversed() {
            let section = sectionOfIndexPath(indexPath: indexPath)
            section.cells.remove(at: indexPath.row)
        }
    }
    func moveParkAtIndexPath(_ sourceIndexPath: IndexPath, toIndexPath: IndexPath){
        if sourceIndexPath == toIndexPath {
            return
        }
        let fromSection = sectionOfIndexPath(indexPath: sourceIndexPath)
        let park = fromSection.cells[sourceIndexPath.row]
        fromSection.cells.remove(at: sourceIndexPath.row)
        
        let toSection = sectionOfIndexPath(indexPath: toIndexPath)
        park.state = toSection.title
        toSection.cells.insert(park, at: toIndexPath.row)
    }
    
    func parkOfIndexPath(indexPath: IndexPath) -> Park{
        return sectionOfIndexPath(indexPath: indexPath).cells[indexPath.row]
        
    }
    
    func sectionOfIndexPath(indexPath: IndexPath) -> Section {
        return sections[indexPath.section]
    }
    
    func loadSections() -> [Section]{
        return loadSections(parks: loadParksFromDisk())
    }
    
    func loadSections(parks: [Park]) -> [Section]{
        sections.removeAll()
        
        var  nationalSections: [Section] = []
        for park in parks {
            if !nationalSections.map({$0.title}).contains(park.state){
                let section = Section(title: park.state)
                nationalSections.append(section)
            }
            
            nationalSections.forEach({ (section) in
                if section.title == park.state{
                    section.cells.append(park)
                    return
                }
            })
        }
        return nationalSections
    }
    
    
    func loadParksFromDisk() -> [Park]{
        guard let path = Bundle.main.path(forResource: "NationalParks", ofType: "plist") else{
            return []
        }
        
        guard  let dictArray = NSArray(contentsOfFile: path) else {
            return []
        }
        
        var  nationalParks: [Park] = []
        for item in dictArray {
            if let dict = item as? NSDictionary{
                let park = Park(dict: dict)
                nationalParks.append(park)
            }
        }
        return nationalParks
    }
    
    
    
}
