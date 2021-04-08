//
//  AppDelegate.swift
//  AppsFlyerDemo
//
//  Created by Prabhdeep Singh on 08/04/21.
//

import UIKit
import AppsFlyerLib
typealias appsflyer = AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppsFlyerLib.shared().appsFlyerDevKey = "<keyhere"
        AppsFlyerLib.shared().appleAppID = "APPiDhERE"
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = true
        
        //IDFA USER CONSENT
        if #available(iOS 14.0, *) {
            AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        }
        
        AppsFlyerLib.shared().deepLinkDelegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //to track push notification engagments
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }


}

extension AppDelegate: AppsFlyerLibDelegate {
    //Organic/Non Organic
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("COnversionInfo: \(conversionInfo)")
    }
    
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}

//Handle Unified deep Link
extension AppDelegate: DeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .notFound:
            print("Deep link not found")
        case .found:
            let deepLinkStr:String = result.deepLink!.toString()
            print("DeepLink data is: \(deepLinkStr)")
            if( result.deepLink?.isDeferred == true) {
                print("This is a deferred deep link")
            } else {
                print("This is a direct deep link")
            }
            walkToSceneWithParams(deepLinkObj: result.deepLink!)
        case .failure:
            print("Error %@", result.error!)
        }
    }
}
// User logic
fileprivate func walkToSceneWithParams(deepLinkObj: DeepLink) {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    guard let fruitNameStr = deepLinkObj.clickEvent["deep_link_value"] as? String else {
         print("Could not extract query params from link")
         return
    }
    let destVC = fruitNameStr + "_vc"
    //go to destination
//    if let newVC = storyBoard.instantiateVC(withIdentifier: destVC) {
//       print("AppsFlyer routing to section: \(destVC)")
//       newVC.deepLinkData = deepLinkObj
//       UIApplication.shared.windows.first?.rootViewController?.present(newVC, animated: true, completion: nil)
//    } else {
//        print("AppsFlyer: could not find section: \(destVC)")
//    }
}

