//
//  Message.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 16..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class MessageBox: NSObject, NSCoding, Codable {
    var sender = ""
    var timeStamp = Date()
    var lastMessage = ""
    var badge = 0
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("MessageBox")
    
    init(sender: String, timeStamp: Date, lastMessage: String, badge: Int){
        self.sender = sender
        self.timeStamp = timeStamp
        self.lastMessage = lastMessage
        self.badge = badge
    }
    
    
    func encode(with aCoder: NSCoder) {
        print("encoding message: \(lastMessage) , badge :\(badge)")
        aCoder.encode(sender, forKey: "sender")
        aCoder.encode(timeStamp, forKey: "timeStamp")
        aCoder.encode(lastMessage, forKey: "lastMessage")
        aCoder.encode(badge, forKey: "badge")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        print("aDecoder")
        let sender = aDecoder.decodeObject(forKey: "sender") as? String
        let timeStamp = aDecoder.decodeObject(forKey: "timeStamp") as? Date
        let lastMessage = aDecoder.decodeObject(forKey: "lastMessage") as? String
        let badge = aDecoder.decodeCInt(forKey: "badge")
        self.init(sender: sender!, timeStamp: timeStamp!, lastMessage: lastMessage!, badge: Int(badge))
    }
}
