//
//  DetailViewController.swift
//  01.How to use a UICollectionView
//
//  Created by Corotata on 2018/3/13.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var park: Park!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()


        label.text = park.name
        stateLabel.text = park.state
        dateLabel.text = park.date
        imageView.image = UIImage(named: park.photo)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

