//
//  DetailCommentViewController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class DetailCommentViewController: UIViewController {
    
    var selectedPost = ""
    var postId: String!
    var passedPostUserPbjectId: String!
    
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var updateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        postTextView.text = selectedPost
        
        // キーボードを表示する
        postTextView.becomeFirstResponder()
        
        // updateButtonの角を丸くする
        updateButton.layer.cornerRadius = 10
        ConfigureShadowItem.button(shadowButton: updateButton)
    }
    
    @IBAction func update(){
        
        if postTextView.text.count > 0 {
            SVProgressHUD.show()
            let query = NCMBQuery(className: "Comment")
            query?.getObjectInBackground(withId: postId, block: { (post, error) in
                print(self.postId, "test")
                if error != nil {
                    print("error")
                } else {
                    DispatchQueue.main.async {
                        post?.setObject(self.postTextView.text, forKey: "text")
                        post?.saveInBackground({ (error) in
                            if error != nil {
                                SVProgressHUD.show(withStatus: error?.localizedDescription)
                            } else {
                                SVProgressHUD.dismiss()
                                //編集できてる
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    
                }
            })
        } else {
            SVProgressHUD.showError(withStatus: "何も入力されていません。")
        }
        
        
    }
    
    
    @IBAction func delete() {

        let query = NCMBQuery(className: "Comment")
        query?.getObjectInBackground(withId: postId, block: { (post, error) in
            print(self.postId, "test")
            if error != nil {
                print("error")
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "確認", message: "このコメントを削除しますか？", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        SVProgressHUD.show()
                        post?.deleteInBackground({ (error) in
                            if error != nil {
                                print("error2")
                            } else {
                                SVProgressHUD.dismiss()
                                //navigationbarのがついた時の戻るコード
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }

                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }

}
