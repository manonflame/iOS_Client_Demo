//
//  LogInService.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 17..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class LogInService{
    
    var user: User = User(id: "", pw: "")
    var errorMessage = ""
    let logInURL = URL(string: "http://192.168.219.105:8080/login")!
    let logOutURL = URL(string: "http://192.168.219.105:8080/logout")!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    var delegate: logInBoxDelegate?
    
    func getUser() -> User{
        return user
    }
    
    func logIn(){
        let defaultSession = URLSession.shared
        var request = URLRequest(url: logInURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let data = try encoder.encode(user)
            request.httpBody = data
            //점검용
            print("점검용 - 로그인")
            print(user.id)
            print(user.deviceToken)
            print(String(data: data, encoding: String.Encoding.utf8))
            
        }catch let encodeError as NSError{
            print("Encoder Error : \(encodeError.localizedDescription)\n")
        }
        
        var dataTask = defaultSession.dataTask(with: request){
            (data, response, error) in
            
            //받은 데이터의 문자열에 따라 각자 다른 데이터를 처리할 것.
            guard let data = data else{
                print("No data")
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("No response")
                return
            }
            
            do{

                var message = ""
                var dataDictionary : [String:AnyObject]?
                do {
                    dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                    message = dataDictionary!["result"] as! String
                    print("***asdf: \(message)")
                    
                } catch let error as NSError {
                    print(error)
                }
                
                if message == "no user" {
                    print("no user : Received")
                    DispatchQueue.main.async {
                        self.delegate?.logInDenied(message: message)
                    }
                }
                else if message == "not matched password" {
                    print("not matched password : Received")
                    DispatchQueue.main.async {
                        self.delegate?.logInDenied(message: message)
                    }
                }
                else if message == "login succeed"{
                    //로그인 성공
                    print("login Success")
                    
                    //미 수신 메시지 파싱
                    var arr = dataDictionary!["arr"] as! [[String : String]]
                    print(arr)
                    
                    //세 메시지들 붙이기
                    for msgDic in arr {
                        var sender = msgDic["sender"]
                        var strTimeStamp = msgDic["timeStamp"]
                        
                        //일단 불러오기
                        var conversation = [Message]()
                        let ArchiveURL = ChatRoomViewController.DocumentsDirectory.appendingPathComponent("\(sender!)")
                        if let savedMessage = NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [Message]{
                            conversation += savedMessage
                        }
                        
                        //타임스탬프 데이트로 바꿔야 함
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS" //Your date format
                        var date = dateFormatter.date(from: strTimeStamp!)
                        var content = msgDic["content"]
                        
                        //새 메시지
                        let newMessage = Message.init(sender: sender!, timeStamp: date!, comment: content!, isMyComment: false)
                        
                        //새 메시지 붙이기
                        conversation.append(newMessage)
                        
                        //메시지 붙이고 저장하기
                        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(conversation, toFile: ArchiveURL.path)
                        
                        //메시지 박스 최신화
                        MessageBoxSaver.save(sender: sender!, timeStamp: date!, lastMessage: content!)
                    }
                    DispatchQueue.main.async {
                        self.delegate?.logInAccepted()
                    }
                }
                else {
                    //원인을 알수 없는 로그인 에러
                    print("login Failed : Unknown Error :: \(message)")
                    DispatchQueue.main.async {
                        self.delegate?.logInDenied(message: "관리자에게 문의하세요!")
                    }
                }
            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription)\n")
                return
            }
            
            
        }.resume()
        
    }
    
    func logOut(){
        let defaultSession = URLSession.shared
        var request = URLRequest(url: logOutURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            
            let data = try encoder.encode(user)
            request.httpBody = data
            //점검용
            print("점검용 - 로그아웃")
            print(user.id)
            print(user.deviceToken)
            print(String(data: data, encoding: String.Encoding.utf8))
            
        }catch let encodeError as NSError{
            print("Encoder Error : \(encodeError.localizedDescription)\n")
        }
        
        var dataTask = defaultSession.dataTask(with: request){
            (data, response, error) in
            
            //받은 데이터의 문자열에 따라 각자 다른 데이터를 처리할 것.
            guard let data = data else{
                print("No data")
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("No response")
                return
            }
            
            do{
                var message = ""
                var dataDictionary : [String:AnyObject]?
                do {
                    dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                    message = dataDictionary!["result"] as! String
                    print("***asdf: \(message)")
                } catch let error as NSError {
                    print(error)
                }
                if message == "logout succeed"{
                    //로그인 성공
                    print("logout Success")
                }
                else {
                    //원인을 알수 없는 로그인 에러
                    print("login Failed : Unknown Error :: \(message)")
                    DispatchQueue.main.async {
                        self.delegate?.logInDenied(message: "관리자에게 문의하세요!")
                    }
                }
            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription)\n")
                return
            }
        }.resume()
    }
}
