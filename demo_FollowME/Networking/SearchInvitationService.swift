//
//  SearchInvitationService.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 19..
//  CopyrighÏ © 2018년 민경준. All rights reserved.
//

import Foundation

class SearchInvitationService {
    
    typealias QueryResult = ([Invitation]?, String) -> ()
    var invitations = [Invitation]()
    var errorMessage = ""
    var urlString = "http://192.168.219.105:8080/searchInvitations/"
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var dataTask: URLSessionDataTask?
    lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    func searchInvitations(city: String, completion: @escaping QueryResult) {
        var sendedURL = urlString
        sendedURL.append("\(city)")
        print("urlcheck :: \(sendedURL)")
        let url = URL(string: sendedURL)
        dataTask = defaultSession.dataTask(with: url!){ data, response, error in
            defer {
                self.dataTask = nil
            }
            //에러가 있다면 처리
            if let error = error{
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            }//에러가 없다면 데이터를 보고 리스폰스의 상태 코드를 보고 아무 문제가 없으면 do 문장을 수행
            else if let data = data,
                let response = response as? HTTPURLResponse{
                // Decode in do-try-catch
                do {
                    self.invitations = try self.decoder.decode([Invitation].self, from: data)
                    for x in self.invitations {
                        print("inService---")
                        print(x.city)
                    }
                    DispatchQueue.main.async {
                        completion(self.invitations, self.errorMessage)
                    }
                    
                } catch let decodeError as NSError{
                    //디코딩 에러가 발생시 사용
                    self.errorMessage += "Decoder Error : \(decodeError.localizedDescription)"
                    return
                }
            }
        }
        dataTask?.resume()
    }
    
    
}
