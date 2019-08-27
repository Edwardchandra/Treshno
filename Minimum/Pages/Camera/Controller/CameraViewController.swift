//
//  CameraViewController.swift
//  Minimum
//
//  Created by Nanda Mochammad on 27/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var infoBG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoBG.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundInfo")!)

    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Pilih  foto dari", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Buka Kamera", style: .default, handler: { (openCamera) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Buka Album", style: .default, handler: { (openAlbum) in
            
        }))
        
        self.present(alert, animated: true)
    }
    
    //MARK: - Choose Camera
    var nama: String?
    var nomer: Int!
    var gambarPoto: UIImage?
    var pickedImage = false
    var imageURL: URL?
    
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
            
            let date = Date()
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            
            saveImageToDisk(image: image, imageName: "Foto_Sampah_\(minutes)")
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            print("ada error bosque")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Save Image to Local
    func getDirectoryPath() -> String {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("profilPage")
        return path
    }
    
    func saveImageToDisk(image: UIImage, imageName: String)  {
        let fileManager = FileManager.default
        let path = getDirectoryPath()
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let pathUrl = URL(string: path)
        let imagePath = pathUrl!.appendingPathComponent(imageName)
        let urlString: String = imagePath.absoluteString
        print(urlString)
        let imageData = image.jpegData(compressionQuality: 0.5)
        let success = fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        print(success)
        
        imageURL = imagePath
        
    }
    

}
