//
//  OrderViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var locationPickerButton: UIButton!
    
    @IBOutlet weak var orderButton: UIButton!
    
    @IBOutlet weak var wasteImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var latitudeData: Double = 0.0
    var longitudeData: Double = 0.0
    
    var address: String = ""
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Pesanan Baru"
        
        customizeElement()
        
        wasteImageViewGesture()
        
    }
    
    @IBAction func orderNowAction(_ sender: Any) {
        if wasteImageView.image == UIImage(named: "addImage") || addressLabel.text == "Tidak Ada Alamat"{
            print("fail")
            
            let alert = UIAlertController(title: "Perhatian", message: "Pilih Alamat dan Masukkan Gambar Dulu yaa", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            performSegue(withIdentifier: "orderInProgressSegue", sender: self)
        }
    }
    
    @IBAction func unwindToOrder(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? LocationViewController {
            latitudeData = sourceViewController.latPinPoint
            longitudeData = sourceViewController.longPinPoint
            address = sourceViewController.locationPickedLabel.text ?? ""
            
            print("New Lat, ", latitudeData)
            print("New Long, ", longitudeData)
            print("New Address, ", address)
            
            addressLabel.text = "\(latitudeData), \(longitudeData)"
            locationPickerButton.titleLabel?.text = "Ganti Lokasi"
        }else if let sourceViewController = sender.source as? CameraViewController{
            image = sourceViewController.image
            
            wasteImageView.image = image
        }
    }
    
    func wasteImageViewGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.wasteImageViewAction))
        wasteImageView.addGestureRecognizer(gesture)
    }
    
    @objc func wasteImageViewAction(){
        performSegue(withIdentifier: "cameraSegue", sender: self)
    }
    
    func customizeElement(){
        orderButton.layer.cornerRadius = 11
        locationPickerButton.layer.cornerRadius = 11
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "orderInProgressSegue"{
            let destination = segue.destination as! OngoingOrderViewController
            
            destination.latPinPoint = latitudeData
            destination.longPinPoint = longitudeData
            destination.image = wasteImageView.image!
            
            print("Latitude, ", latitudeData, "Longitude, ", longitudeData)
            print("PrepareForSegue: image, ", image)
        }
        
    }

}
