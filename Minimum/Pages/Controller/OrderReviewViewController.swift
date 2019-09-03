//
//  OrderReviewViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import CloudKit

class OrderReviewViewController: UIViewController {

    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    let database = CKContainer.default().privateCloudDatabase
    
    var destination: String = ""
    var wasteImage: UIImage?
    var wasteCollector: String = ""
    var currentDate: String = ""
    var currentTime: String = ""
    var url: URL!
    var email: String = ""
    
    var flag: Int = 0
    
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
        email = UserDefaults.standard.string(forKey: "emailUser") ?? ""
        
        customizeButton()
        let data = wasteImage!.jpegData(compressionQuality: 0.1)
        
        url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data!.write(to: url!, options: [])
        } catch let e as NSError {
            print("Error! \(e)");
            return
        }
        
        print(wasteCollector)
        print(destination)
        print(currentTime)
        print(currentDate)
        print(CKAsset(fileURL: url!))
        
        saveToCloudKit(name: wasteCollector, dest: destination, currDate: currentDate, currTime: currentTime, image: CKAsset(fileURL: url!), email: email)
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
        
        if flag == 1{
            performSegue(withIdentifier: "unwindToMainPage", sender: self)
        } else if flag == 2 {
            saveToCloudKit(name: self.wasteCollector, dest: self.destination, currDate: self.currentDate, currTime: self.currentTime, image: CKAsset(fileURL: url!), email: email)
        }
    }
    
    func customizeButton(){
        finishButton.layer.cornerRadius = 11
    }
    
    //MARK: Save data to CloudKit
    func saveToCloudKit(name: String, dest: String, currDate: String, currTime: String, image: CKAsset, email: String){
        
        print("Uploading to Cloudkit")
        
        let newHistory = CKRecord(recordType: "History")
        
        newHistory.setValue(name, forKey: "name")
        newHistory.setValue(dest, forKey: "destination")
        newHistory.setValue(currDate, forKey: "date")
        newHistory.setValue(currTime, forKey: "time")
        newHistory.setValue(image, forKey: "image")
        newHistory.setValue(email, forKey: "email")
        
        DispatchQueue.global().async {
            self.database.save(newHistory) { (record, error) in
                guard record != nil else {
                    print("Error found", error)
                    self.flag = 2
                    return
                }
                print("success")
                self.flag = 1
                
            }
        }
    }
    
    public func EnableButton()
    {
        self.finishButton.isEnabled = true
        self.finishButton.backgroundColor = #colorLiteral(red: 0.9338529706, green: 0.314417243, blue: 0.05114612728, alpha: 1)
    }
}

extension OrderReviewViewController{
    override func viewWillAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "show_popup", sender: self)
    }
}
