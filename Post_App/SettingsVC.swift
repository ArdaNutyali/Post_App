//
//  SettingsVC.swift
//  Post_App
//
//  Created by Pixelplus Interactive on 19.08.2022.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: K.segueIdentifiers.login, sender: nil)
        } catch {
            print("Parsing Error!")
        }
    }
}
