//
//  AppDelegate.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/12.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    // アプリが起動した時に判定
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // ナビゲージョンアイテムの文字色
        UINavigationBar.appearance().tintColor = UIColor.black
        // ナビゲーションバーのタイトルの文字色
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        // ナビゲーションバーの背景色
        UINavigationBar.appearance().barTintColor = .green
        
        
        NCMB.setApplicationKey("1ffaee6b8c4c762c23c9bcd209f8f3e10ecc8e7df20f6cf83c44f3b4a4f42894", clientKey: "e1aead7275fcf9ef55699eac2bc2838d71b14939be4a466a4d9d8b23d01626fb")
        
        // ログインしているかしていないかをUserDefaultsで判断する
        let ud = UserDefaults.standard
        let isLogin = ud.bool(forKey: "isLogin")
        
        // 画面遷移ではなく画面の切り替え
        if isLogin == true {
            // ログイン中
            // windowをiPhoneの大きさに合わせてくれる(UIScreen.main.bounds)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            // nameはstoryboardの名前
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            // 最初の画面を設定
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
            self.window?.rootViewController = rootViewController
            // 画面が変わる時に黒い画面になってしまうため、白に設定
            self.window?.backgroundColor = UIColor.white
            // 最後に以上のwindowを表示
            self.window?.makeKeyAndVisible()
        } else {
            // ログインしていなかったら
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            self.window?.rootViewController = rootViewController
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

