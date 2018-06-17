//
//  NewGroupVC.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 26.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit
import Firebase

class NewGroupVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupTitle: UITextField!
    @IBOutlet weak var groupDescription: UITextField!
    @IBOutlet weak var addPeople: UITextField!
    @IBOutlet weak var userListTable: UITableView!
    @IBOutlet weak var userListLbl: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    var emailArray = [String]()
    var chosenArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userListTable.delegate = self
        userListTable.dataSource = self
        addPeople.delegate = self
        addPeople.addTarget(self, action: #selector (textFieldDidChange), for: .editingChanged)
        doneBtn.isEnabled = false
    }
    
    @objc func textFieldDidChange() {
        if addPeople.text == "" {
            doneBtn.isEnabled = false
            emailArray = []
            userListTable.reloadData()
        } else {
            doneBtn.isEnabled = true
            DataService.instance.getEmail(query: addPeople.text!, handler: { (returnedArray) in
                self.emailArray = returnedArray
                self.userListTable.reloadData()
            })
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if groupTitle.text != "" && groupDescription.text != "" {
            DataService.instance.getIds(userNames: chosenArray, hander: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(title: self.groupTitle.text!, description: self.groupDescription.text!, ids: userIds, handler: { (success) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userListTable.dequeueReusableCell(withIdentifier: "groupUserCell", for: indexPath) as? GroupUserCell else { return UITableViewCell() }
        let profileImage = UIImage(named: "defaultProfileImage")
        if chosenArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(image: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(image: profileImage!, email: emailArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = userListTable.cellForRow(at: indexPath) as? GroupUserCell else {return}
        if !chosenArray.contains(cell.userEmail.text!) {
            chosenArray.append(cell.userEmail.text!)
            userListLbl.text = chosenArray.joined(separator: ", ")
            
        } else {
            chosenArray = chosenArray.filter({$0 != cell.userEmail.text!})
            if chosenArray.count >= 1 {
                userListLbl.text = chosenArray.joined(separator: ", ")
            } else {
                userListLbl.text = "Add people to your group"
            }
        }
    }

}
