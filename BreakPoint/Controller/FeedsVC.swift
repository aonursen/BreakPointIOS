//
//  FirstViewController.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 24.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit

class FeedsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedsTable: UITableView!
    var feedsArray = [Feeds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedsTable.delegate = self
        feedsTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllFeeds { (returnedfeedArray) in
            self.feedsArray = returnedfeedArray.reversed()
            self.feedsTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = feedsTable.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedCell {
            let feed = feedsArray[indexPath.row]
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

