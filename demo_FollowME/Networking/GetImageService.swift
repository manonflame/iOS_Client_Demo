//
//  GetImageService.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 26..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class GetImageService {
    
    typealias QueryResult = (String, String) -> ()
    var imageOwnerId = ""
    var urlString = "http://192.168.219.105:8080/getImage/"
    var errorMessage = ""
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var dataTask: URLSessionDataTask?
    lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    func getImage(of owner: String, completion: @escaping QueryResult) {
        
        if owner == "EMPTY SENDER" {
            DispatchQueue.main.async {
                completion("", self.errorMessage)
            }
            return
        }
        
        var sendedURL = urlString
        sendedURL.append("\(owner)")
        let url = URL(string: sendedURL)
        dataTask = defaultSession.dataTask(with: url!){
            data, response, error in
            defer{
                self.dataTask = nil
            }
            if let error = error{
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            }
            else if let data = data,
                let response = response as? HTTPURLResponse{
                // Decode in do-try-catch
                do {
                    
                    var dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    var imageString : String
                    
                    if dictionary!["profileImage"] == nil || dictionary!["profileImage"] as! String == "Error" {
                        imageString = "empty"
                    }else{
                        imageString = dictionary!["profileImage"] as! String
                        print(imageString)
                    }
                    
                    DispatchQueue.main.async {
                        completion(imageString, self.errorMessage)
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
