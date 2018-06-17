//
//  GroupUserCell.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 26.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit

class GroupUserCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    var check: Bool = true
    
    func configureCell(image: UIImage, email: String, isSelected: Bool) {
        self.userImg.image = image
        self.userEmail.text = email
        if isSelected {
            checkImage.isHidden = false
        } else {
            checkImage.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if check {
                checkImage.isHidden = false
                check = false
            } else {
                checkImage.isHidden = true
                check = true
            }
        }
    }

}
