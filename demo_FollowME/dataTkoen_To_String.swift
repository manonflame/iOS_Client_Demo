//
//  dataTkoen_To_String.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 13..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
