//
//  ViewController.swift
//  Lunasin
//
//  Created by Prayudi Satriyo on 31/07/19.
//  Copyright © 2019 Techrity. All rights reserved.
//

import UIKit
import CloudKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {

    let database = CKContainer.default().privateCloudDatabase
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customizeSignUpButton()
        _ = NotificationCenter.default
      
        
        fullNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    //viewTapped
    @objc func viewTapped (){
        fullNameTF.endEditing(true)
        emailTF.endEditing(true)
        passwordTF.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    func saveToCloudKit(fullname : String, email : String, password : String){
        let newID = CKRecord(recordType: "Account")
        newID.setValue(fullname, forKey: "fullname")
        newID.setValue(email, forKey: "email")
        newID.setValue(password, forKey: "password")
        
        database.save(newID) { (record, error) in
            guard record != nil else {
                print("error cuy", error)
                return}
            print("success")
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if fullNameTF.text == "" || emailTF.text == "" || passwordTF.text == ""  {
            let alertController = UIAlertController(title: "Perhatian", message:
                "Silakan isi semua field", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            saveToCloudKit(fullname: fullNameTF.text!, email: emailTF.text!, password: passwordTF.text!)
            
            let alertController = UIAlertController(title: "Daftar Berhasil", message:
                "Selamat nih daftar kamu berhasil!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (done) in
                
                self.performSegue(withIdentifier: "mainSegue", sender: self)
                
                UserDefaults.standard.set(self.emailTF.text!, forKey: "emailUser")
                UserDefaults.standard.set(self.passwordTF.text!, forKey: "passwordUser")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")

                
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func customizeSignUpButton(){
        signUpButton.layer.cornerRadius = 11
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

