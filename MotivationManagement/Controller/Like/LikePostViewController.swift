//
//  LikePostViewController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/16.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import SwiftDate

class LikePostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MotivationPostTableViewCellDelegate {
    
    var selectedPost: Post?
    var posts = [Post]()
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate lazy var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMMkHm", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "お気に入りの記録"

        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "MotivationPostTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        let noRecordNib = UINib(nibName: "NoRecordTableViewCell", bundle: Bundle.main)
        tableView.register(noRecordNib, forCellReuseIdentifier: "NoRecordCell")
        
        // 不要な線を消す
        tableView.tableFooterView = UIView()
        
        // tableViewの角を丸くする
        tableView.layer.cornerRadius = 20
        
        // 引っ張って更新
        setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // タイムラインの更新
        loadTimeline()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count > 0 {
            return posts.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if posts.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MotivationPostTableViewCell
            
            cell.delegate = self
            cell.tag = indexPath.row
            
            //let user = posts[indexPath.row].user
            cell.commentLabel.text = posts[indexPath.row].text
            
            //追加
            cell.starCosmosView.rating = posts[indexPath.row].star
            
            // Likeによってハートの表示を変える
            if posts[indexPath.row].isLiked == true {
                cell.likeButton.setImage(UIImage(named: "icons8-heart-color"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "icons8-heart-outline"), for: .normal)
            }
            cell.timestampLabel.text = dateTimeFormatter.string(from: posts[indexPath.row].createDate)
            
            return cell
        } else {
            let noRecordCell = tableView.dequeueReusableCell(withIdentifier: "NoRecordCell") as! NoRecordTableViewCell
            noRecordCell.noRecordLabel.text = "お気に入りは登録されていません。"
            return noRecordCell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        
        if identifier == "toComments" {
            let commentViewController = segue.destination as! CommentViewController
            commentViewController.postId = selectedPost?.objectId
        }
    }
    
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        guard let currentUser = NCMBUser.current() else {
            // ログインに戻る
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログインしていない状態の保持(AppDelegateの"isLogin"の宣言より)
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            
            return
        }
        
        if posts[tableViewCell.tag].isLiked == false || posts[tableViewCell.tag].isLiked == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                post?.addUniqueObject(currentUser.objectId, forKey: "likeUser")
                post?.saveEventually({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        self.loadTimeline()
                    }
                })
            })
        } else {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadTimeline()
                        }
                    })
                }
            })
        }
    }
    
    
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
            SVProgressHUD.show()
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: self.posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    // 取得した投稿オブジェクトを削除
                    post?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // 再読込
                            self.loadTimeline()
                            SVProgressHUD.dismiss()
                        }
                    })
                }
            })
        }
        let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
            SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        if posts[tableViewCell.tag].user.objectId == NCMBUser.current().objectId {
            // 自分の投稿なので、削除ボタンを出す
            alertController.addAction(deleteAction)
        } else {
            // 他人の投稿なので、報告ボタンを出す
            alertController.addAction(reportAction)
        }
        alertController.addAction(cancelAction)
        
        // iPad の場合のみ、ActionSheetを表示するための必要な設定
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2,y: screenSize.size.height,width: 0,height: 0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton) {
        // 選ばれた投稿を一時的に格納
        selectedPost = posts[tableViewCell.tag]
        
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toComments", sender: nil)
    }
    
    
    func loadTimeline() {
        
        guard let currentUser = NCMBUser.current() else {
            // ログインに戻る
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログインしていない状態の保持(AppDelegateの"isLogin"の宣言より)
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            
            return
        }
        
        let query = NCMBQuery(className: "Post")
        
        // 降順(新しいものがタイムラインの上に出てくるように)
        query?.order(byDescending: "diaryDate")
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        
        // 自分の投稿だけ持ってくる
        query?.whereKey("user", equalTo: currentUser)
        
        query?.whereKey("likeUser", equalTo: currentUser.objectId)
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [Post]()
                
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        // 投稿したユーザーの情報をUserモデルにまとめる
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        userModel.displayName = user.object(forKey: "displayName") as? String
                        
                        // 投稿の情報を取得
                        //let imageUrl = postObject.object(forKey: "imageUrl") as! String
                        let text = postObject.object(forKey: "text") as! String
                        
                        let diaryDates = postObject.object(forKey: "diaryDate") as! String
                        //self.diaryDate.append(diaryDates)
                        
                        //追加
                        let star = postObject.object(forKey: "star") as! Double
                        
                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                        let post = Post(objectId: postObject.objectId, user: userModel, text: text, createDate: postObject.createDate, diaryDate: diaryDates, star: star)
                        
                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                        if likeUsers?.contains(currentUser.objectId) == true {
                            post.isLiked = true
                        } else {
                            post.isLiked = false
                        }
                        
                        // いいねの件数
                        if let likes = likeUsers {
                            post.likeCount = likes.count
                        }
                        
                        // 配列に加える
                        self.posts.append(post)
                    }
                }
                
                if self.posts.count > 0 {
                    // cellの高さを設定
                    self.tableView.rowHeight = 173
                } else {
                    self.tableView.rowHeight = 120
                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.tableView.reloadData()
            }
        })
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        // ここが引っ張られるたびに呼び出される
        refreshControl.beginRefreshing()
        self.loadTimeline()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
            refreshControl.endRefreshing()
        }
    }

}
