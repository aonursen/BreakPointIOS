//
//  LoginVC.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 24.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
