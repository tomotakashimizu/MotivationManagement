//
//  ChartInfo.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/15.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

class ChartInfo {
    
    var objectId: String
    var text: String
    var diaryDate: Date
    var star: Double
    
    init(objectId: String, text: String, diaryDate: Date, star: Double) {
        self.objectId = objectId
        self.text = text
        self.diaryDate = diaryDate
        self.star = star
    }
}
