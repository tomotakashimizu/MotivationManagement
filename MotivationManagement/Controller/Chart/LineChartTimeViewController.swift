//
//  LineChartTimeViewController.swift
//  MotivationManagement
//
//  Created by 清水智貴 on 2020/08/15.
//  Copyright © 2020 com.tomotaka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import Charts
import Cosmos

class LineChartTimeViewController: DemoBaseViewController {
    
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var starCosmosView: CosmosView!
    @IBOutlet var memoTextView: UITextView!
    
    var dateFormatter = DateFormatter()
    var chartInfos = [ChartInfo]()
    
    var stringDiaryDate = [String]()
    var stringMonthDate = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "メンタルの推移"
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        
        chartView.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.2)
        
        chartView.legend.enabled = false
        chartView.setViewPortOffsets(left: 30, top: 20, right: 10, bottom: 40)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        //xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
//        xAxis.granularity = 3600
//        xAxis.valueFormatter = DateValueFormatter()
        
        
        chartView.rightAxis.enabled = false
        
        chartView.legend.form = .line
        
        chartView.animate(xAxisDuration: 2.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        loadTimeline()
    }
    
    func setDataCount() {
        
        let data = LineChartData()
        var lineChartEntry1 = [ChartDataEntry]()

        for i in 0..<chartInfos.count {
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: chartInfos[i].star))
        }
        
        
        //let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        let set1 = LineChartDataSet(entries: lineChartEntry1, label: "メンタル")
        
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = true
        set1.drawValuesEnabled = false
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        //let data = LineChartData(dataSet: set1)
        data.addDataSet(set1)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        chartView.data = data
        
        let xAxis = chartView.xAxis
        print(stringDiaryDate)
//        xAxis.valueFormatter = IndexAxisValueFormatter(values: stringDiaryDate)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: stringMonthDate)
        xAxis.granularity = 1
        
        let leftAxis = chartView.leftAxis
        //leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        //leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 5.0
        leftAxis.granularity = 1
        //leftAxis.yOffset = -9
        //leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        leftAxis.labelTextColor = .black
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
        //query?.order(byDescending: "createDate")
        query?.order(byAscending: "diaryDate")
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        // 自分の投稿だけ持ってくる
        query?.whereKey("user", equalTo: currentUser)
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.chartInfos = [ChartInfo]()
                self.stringDiaryDate = [String]()
                
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 投稿したユーザーの情報をUserモデルにまとめる
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String
                    
                    // 投稿の情報を取得
                    let text = postObject.object(forKey: "text") as! String
                    let diaryDates = postObject.object(forKey: "diaryDate") as! String
                    //self.diaryDate.append(diaryDates)
                    self.stringDiaryDate.append(diaryDates)
                    let diaryDate = self.stringToDate(stringDate: diaryDates)
                    self.stringMonthDate.append(self.dateToString(dates: diaryDate))
                    print("stringMonthDate", self.stringMonthDate)
                    
                    //追加
                    let star = postObject.object(forKey: "star") as! Double
                    
                    // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                    let chartInfo = ChartInfo(objectId: postObject.objectId, text: text, diaryDate: diaryDate, star: star)
                    
                    // 配列に加える
                    self.chartInfos.append(chartInfo)
                }
                print("self.chartInfos.count", self.chartInfos.count)
                self.setDataCount()
                // 投稿のデータが揃ったらTableViewをリロード
                //self.tableView.reloadData()
            }
        })
    }
    
    func stringToDate(stringDate: String) -> Date {
        // フォーマット設定
        dateFormatter.dateFormat = "yyyy'年'M'月'd'日"
//        dateFormatter.dateFormat = "M'月'd'日"
        // カレンダー設定（和暦固定）
        //dateFormatter.calendar = Calendar(identifier: .japanese)
        // ロケール設定（日本語・日本国固定）
        dateFormatter.locale = Locale(identifier: "ja_JP")
        // タイムゾーン設定（端末設定によらず、どこの地域の時間帯なのかを指定する）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        // 変換
        //let date = dateFormatter.date(from: "2020年10月20日")
        let date = dateFormatter.date(from: stringDate)
        // 結果表示
        print(date!) // -> 2020-10-19 15:00:00 +0000
        return date!
    }
    
    func dateToString(dates: Date) -> String {
        // フォーマット設定
//        dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'" // 曜日1文字
        dateFormatter.dateFormat = "M'月'd'日'" // 曜日3文字
//        dateFormatter.dateFormat = "MMdd" // 曜日3文字

        // ロケール設定（日本語・日本国固定）
        dateFormatter.locale = Locale(identifier: "ja_JP")

        // タイムゾーン設定（日本標準時固定）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")

        // 変換
        let str = dateFormatter.string(from: dates)

        // 結果表示
        print(str) // -> 2020年1月9日(木) 18時29分19秒
        return str
    }
    
    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.x)
        print(chartInfos[Int(entry.x)].text)
        starCosmosView.rating = entry.y
        memoTextView.text = chartInfos[Int(entry.x)].text
    }
    
}
