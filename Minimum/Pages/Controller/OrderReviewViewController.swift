//
//  OrderReviewViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class OrderReviewViewController: UIViewController {

    var source: String = ""
    var destination: String = ""
    var wasteImage: UIImage?
    var wasteCollector: String = ""
    
    @IBOutlet weak var wasteCollectorName: UILabel!
    @IBOutlet weak var pickUpLocation: UILabel!
    @IBOutlet weak var wasteImageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Pesanan Selesai"
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        wasteCollectorName.text = wasteCollector
        wasteImageView.image = wasteImage
        pickUpLocation.text = destination
        
        customizeButton()
    }
    
    @IBAction func finishAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindMainSegue", sender: self)
    }
    
    func customizeButton(){
        finishButton.layer.cornerRadius = 11
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
