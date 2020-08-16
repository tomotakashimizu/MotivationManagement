//
//  User.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/12.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

class User {
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?
    
    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
    
}
