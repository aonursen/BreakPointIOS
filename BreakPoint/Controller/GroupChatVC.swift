//
//  GroupChatVC.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 26.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit
import Firebase

class GroupChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var groupChatTable: UITableView!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupMembers: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    var group: Groups?
    var messages = [Feeds]()
    
    func initData(group: Groups) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupChatTable.delegate = self
        groupChatTable.dataSource = self
        messageView.bindToKeyboard()
        messageInput.addTarget(self, action: #selector (textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if messageInput.text == "" {
            sendBtn.isEnabled = false
        } else {
            sendBtn.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.groupTitle.text = group?.groupTitle
        DataService.instance.getEmailForGroup(group: group!) { (memberEmails) in
            self.groupMembers.text = memberEmails.joined(separator: ", ")
        }
        DataService.instance.REF_GROUP.observe(.value) { (snapShot) in
            DataService.instance.getAllMessagesForGroup(group: self.group!, handler: { (messagesArray) in
                self.messages = messagesArray
                self.groupChatTable.reloadData()
                
                if self.messages.count > 0 {
                    self.groupChatTable.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if messageInput.text != "" {
            DataService.instance.uploadPost(message: messageInput.text!, uid: (Auth.auth().currentUser?.uid)!, groupKey: group?.key) { (success) in
                if success {
                    self.messageInput.text = ""
                    self.sendBtn.isEnabled = false
                } else {
                    debugPrint("Some error occured.")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = groupChatTable.dequeueReusableCell(withIdentifier: "groupChatCell", for: indexPath) as? GroupChatCell {
            let feed = messages[indexPath.row]
            let image = UIImage(named: "defaultProfileImage")
            DataService.instance.getUser(uid: feed.senderId, handler: { (userName) in
                cell.configureCell(image: image!, email: userName, text: feed.content)
            })
            return cell
        } else {
            return UITableViewCell()
        }
    }
    


}
