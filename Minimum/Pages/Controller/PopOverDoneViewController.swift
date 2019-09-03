//
//  PopOverDoneViewController.swift
//  Minimum
//
//  Created by Nanda Mochammad on 30/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class PopOverDoneViewController: UIViewController {
    
    @IBOutlet weak var viewBG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Opacity50")!)


    }
    
    @IBAction func selesaiButton(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }

}
