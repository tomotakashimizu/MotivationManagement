//
//  SignInViewController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpForButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        passwordTextField.delegate = self
        
        userIdTextField.keyboardType = UIKeyboardType.alphabet
        passwordTextField.keyboardType = UIKeyboardType.alphabet
        
        // signInButtonの角を丸くする
        signInButton.layer.cornerRadius = 10
        // signUpForButtonの角を丸くする
        signUpForButton.layer.cornerRadius = 10
        
        ConfigureShadowItem.button(shadowButton: signInButton)
        ConfigureShadowItem.button(shadowButton: signUpForButton)
        
        let ud = UserDefaults.standard
        let userID = ud.string(forKey: "userID")
        let password = ud.string(forKey: "password")
        
        if userID != nil{
            userIdTextField.text  = userID
        }
        
        if password != nil{
            passwordTextField.text = password
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // TextField以外の部分をタッチ => TextFieldが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signIn() {
        if userIdTextField.text == "" && passwordTextField.text == "" {
            SimpleAlert.showAlert(viewController: self, title: "エラー", message: "ユーザーIDとパスワードを入力してください。", buttonTitle: "OK")
        } else if userIdTextField.text == "" {
            SimpleAlert.showAlert(viewController: self, title: "エラー", message: "ユーザーIDを入力してください。", buttonTitle: "OK")
        } else if passwordTextField.text == "" {
            SimpleAlert.showAlert(viewController: self, title: "エラー", message: "パスワードを入力してください。", buttonTitle: "OK")
        } else if (userIdTextField.text?.count)! > 0 && (passwordTextField.text?.count)! > 0 {
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text, password: passwordTextField.text) { (user, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else if user?.object(forKey: "active") as? Bool == false {
                    SVProgressHUD.setStatus("そのユーザーは退会済みです。")
                } else {
                    
                    // サインインする時にaclを設定
                    let acl = NCMBACL()
                    acl.setPublicReadAccess(true)
                    acl.setWriteAccess(true, for: user)
                    user!.acl = acl
                    
                    // ログイン成功
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    // AppDelegateのコードとは違う、表示のコードの書き方
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    // ログイン状態の保持(AppDelegateの"isLogin"の宣言より)
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.set(self.userIdTextField.text!, forKey: "userID") //追加
                    ud.set(self.passwordTextField.text!, forKey: "password") //追加
                    ud.synchronize()
                }
            }
        }
    }
    
}
