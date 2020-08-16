//
//  OriginalTabBarController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/12.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit

class OriginalTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // fontの設定
        let fontFamily: UIFont! = UIFont.systemFont(ofSize: 10)
        
        // 背景色の設定
        let colorBg = UIColor.green
        UITabBar.appearance().barTintColor = colorBg
        
        // 選択時の設定
        let selectedColor:UIColor = UIColor.black
        let selectedAttributes = [NSAttributedString.Key.font: fontFamily, NSAttributedString.Key.foregroundColor: selectedColor]
        /// タイトルテキストカラーの設定
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes as [NSAttributedString.Key : Any], for: UIControl.State.selected)
        /// アイコンカラーの設定
        UITabBar.appearance().tintColor = selectedColor
        
        // 影をつける
        let tab_layer: CALayer = self.tabBar.layer
        
        tab_layer.shadowColor = UIColor.black.cgColor
        tab_layer.shadowOffset = CGSize(width: 0.0, height: -3.0) // 距離
        tab_layer.shadowRadius = 3.0 // ぼかし量
        tab_layer.shadowOpacity = 0.5 // 透明度
    }
    

}
