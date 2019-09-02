//
//  OrderViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var locationPickerButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var wasteImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var plastikButton: UIButton!
    @IBOutlet weak var kertasButton: UIButton!
    @IBOutlet weak var metalButton: UIButton!
    @IBOutlet weak var kacaButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var catatanTF: UITextField!
    
    var latitudeData: Double = 0.0
    var longitudeData: Double = 0.0
    
    var address: String = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeElement()
        wasteImageViewGesture()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(){
        catatanTF.endEditing(true)
    }
    
    var isTappedPlastik = false
    var isTappedKertas = false
    var isTappedMetal = false
    var isTappedKaca = false

    @IBAction func jenisTouch(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            print("Tapped - ", sender.titleLabel?.text!)
            if isTappedPlastik == false{
                changeUISelected(sender: sender)
                isTappedPlastik = !isTappedPlastik
            }else{
                changeUIUnSelected(sender: sender)
                isTappedPlastik = !isTappedPlastik
            }
        case 1:
            print("Tapped - ", sender.titleLabel?.text!)
            if isTappedKertas == false{
                changeUISelected(sender: sender)
                isTappedKertas = !isTappedKertas
            }else{
                changeUIUnSelected(sender: sender)
                isTappedKertas = !isTappedKertas
            }
        case 2:
            print("Tapped - ", sender.titleLabel?.text!)
            if isTappedMetal == false{
                changeUISelected(sender: sender)
                isTappedMetal = !isTappedMetal
            }else{
                changeUIUnSelected(sender: sender)
                isTappedMetal = !isTappedMetal
            }
        default:
            print("Tapped - ", sender.titleLabel?.text!)
            if isTappedKaca == false{
                changeUISelected(sender: sender)
                isTappedKaca = !isTappedKaca
            }else{
                changeUIUnSelected(sender: sender)
                isTappedKaca = !isTappedKaca
            }

        }
    }
    
    func changeUISelected(sender: UIButton){
        sender.setBackgroundImage(UIImage(named: "BG_Selected"), for: .normal)
        sender.setTitleColor(#colorLiteral(red: 0.9359218478, green: 0.3116736412, blue: 0.05137557536, alpha: 1), for: .normal)
    }
    func changeUIUnSelected(sender: UIButton){
        sender.setBackgroundImage(UIImage(named: "BG_Unselected"), for: .normal)
        sender.setTitleColor(#colorLiteral(red: 0.6979793906, green: 0.6980790496, blue: 0.6979478598, alpha: 1), for: .normal)
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
            address = sourceViewController.locationDetail
            
            print("New Lat, ", latitudeData)
            print("New Long, ", longitudeData)
            print("New Address, ", address)
            
            addressLabel.text = address
//            locationPickerButton.titleLabel?.text = "Ganti Lokasi"
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
            destination.destinationLocationData = addressLabel.text!
            
            print("Latitude, ", latitudeData, "Longitude, ", longitudeData)
            print("PrepareForSegue: image, ", image)
        }
        
    }

}

extension OrderViewController{
    @objc func adjustForKeyboard(notification: Notification){
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            scrollView.contentInset = UIEdgeInsets.zero
        }else{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }
    
    //return at keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func unwindToMainPage(segue: UIStoryboardSegue){
        plastikButton.setBackgroundImage(UIImage(named: "BG_Unselected"), for: .normal)
        kertasButton.setBackgroundImage(UIImage(named: "BG_Unselected"), for: .normal)
        metalButton.setBackgroundImage(UIImage(named: "BG_Unselected"), for: .normal)
        kacaButton.setBackgroundImage(UIImage(named: "BG_Unselected"), for: .normal)

        plastikButton.setTitleColor(#colorLiteral(red: 0.6979793906, green: 0.6980790496, blue: 0.6979478598, alpha: 1), for: .normal)
        kertasButton.setTitleColor(#colorLiteral(red: 0.6979793906, green: 0.6980790496, blue: 0.6979478598, alpha: 1), for: .normal)
        metalButton.setTitleColor(#colorLiteral(red: 0.6979793906, green: 0.6980790496, blue: 0.6979478598, alpha: 1), for: .normal)
        kacaButton.setTitleColor(#colorLiteral(red: 0.6979793906, green: 0.6980790496, blue: 0.6979478598, alpha: 1), for: .normal)
        
        wasteImageView.image = UIImage(named: "addImage")
        addressLabel.text = "Belum menentukan alamat"
        
        catatanTF.text = ""

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9359218478, green: 0.3116736412, blue: 0.05137557536, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9399943352, green: 0.3158932626, blue: 0.0476225093, alpha: 1)
//        self.navigationController?.navigationBar.col
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = false
    }
}
