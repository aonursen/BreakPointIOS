//
//  NewFeedVC.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 25.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit
import Firebase

class NewFeedVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var postUserImg: UIImageView!
    @IBOutlet weak var postUserEmail: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        postText.delegate = self
        postBtn.isEnabled = false
        postBtn.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.postUserEmail.text = Auth.auth().currentUser?.email
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        postText.text = ""
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if postText.text != "" {
            postBtn.isEnabled = true
        } else {
            postBtn.isEnabled = false
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        DataService.instance.uploadPost(message: postText.text, uid: (Auth.auth().currentUser?.uid)!, groupKey: nil) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                debugPrint("Some error occured.")
            }
        }
    }
    
    
    
}

