//
//  Message.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 16..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class Message : NSObject, NSCoding, Codable{

    var sender = ""
    var timeStamp = Date()
    var comment = ""
    var isMyComment = false

    
    init(sender: String, timeStamp: Date, comment: String, isMyComment: Bool){
        self.sender = sender
        self.timeStamp = timeStamp
        self.comment = comment
        self.isMyComment = isMyComment
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let sender = aDecoder.decodeObject(forKey: "sender") as? String
        let timeStamp = aDecoder.decodeObject(forKey: "timeStamp") as? Date
        let comment = aDecoder.decodeObject(forKey: "comment") as? String
        let isMyComment = aDecoder.decodeBool(forKey: "isMyComment")

        self.init(sender: sender!, timeStamp: timeStamp!, comment: comment!, isMyComment: isMyComment)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.sender, forKey: "sender")
        aCoder.encode(self.timeStamp, forKey: "timeStamp")
        aCoder.encode(self.comment, forKey: "comment")
        aCoder.encode(self.isMyComment, forKey: "isMyComment")
    }
    
}
