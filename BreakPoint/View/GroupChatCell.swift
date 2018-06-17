//
//  GroupChatCell.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 26.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit

class GroupChatCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    
    func configureCell(image: UIImage, email: String, text: String) {
        self.userImg.image = image
        self.userEmail.text = email
        self.userMessage.text = text
    }

}
