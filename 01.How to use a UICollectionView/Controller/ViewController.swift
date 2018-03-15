//
//  ViewController.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/13.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dataSource = DataSource()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func setupCollectionView(){
        let width = (view.frame.size.width - 20)/3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        let longPressRecoggnizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        collectionView.addGestureRecognizer(longPressRecoggnizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        case1,直接在Storyboard的Cell连线Show segue
        //        if segue.identifier == "DetailSegue" {
        //            if let dest = segue.destination as? DetailViewController,let index = collectionView.indexPathsForSelectedItems?.first{
        //                dest.selection = collectionData[index.row]
        //            }
        //        }
        
        //        case2,在ViewController的manual连线Show segue,并且在Select方法中调用self.performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        if segue.identifier == "DetailSegue"{
            if let dest = segue.destination as? DetailViewController,
                let index = sender as? IndexPath {
                dest.park = dataSource.parkOfIndexPath(indexPath: index)
            }
        }
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        deleteBarButtonItem.isEnabled = editing
        addBarButtonItem.isEnabled = !editing
        collectionView.allowsMultipleSelection = editing
        
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
            cell.isEditting = isEditing
        }
        
        if !editing {
            navigationController?.isToolbarHidden = true
        }
        
    }
    
    override func viewLayoutMarginsDidChange() {
        setupCollectionView()
    }
    
    
}

//MARK: Method
extension ViewController{
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        //        let text = "\(collectionData.count + 1)🏆"
        //        collectionData.append(text)
        //        let index = IndexPath(row: collectionData.count - 1, section: 0)
        //        collectionView.insertItems(at: [index])
        //
        //                //如果想要批量，可以使用如下方式
        //                collectionView.performBatchUpdates({
        //                    //填写上面的代码
        //                }, completion: nil)
        collectionView.insertItems(at: [dataSource.newRandomPark()])
        
    }
    
    
    @IBAction func deleteItems(_ sender: UIBarButtonItem) {
        //        if let selected = collectionView.indexPathsForSelectedItems{
        //            let items = selected.map({$0.item}).sorted().reversed()
        //            for item in items {
        //                collectionData.remove(at: item)
        //            }
        //            collectionView.deleteItems(at: selected)
        //            navigationController?.isToolbarHidden = true
        //        }
        if let selected = collectionView.indexPathsForSelectedItems {
            dataSource.deleteItemAtIndexPaths(selected)
            collectionView.deleteItems(at: selected)
            navigationController?.isToolbarHidden = true
        }
    }
    
}

//MARK: UICollectionViewDataSource,UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfSections(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.isEditting = isEditing
        let park = dataSource.parkOfIndexPath(indexPath: indexPath)
        cell.park = park
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            self.performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomCollectionReusableView", for: indexPath) as! CustomCollectionReusableView
        header.section = dataSource.sectionOfIndexPath(indexPath: indexPath)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        navigationController?.isToolbarHidden = collectionView.indexPathsForSelectedItems?.count == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource.moveParkAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension ViewController {
    @objc func longPressAction(longPress: UILongPressGestureRecognizer){
        let point = longPress.location(in: collectionView)
        switch longPress.state {
        case .began:
            
            guard let indexPath = collectionView.indexPathForItem(at: point) else{
                return
            }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(longPress.location(in: longPress.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
            break
        }
    }
}

