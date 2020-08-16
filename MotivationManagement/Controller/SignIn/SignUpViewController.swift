//
//  SignUpViewController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var confirmEmailTextField: UITextField!
    @IBOutlet var sendEmailToSignUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        confirmEmailTextField.delegate = self
        
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        confirmEmailTextField.keyboardType = UIKeyboardType.emailAddress
        
        // signUpButtonの角を丸くする
        sendEmailToSignUpButton.layer.cornerRadius = 10
        
        ConfigureShadowItem.button(shadowButton: sendEmailToSignUpButton)
    }
    
    // 改行(完了)ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    // TextField以外の部分をタッチ => TextFieldが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendEmailToSignUp() {
        let user = NCMBUser()
        
        if emailTextField.text == confirmEmailTextField.text && (emailTextField.text?.count)! > 1 {
            user.mailAddress = self.emailTextField.text!
            NCMBUser.requestAuthenticationMail(emailTextField.text, error: nil)
            
            let alertController = UIAlertController(title: "メール送信完了", message: "メールを送信しました。登録を完了してください。", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            SimpleAlert.showAlert(viewController: self, title: "エラー", message: "メールアドレスを正しく入力してください。", buttonTitle: "OK")
        }
    }

}
