//
//  ViewController.swift
//  Mcquiz
//
//  Created by 図師ともみ on 2016/10/19.
//  Copyright © 2016年 Manhattan-Code Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

// MARK: - Outlet -
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionStatusLabel: UILabel!
// MARK: - Declaration -
    var questionList:[String] = []
    var answerList:[String] = []
    var questionCount: Int = 0
    var judgImageName:String = ""
    let NextQuestion = "NextQuestion"
    var player: AVAudioPlayer?
    
    /*ここにpopupのインスタンスを生成する定義を書く*/
    var popupVC: PopupViewController!

// MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // 問題文と回答CSVを読み込む
        fetchCsvData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 起動後の画面の初期値をセット
        initViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// MARK: - Private Method -
    func fetchCsvData() {

        /* question.csvのパスを取得して、ファイルがあれば配列に問題文をセットし、なければエラーコンソールを出力する */
        do {
            let csvPath = Bundle.main.path(forResource: "question", ofType: "csv")
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            questionList = csvData.components(separatedBy: "\n")
        } catch {
            print(error)
        }
        
        /* answer.csvのパスを取得して、ファイルがあれば配列に答えをセットし、なければエラーコンソールを出力する */
        do {
            let csvPath = Bundle.main.path(forResource: "answer", ofType: "csv")
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            answerList = csvData.components(separatedBy: "\n")
        } catch {
            print(error)
        }
        
        /* 今、何問目かのラベルに問題文の総数をステータスラベルにセットする */
        questionStatusLabel.text = "1/\(questionList.count)"
    }
    
    func initViews() {
        /* 問題表示スペースに問題文をセットする */
        questionLabel.text = questionList[questionCount]
        /* NotificationCenterに登録する　iosの通知の仕組み */
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.nextQ(_:)), name: NSNotification.Name(rawValue: NextQuestion), object: nil)
        
    }

// MARK: - NSNotification Action -
    @objc func nextQ(_ notification: Notification?) {
        
        /* カウンターに＋１する */
        questionCount += 1
        /* カウンターが問題数に到達していた場合はカウンターをゼロに戻す */
        if (questionCount == questionList.count) {
            questionCount = 0
            questionLabel.text = questionList[questionCount]
        } else {
            questionLabel.text = questionList[questionCount]
        }
        
        /* 次が何問目なのかの数値をカウンターから取得してステータスラベルにセットする */
        questionStatusLabel.text = "\(questionCount+1)/\(questionList.count)"
        
        /* 最終問題の場合は音声を再生する */
        if questionCount + 1 == questionList.count {
            if let sound = NSDataAsset(name: "last_question") {
                player = try? AVAudioPlayer(data: sound.data)
                player?.play()
            }
        }
    }

// MARK: - Button Action -
    @IBAction func answerButton(_ sender: AnyObject) {

        /* 回答の正解不正解によって出力結果を出しわける */
        if (sender.tag == Int(answerList[questionCount])) {
            judgImageName = "true"
        } else {
            judgImageName = "false"
        }
        
        print("imageName = ",judgImageName,".png")
        
        /* ここにpopupの処理を書く */
        popupVC = PopupViewController(nibName : "PopupViewController", bundle: nil)
        popupVC.showInView(
            self.view,
            withImage: UIImage(named: judgImageName),
            animated: true
        )

    }

}

