//
//  FeedCell.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 25.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var feedImg: UIImageView!
    @IBOutlet weak var feedSender: UILabel!
    @IBOutlet weak var feedText: UILabel!
    
    func configureCell(image: UIImage, email: String, text: String) {
        self.feedImg.image = image
        self.feedSender.text = email
        self.feedText.text = text
    }

}
