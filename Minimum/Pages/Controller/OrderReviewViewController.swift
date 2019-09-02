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
//        self.navigationItem.setHidesBackButton(true, animated:true)
//        self.navigationItem.title = ""
        
        let cancelButton = UIBarButtonItem.init(image: UIImage(named: "unavailable"), style: .plain, target: self, action: #selector(cancelAction))
        
        self.navigationController?.navigationItem.leftBarButtonItem = cancelButton
        
        wasteCollectorName.text = wasteCollector
        wasteImageView.image = wasteImage
        pickUpLocation.text = destination
        
        customizeButton()
    }
    
    @objc func cancelAction(){
        let alert = UIAlertController(title: "Perhatian", message: "Apakah anda ingin membatalkan pengambilan sampah?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keluar", style: .cancel, handler: { (back) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Tidak", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func finishAction(_ sender: Any) {
//        performSegue(withIdentifier: "unwindToMainPage", sender: self)
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
