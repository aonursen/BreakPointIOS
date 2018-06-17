//
//  GroupCell.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 26.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var groupMembers: UILabel!
    
    func configureCell(title: String, description: String, membersCount: Int) {
        self.groupTitle.text = title
        self.groupDescription.text = description
        self.groupMembers.text = "\(membersCount) member."
    }

}
