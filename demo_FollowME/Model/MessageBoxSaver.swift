//
//  MessageBoxSaver.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 21..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class MessageBoxSaver{
    
    static func save(sender: String, timeStamp: Date, lastMessage: String){
        
        var isSuccessfulSaveMessageBox = false
        
        
        //메일 박스를 불러와서
        if var messageBoxes = NSKeyedUnarchiver.unarchiveObject(withFile: MessageBox.ArchiveURL.path) as? [MessageBox] {
            //수정할건데
            //센더로 검색해서 이미 있으면 수정하고
            var alreadyHave = false
            for messageBox in messageBoxes {
                if messageBox.sender == sender {
                    print("메시지 박스 이미 있음")
                    if messageBox.timeStamp.compare(timeStamp) == ComparisonResult.orderedSame {
                        print("MessageBoxSaver : 포그라운드에서 노티를 탭 했을 때 중복 저장을 방지하기 위함")
                    }
                    else{

                        messageBox.timeStamp = timeStamp
                        messageBox.lastMessage = lastMessage
                        messageBox.badge += 1
                    }
                    alreadyHave = true
                }
            }
            //없으면 추가해서
            if !alreadyHave {
                print("해당 메시지 박스 없음")
                let newMessageBox = MessageBox.init(sender: sender, timeStamp: timeStamp, lastMessage: lastMessage, badge: 1)
                messageBoxes.append(newMessageBox)
            }
            
            //저장한다/
            isSuccessfulSaveMessageBox = NSKeyedArchiver.archiveRootObject(messageBoxes, toFile: MessageBox.ArchiveURL.path)
            
        }
        else{
            //메시지박스가 아예 없을 경우에는 새로 박스들을 만들어야합니다.
            
            var messageBoxes = [MessageBox]()
            let newMessageBox = MessageBox.init(sender: sender, timeStamp: timeStamp, lastMessage: lastMessage, badge: 1)
            messageBoxes.append(newMessageBox)
            
            print("메시지 박스 아예 없음 + \(newMessageBox.badge)")
            isSuccessfulSaveMessageBox = NSKeyedArchiver.archiveRootObject(messageBoxes, toFile: MessageBox.ArchiveURL.path)
            }
    }
    
    static func resetMessageBox(sender: String){
        var messageBoxes = NSKeyedUnarchiver.unarchiveObject(withFile: MessageBox.ArchiveURL.path) as? [MessageBox]
        //수정할건데
        //센더로 검색해서 이미 있으면 수정하고
        for messageBox in messageBoxes! {
            if messageBox.sender == sender {
                print("메시지 박스 뱃지 초기화")
                messageBox.badge = 0
            }
        }

        if NSKeyedArchiver.archiveRootObject(messageBoxes, toFile: MessageBox.ArchiveURL.path){
            print("Cool!")
        }
        else{
            print("Fuck!")
        }
    }
}
