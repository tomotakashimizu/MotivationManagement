//
//  BorderButton.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/12.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

@IBDesignable
class BorderButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
