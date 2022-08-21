//
//  ViewController.swift
//  Post_App
//
//  Created by Pixelplus Interactive on 19.08.2022.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordText.isSecureTextEntry = true
    }

    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                }
                else {
                    self.performSegue(withIdentifier: K.segueIdentifiers.feed, sender: nil)
                }
            }
        }
        else {
            self.makeAlert(titleInput: "Error!", messageInput: "Lütfen Gerekli Alanları Doldurunuz!")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                }
                else {
                    let firestore = Firestore.firestore()
                    let userDictionary = ["email" : self.emailText.text!, "password" : self.passwordText.text!]
                    firestore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                        }
                        else {
                            self.makeAlert(titleInput: "Kaydınız Başarıyla Yapıldı!", messageInput: "Sisteme Giriş Yapabilirsiniz.")
                        }
                    }
                }
            }
        }
        else {
            self.makeAlert(titleInput: "Error!", messageInput: "Lütfen Gerekli Alanları Doldurunuz!")
        }
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

