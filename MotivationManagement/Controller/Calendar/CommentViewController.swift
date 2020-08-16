//
//  CommentViewController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/13.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommentTableViewCellDelegate {
    
    var postId: String!
    var comments = [Comment]()
    
    @IBOutlet var commentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "CommentTableViewCell", bundle: Bundle.main)
        commentTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        let noRecordNib = UINib(nibName: "NoRecordTableViewCell", bundle: Bundle.main)
        commentTableView.register(noRecordNib, forCellReuseIdentifier: "NoRecordCell")
        
        // tableViewの角を丸くする
        commentTableView.layer.cornerRadius = 20
        
        // コメントの長さに応じてtableViewの高さが変わる
        commentTableView.estimatedRowHeight = 80
        commentTableView.rowHeight = UITableView.automaticDimension
        
        // フォントカラー
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadComments()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if comments.count > 0 {
            return comments.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if comments.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CommentTableViewCell
            cell.delegate = self
            cell.tag = indexPath.row
            
            cell.commentLabel.text = comments[indexPath.row].text
            cell.commentLabel.sizeToFit()
            
            return cell
        } else {
            let noCommentCell = tableView.dequeueReusableCell(withIdentifier: "NoRecordCell") as! NoRecordTableViewCell
            noCommentCell.noRecordLabel.text = "この記録にはコメントがまだありません。"
            
            return noCommentCell
        }
        
        
    }
    
    // コメントを編集する際、次の画面に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面の取得（detail画面）
        if segue.identifier == "toDetail" {
            let detailViewCountroller = segue.destination as! DetailCommentViewController
            let selectedIndex = commentTableView.indexPathForSelectedRow!
            detailViewCountroller.selectedPost = comments[selectedIndex.row].text
            detailViewCountroller.postId = comments[selectedIndex.row].objectId
        }
    }
    
    
    // コメントを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentUser = NCMBUser.current() else {
            return
        }
        
        // まだコメントがなかった時
        if comments.count == 0 {
            return
        }
        
        // コメントが自分のか否かを判定するため
        //let selctedPostUserObjectId = comments[indexPath.row].user.objectId
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // 削除のシート
        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
            SVProgressHUD.show()
            let query = NCMBQuery(className: "Comment")
            query?.getObjectInBackground(withId: self.comments[indexPath.row].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.show(withStatus: error?.localizedDescription)
                } else {
                    post?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.show(withStatus: error?.localizedDescription)
                        } else {
                            self.loadComments()
                            SVProgressHUD.dismiss()
                        }
                    })
                }
            })
        }
        // 画面遷移して編集のシート
        let editAction = UIAlertAction(title: "コメントを編集する", style: .default) { (action) in
            self.performSegue(withIdentifier: "toDetail", sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            tableView.deselectRow(at: indexPath, animated: true)
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // コメントを左にスワイプした時の処理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actionButton: UITableViewRowAction! = UITableViewRowAction(style: .normal, title: "アクション") { (action, index) in
            // 自分のコメントか否かでボタンを変えるため、とりあえず形だけ宣言(型を作った)
        }
    
        if comments.count == 0 {
            return []
        }
        
        // currentUserがnil出なかったら
        if let currentUser = NCMBUser.current() {
            
            let selctedPostUserObjectId = comments[indexPath.row].user.objectId
            // 削除ボタンを作る
            let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
                //self.comments.remove(at: indexPath.row)
                //tableView.deleteRows(at: [indexPath], with: .fade)
                let query = NCMBQuery(className: "Comment")
                query?.getObjectInBackground(withId: self.comments[indexPath.row].objectId, block: { (post, error) in
                    if error != nil {
                        SVProgressHUD.show(withStatus: error?.localizedDescription)
                    } else {
                        SVProgressHUD.show()
                        post?.deleteInBackground({ (error) in
                            if error != nil {
                                SVProgressHUD.show(withStatus: error?.localizedDescription)
                            } else {
                                self.loadComments()
                                SVProgressHUD.dismiss()
                            }
                        })
                    }
                })
            }
            deleteButton.backgroundColor = UIColor.red
            actionButton = deleteButton
        }
        
        return [actionButton]
    }
    
    func loadComments() {
        comments = [Comment]()
        let query = NCMBQuery(className: "Comment")
        query?.whereKey("postId", equalTo: postId)
        query?.includeKey("user")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                for commentObject in result as! [NCMBObject] {
                    // コメントをしたユーザーの情報を取得
                    let user = commentObject.object(forKey: "user") as! NCMBUser
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String
                    
                    // コメントの文字を取得
                    let text = commentObject.object(forKey: "text") as! String
                    
                    // 参照
                    // Commentクラスに格納
                    let comment = Comment(objectId: commentObject.objectId, postId: self.postId, user: userModel, text: text, createDate: commentObject.createDate)
                    
                    self.comments.append(comment)
                }
                self.commentTableView.reloadData()
            }
        })
    }
    
    @IBAction func addComment() {
        let alert = UIAlertController(title: "コメント", message: "コメントを入力して下さい", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if (alert.textFields?.first?.text?.count)! > 0 {
                alert.dismiss(animated: true, completion: nil)
                SVProgressHUD.show()
                let object = NCMBObject(className: "Comment")
                object?.setObject(self.postId, forKey: "postId")
                object?.setObject(NCMBUser.current(), forKey: "user")
                object?.setObject(alert.textFields?.first?.text, forKey: "text")
                object?.saveInBackground({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        self.loadComments()
                        //self.commentTableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                })
            } else {
                SVProgressHUD.showError(withStatus: "何も入力されていません。")
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField) in
            textField.placeholder = "ここにコメントを入力"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        commentTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.loadComments()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }

}
