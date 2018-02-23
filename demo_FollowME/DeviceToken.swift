//
//  DeviceToken.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 14..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

final class DeviceToken{
    static var Instance : DeviceToken = {
        return DeviceToken()
    }()
    
    private init(){
        print("Device Singleton Initiate")
    }
    
    var token = "empty"
}
