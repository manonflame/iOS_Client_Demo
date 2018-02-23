//
//  SaveInvitationService.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 22..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class SaveInvitationService {
    
    var invitation = Invitation()
    var errorMessage = ""
    let url = URL(string: "http://192.168.219.105:8080/newInvitation")!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
//    var delegate: confirmBoxDe
    
    func confirm(){
        let defaultSession = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let data = try encoder.encode(invitation)
            request.httpBody = data
            //점검용
            print("점검용 - 초대 등록")
            print(invitation.userid)
            print(String(describing: data))
            
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
                var message = String()
                message = String(data: data, encoding: .utf8)!
                print("message : \(message)")

            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription)\n")
                return
            }
        }.resume()
        
    }
}
