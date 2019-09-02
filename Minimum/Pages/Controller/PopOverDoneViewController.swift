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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
