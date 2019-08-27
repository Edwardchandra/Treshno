//
//  OrderViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var locationPickerButton: UIButton!
    
    @IBOutlet weak var orderButton: UIButton!
    
    @IBOutlet weak var wasteImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var latitudeData: Double = 0.0
    var longitudeData: Double = 0.0
    
    var address: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Order"
        
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
            
            print(latitudeData)
            print(longitudeData)
            print(address)
            
            addressLabel.text = address
        }
    }
    
    func wasteImageViewGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.wasteImageViewAction))
        wasteImageView.addGestureRecognizer(gesture)
    }
    
    @objc func wasteImageViewAction(){
        showActionSheet()
    }
    
    func camera(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary(){
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        wasteImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
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
        }
        
    }

}
