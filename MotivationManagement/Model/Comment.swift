//
//  Comment.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/12.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

class Comment {
    //comment自体のobjectId
    var objectId: String
    //postから受け渡されたobjectId
    var postId: String
    var user: User
    var text: String
    var createDate: Date
    
    init(objectId: String, postId: String, user: User, text: String, createDate: Date) {
        self.objectId = objectId
        self.postId = postId
        self.user = user
        self.text = text
        self.createDate = createDate
    }
}
