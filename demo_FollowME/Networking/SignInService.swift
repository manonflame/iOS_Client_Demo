//
//  SignInService.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 14..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

class SignInService {
    
    var user: User = User(id: "", pw: "")
    var errorMessage = ""
    let url = URL(string: "http://192.168.219.105:8080/signin")!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    var delegate: signInBoxDelegate?
    

    func getUser() -> User{
        return user
    }
    
    func signIn() {
        let defaultSession = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var isSuccess: Bool = true
        do{
            let data = try encoder.encode(user)
            request.httpBody = data
            //점검용
            print("점검용 - 사인인")
            print(String(describing: data))
            
        } catch let encodeError as NSError {
            print("Encoder Error : \(encodeError.localizedDescription)\n")
        }
        
        var dataTask = defaultSession.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else{
                print("No data")
                DispatchQueue.main.async {
                    self.delegate?.singInDenied()
                }
                isSuccess = false
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("No response")
                DispatchQueue.main.async {
                    self.delegate?.singInDenied()
                }
                isSuccess = false
                return
            }
        
            do{
                var takeUser : User = User(id: "", pw: "")
                takeUser = try! self.decoder.decode(User.self, from: data)
                print(takeUser.id)
                print(takeUser.pw)
                
                if takeUser.id == "no"{
                    isSuccess = false;
                }
                
            } catch let decodeError as NSError {
                print("Decoder error: \(decodeError.localizedDescription)\n")
                return
            }
            if(isSuccess){
                print("SinginService() : accepted")
                DispatchQueue.main.async {
                    self.delegate?.signInAccepted()
                }
            }
            else{
                print("SinginService() : denied")
                DispatchQueue.main.async {
                    self.delegate?.singInDenied()
                }
            }
        }.resume()
    }
}
