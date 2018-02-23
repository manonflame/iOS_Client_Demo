//
//  GetInvitationService.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 20..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class GetInvitationService {
    
    typealias QueryResult = (Invitation?, String) -> ()
    var invitation = Invitation()
    var errorMessage = ""
    
    var urlString = "http://192.168.219.105:8080/getInvitaion/"
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var dataTask: URLSessionDataTask?
    lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    func getInvitation(city: String, user: String, completion: @escaping QueryResult) {
        
        print("getInvitation()")
        var sendedURL = urlString
        sendedURL.append(city)
        sendedURL.append("/")
        sendedURL.append(user)
        print("urlcheck :: \(sendedURL)")
        let url = URL(string: sendedURL)
        dataTask = defaultSession.dataTask(with: url!){
            data, response, error in defer {
                self.dataTask = nil
            }
            print("do state of dataTask")
            if let error = error {
                self.errorMessage += "DataTas Error : " + error.localizedDescription + "\n"
            }
            else if let data = data, let response = response as? HTTPURLResponse {
                do{
                    self.invitation = try self.decoder.decode(Invitation.self, from: data)
                    
                    //받은 invitation점검
                    print("received invitation :: \(self.invitation.city)")
                    print("received invitation :: \(self.invitation.userid)")
                    print("received invitation :: \(self.invitation.languages)")
                    
                    DispatchQueue.main.async {
                        completion(self.invitation, self.errorMessage)
                    }
                    
                    
                }catch let decodeError as NSError {
                    //디코딩 에러가 발생시 사용
                    self.errorMessage += "Decoder Error : \(decodeError.localizedDescription)"
                    return
                }
            }
        }
        dataTask?.resume()
    }
    
    
    
    
}
