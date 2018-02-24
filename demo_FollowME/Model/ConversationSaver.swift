//
//  ConversationSaver.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 21..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class ConversationSaver{
    static func save(sender: String, timeStamp: String, message: String){
        
        print("save :: \(message)")
        //데이터 아카이브에 센더에 맞춰서 저장하기
        //일단 불러오기
        var conversation = [Message]()
        let ArchiveURL = ChatRoomViewController.DocumentsDirectory.appendingPathComponent("\(sender)")
        if let savedMessage = NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [Message]{
            conversation += savedMessage
        }
        
        //메시지 붙이기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS" //Your date format
        var date = dateFormatter.date(from: timeStamp)
        
        
        var lastTimeStamp = ""
        if conversation.count != 0 {
            lastTimeStamp = dateFormatter.string(from: conversation[conversation.count - 1].timeStamp)
            
        }
  
        if lastTimeStamp != timeStamp{
            let newMessage = Message.init(sender: String(sender), timeStamp: date!, comment: String(message), isMyComment: false)
            conversation.append(newMessage)
            
            //메시지 붙이고 저장하기
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(conversation, toFile: ArchiveURL.path)
        }
        else{
            print("ConversationSaver : 포그라운드에서 노티를 탭 했을 때 중복 저장을 방지하기 위함")
            //메인스레드에서 루트 뷰 컨트롤러 변경
            DispatchQueue.main.async {
                Switcher.openChatRoom(with: String(sender))
            }
        }
    }
    
}
