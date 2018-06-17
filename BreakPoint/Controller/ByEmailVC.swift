//
//  LoginByEmailVC.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 24.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit

class ByEmailVC: UIViewController {

    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if emailField.text != nil && passwordField != nil {
            AuthService.instance.loginUser(email: emailField.text!, password: passwordField.text!, completion: { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint("Login failed")
                }
                
                AuthService.instance.registerUser(email: self.emailField.text!, password: self.passwordField.text!, completion: { (success, error) in
                    if success {
                        AuthService.instance.loginUser(email: self.emailField.text!, password: self.passwordField.text!, completion: { (success, error) in
                            if success {
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                debugPrint("Register success but login failed.")
                            }
                        })
                    } else {
                        debugPrint("Register failed.")
                    }
                })
                
            })
            
        }
    }

}
