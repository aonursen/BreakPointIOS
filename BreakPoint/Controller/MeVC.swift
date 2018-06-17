//
//  MeVC.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 25.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.profileEmail.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure ?", preferredStyle: .alert)
        let logoutYes = UIAlertAction(title: "Yes", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(loginVC!, animated: true, completion: nil)
            } catch {
                debugPrint(error)
            }
        }
        let logoutNo = UIAlertAction(title: "No", style: .cancel) { (buttonTapped) in
            self.dismiss(animated: true, completion: nil)
        }
        logoutPopup.addAction(logoutYes)
        logoutPopup.addAction(logoutNo)
        present(logoutPopup, animated: true, completion: nil)
    }

}
