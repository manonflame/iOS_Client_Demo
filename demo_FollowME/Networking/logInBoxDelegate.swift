//
//  logInBoxDelegate.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 17..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

protocol logInBoxDelegate: class{
    func logInAccepted()
    func logInDenied(message: String)
}
