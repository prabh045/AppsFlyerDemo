//
//  ViewController.swift
//  AppsFlyerDemo
//
//  Created by Prabhdeep Singh on 08/04/21.
//

import UIKit
import AppsFlyerLib
import AppTrackingTransparency

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        if #available(iOS 14, *) {
          ATTrackingManager.requestTrackingAuthorization { (status) in
            print("status \(status)")
          }
        }
        logEvent()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Sample Log Event
    func logEvent() {
        AppsFlyerLib.shared().logEvent(AFEventLogin, withValues: [
            AFEventParamAchievementId: "1"
        ])
        
        AppsFlyerLib.shared().logEvent(name: "EXAMPLE", values: ["TEST":1]) { (response, error) in
            if let error = error {
                print("error occured in loging event \(error)")
                return
            }
            print("success in loging event \(response)")
        }
    }


}

