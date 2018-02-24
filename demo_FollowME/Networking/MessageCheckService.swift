//
//  MessageCheckService.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 24..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class MessageCheckService{

    
    var url = URL(string: "http://192.168.219.105:8080/checkMessage")!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var dataTask : URLSessionDataTask?
    
    func check(from: String){
        let defaultSession = URLSession.shared
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.addValue("application.json", forHTTPHeaderField: "Content-Type")
        
        do{
            let dic = ["from": from , "checker": LogInUserInfo.Instance.userID]
            
            print("checker ::\(dic)")
            let theJSONData = try?  JSONSerialization.data(withJSONObject: dic,options: .prettyPrinted)
            request.httpBody = theJSONData
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
                var message = String()
                message = String(data: data, encoding: .utf8)!
                if message == "received"{
                    print("메시지 전송완료")
                }
                else{
                    print("메시지 전송 실패 : \(message)")
                }
            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription)\n")
                return
            }
        }.resume()
    }
}
