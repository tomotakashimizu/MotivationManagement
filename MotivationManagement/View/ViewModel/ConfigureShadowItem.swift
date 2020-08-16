//
//  ConfigureShadowItem.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

class ConfigureShadowItem {
    static func imageView(shadowImageView: UIImageView) {
        shadowImageView.layer.shadowColor = UIColor.black.cgColor
        shadowImageView.layer.shadowOpacity = 0.2 // 透明度
        shadowImageView.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        shadowImageView.layer.shadowRadius = 5 // ぼかし量
    }
    
    static func button(shadowButton: UIButton) {
        shadowButton.layer.shadowColor = UIColor.black.cgColor
        shadowButton.layer.shadowOpacity = 0.2 // 透明度
        shadowButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        shadowButton.layer.shadowRadius = 5 // ぼかし量
    }
}
