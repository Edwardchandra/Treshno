//
//  CameraViewController.swift
//  Minimum
//
//  Created by Nanda Mochammad on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bgInfo: UILabel!
    
    var gambarPoto: UIImage?
    var pickedImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgInfo.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundInfo")!)

    }
    
    @IBAction func pilihFotoAction(_ sender: Any) {
        let gantiFoto = UIAlertController(title: nil, message: "Ganti foto profil", preferredStyle: .actionSheet)
        
        let ambilFoto = UIAlertAction(title: "Ambil Foto", style: .default, handler: {(_) in
            self.nyalainKamera()
            
        })
        let dariGaleri = UIAlertAction(title: "Pilih dari galeri", style: .default, handler: {(_) in
            self.pilihGambar()
        })
        
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: { (_) in
            print("cancel")
        })
        
        gantiFoto.addAction(ambilFoto)
        gantiFoto.addAction(dariGaleri)
        gantiFoto.addAction(cancel)
        
        self.present(gantiFoto, animated: true,completion: nil)
    }
    
    func nyalainKamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController,animated: true,completion: nil)
        }
    }
    
    func pilihGambar(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !pickedImage {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController,animated: true,completion: nil)
            pickedImage = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.dismiss(animated: true, completion: nil)
            
            gambarPoto = image
            
//            let date = Date()
//            let calendar = Calendar.current
//            let minutes = calendar.component(.minute, from: date)
            
//            saveImageToDisk(image: image, imageName: "Foto_Sampah_\(minutes)")
            
            
        } else {
            print("ada error bosque")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
  

}
