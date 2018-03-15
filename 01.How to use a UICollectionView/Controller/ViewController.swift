//
//  ViewController.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/13.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
//        collectionView.collectionViewLayout
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
        if segue.identifier == "DetailSegue"{
            if let dest = segue.destination as? DetailViewController,
                let index = sender as? IndexPath {
                dest.park = viewModel.parkOfIndexPath(indexPath: index)
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
        let indexPath = viewModel.newRandomPark()
        let layout = collectionView.collectionViewLayout as! CustomFlowLayout
        layout.addedItem = indexPath
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: [], animations: {
            self.collectionView.insertItems(at: [indexPath])
        }) { (finished) in
            layout.addedItem = nil
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = NSNumber(floatLiteral: -.pi)
        animation.byValue = NSNumber(floatLiteral: .pi)
        animation.duration = 1
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            cell?.layer.add(animation, forKey: "rotationAnimation")
            cell?.alpha = 1
        }) { (finished) in
           
            
        }
        
       
        
    }
    
    @IBAction func deleteItems(_ sender: UIBarButtonItem) {
        if let selected = collectionView.indexPathsForSelectedItems {
            let layout = collectionView?.collectionViewLayout as! CustomFlowLayout
            layout.deletedItems = selected
            
            viewModel.deleteItemAtIndexPaths(selected)
            collectionView.deleteItems(at: selected)
            navigationController?.isToolbarHidden = true
        }
    }
    
}

//MARK: UICollectionViewViewModel,UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSections(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.isEditting = isEditing
        let park = viewModel.parkOfIndexPath(indexPath: indexPath)
        cell.park = park
        
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        cell.layer.removeAllAnimations()
//        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
//        animation.fromValue = NSNumber(floatLiteral: -.pi)
//        animation.byValue = NSNumber(floatLiteral: .pi)
//        animation.duration = 1
//        cell.layer.add(animation, forKey: "rotationAnimation")
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            self.performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomCollectionReusableView", for: indexPath) as! CustomCollectionReusableView
        header.section = viewModel.sectionOfIndexPath(indexPath: indexPath)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        navigationController?.isToolbarHidden = collectionView.indexPathsForSelectedItems?.count == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveParkAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
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

