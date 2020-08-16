//
//  MyPostViewController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import Cosmos

class MyPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedDate = Date()
    
    //@IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIBarButtonItem!
    //@IBOutlet var selectPhotoButton: UIButton!
    //追加
    @IBOutlet var starCosmosView: CosmosView!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.isEnabled = false
        postTextView.delegate = self
        //selectPhotoButton.layer.cornerRadius = 15
        
        self.navigationItem.title = dateFormatter.string(from: selectedDate)
        
        print(starCosmosView.rating)
    }
    
    // テキストの初期設定を変更したい時に使う、UITextViewDelegateのオプションの関数(文字制限を設けたい場合など)
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }
    
    // 改行(完了)ボタンを押した時に呼ばれる処理
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    // TextFieldおよびTextView以外の部分をタッチ => TextFieldが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func confirmContent() {
        // どちらにも何かしらの値がある時
        if postTextView.text.count > 0 {
            postButton.isEnabled = true
        } else {// どちらか、または、両方とも何も情報がなかった場合
            postButton.isEnabled = false
        }
    }
    
    @IBAction func cancelButton() {
        // "キャンセルボタン"が押された時に、textViewが選択されていたら
        if postTextView.isFirstResponder == true {
            // textViewのキーボードを閉じる
            postTextView.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を破棄しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.postTextView.text = nil
            //self.postImageView.image = UIImage(named: "icons8-picture-480@2x.png")
            self.confirmContent()
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func recordButton() {
        
        // "キャンセルボタン"が押された時に、textViewが選択されていたら
        if postTextView.isFirstResponder == true {
            // textViewのキーボードを閉じる
            postTextView.resignFirstResponder()
        }
        
        SVProgressHUD.show()
            
            let postObject = NCMBObject(className: "Post")
            
            if self.postTextView.text.count == 0 {
                print("入力されていません")
                return
            }
            postObject?.setObject(self.postTextView.text!, forKey: "text")
            postObject?.setObject(NCMBUser.current(), forKey: "user")
            
            // 日記の日程を保存
            postObject?.setObject(self.dateFormatter.string(from: self.selectedDate), forKey: "diaryDate")
            
            postObject?.setObject(self.starCosmosView.rating, forKey: "star")
            
            //let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications//publicFiles/" + file.name
            //postObject?.setObject(url, forKey: "imageUrl")
            postObject?.saveInBackground({ (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    SVProgressHUD.dismiss()
                    self.postTextView.text = nil
                    self.tabBarController?.selectedIndex = 0
                    self.dismiss(animated: true, completion: nil)
                }
            })
    }

}
