//
//  DataService.swift
//  BreakPoint
//
//  Created by Arif Onur Şen on 24.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import Foundation
import Firebase

let DB = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB
    private var _REF_USERS = DB.child("users")
    private var _REF_GROUPS = DB.child("group")
    private var _REF_FEED = DB.child("feed")
    
    var REF_USER: DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUP: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USER.child(uid).updateChildValues(userData)
    }
    
    func getUser(uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(message: String, uid: String, groupKey: String?, completion: @escaping completionHandler) {
        if groupKey != nil {
            REF_GROUP.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            completion(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            completion(true)
        }
    }
    
    func getAllMessagesForGroup(group: Groups, handler: @escaping (_ messagesArray: [Feeds]) -> ()) {
        var messagesArray = [Feeds]()
        REF_GROUP.child(group.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for message in groupMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let feed = Feeds(content: content, senderId: senderId)
                messagesArray.append(feed)
            }
            handler(messagesArray)
        }
    }
    
    func getAllFeeds(handler: @escaping (_ messages: [Feeds]) -> ()) {
        var feedArray = [Feeds]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let feed = Feeds(content: content, senderId: senderId)
                feedArray.append(feed)
            }
            
            handler(feedArray)
        }
    }
    
    func getEmail(query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USER.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getEmailForGroup(group: Groups, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USER.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(userNames: [String], hander: @escaping (_ uidArray: [String]) -> ()) {
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if userNames.contains(email) {
                    idArray.append(user.key)
                }
            }
            hander(idArray)
        }
    }
    
    func createGroup(title: String, description: String, ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUP.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groups: [Groups]) -> ()) {
        var groupArray = [Groups]()
        REF_GROUP.observeSingleEvent(of: .value) { (groupsSnapshot) in
            guard let groupsSnapshot = groupsSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupsSnapshot {
                let members = group.childSnapshot(forPath: "members").value as! [String]
                if members.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let group = Groups(groupTitle: title, groupDesc: description, key: group.key, memberCount: members.count, members: members)
                    groupArray.append(group)
                }
            }
            handler(groupArray)
        }
    }
    
}
