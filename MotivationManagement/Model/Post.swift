//
//  Post.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/12.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

class Post {
    var objectId: String
    var user: User
    var imageUrl: String?
    var text: String
    var createDate: Date
    var isLiked: Bool?
    var comments: [Comment]?
    var likeCount: Int = 0
    
    var diaryDate: String
    var star: Double
    
    
    init(objectId: String, user: User, text: String, createDate: Date, diaryDate: String, star: Double) {
        self.objectId = objectId
        self.user = user
        //self.imageUrl = imageUrl
        self.text = text
        self.createDate = createDate
        
        self.diaryDate = diaryDate
        self.star = star
    }
}
