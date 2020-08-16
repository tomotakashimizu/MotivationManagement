//
//  ChartXAxisFormatter.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/15.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import Charts

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?

    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
}
