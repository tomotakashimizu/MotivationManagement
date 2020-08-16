//
//  DateValueFormatter.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/15.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
