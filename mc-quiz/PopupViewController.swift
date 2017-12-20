//
//  PopupViewController.swift
//  mc-quiz
//
//  Created by ShuntaNomura on 2017/12/20.
//  Copyright © 2017年 TableCloth. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.6)
        popupView.layer.cornerRadius = 5
        popupView.layer.shadowOpacity = 0.8
        popupView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// メインビューから受け取った情報をpopupViewController.xibにセットする処理を書く
    func showInView(_ aView: UIView!, withImage image: UIImage!, animated: Bool) {
        self.view.frame = aView.frame
        aView.addSubview(self.view)
        imageView!.image = image
        
        if animated {
            self.showAnimate()
        }
    }
    
    /// popupViewController.xibの表示アニメーションの処理を書く
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }
    
    @IBAction func close(_ sender: Any) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "NextQuestion"),
            object: nil
        )
        self.removeAnimate()
    }
}
