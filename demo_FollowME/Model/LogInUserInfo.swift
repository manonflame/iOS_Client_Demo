//
//  LogInUserInfo.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 17..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

final class LogInUserInfo{
    static var Instance : LogInUserInfo = {
        return LogInUserInfo()
    }()
    
    private init(){
        print("LogInUserInfo Initiate")
    }
    
    var userID = ""

    
}


