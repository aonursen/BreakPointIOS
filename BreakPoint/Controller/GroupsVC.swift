//
//  SecondViewController.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 24.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupListTable: UITableView!
    
    var groupArray = [Groups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupListTable.delegate = self
        groupListTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUP.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroups) in
                self.groupArray = returnedGroups.reversed()
                self.groupListTable.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = groupListTable.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell {
            let group = groupArray[indexPath.row]
            cell.configureCell(title: group.groupTitle, description: group.groupDesc, membersCount: group.memberCount)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupVC = storyboard?.instantiateViewController(withIdentifier: "groupChatVC") as? GroupChatVC else {return}
        groupVC.initData(group: groupArray[indexPath.row])
        present(groupVC, animated: true, completion: nil)
    }
    

}

