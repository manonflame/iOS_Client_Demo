//
//  AppDelegate.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 10..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var myApp = UIApplication.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
 
        print("didFinishLaunchinWithOptions :: \(launchOptions)")
  
        if let user = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User{
            
            //로그인된 유저 아이디가 있으면ㄱ
            if user.id != ""{
                print("Yes I Logged : \(user.id)")
                
                //유저 인포에 유저 아이디 넣고
                LogInUserInfo.Instance.userID = user.id
                UserDefaults.standard.set(0, forKey: "status")
                Switcher.updateRootVC()
            }
        }
        
        

        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {

            UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler:{ notifications in
                for notificationEle in notifications.reversed(){


                    var timeStamp = notificationEle.request.content.categoryIdentifier
                    var body = notificationEle.request.content.body
                    var senderAndMessage = body.split(separator: ":")
                    var sender = senderAndMessage[0].dropLast()
                    var message = senderAndMessage[1].dropFirst()

                    //메시지 붙이기
                    ConversationSaver.save(sender: String(sender), timeStamp: timeStamp, message: String(message) + " [낫 러닝에서 켜짐]")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS" //Your date format
                    var date = dateFormatter.date(from: timeStamp)

                    //MessegeBox를 저장
                    MessageBoxSaver.save(sender: String(sender), timeStamp: date!, lastMessage: String(message))

                }
                let dic = notification["aps"] as! [String: AnyObject]
                let body = dic["alert"] as? String
                let senderAndMessage = body?.split(separator: ":")
                var strTimeStamp = dic["category"] as? String
                var sender = senderAndMessage![0].dropLast()
                var content = senderAndMessage![1].dropFirst()

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS" //Your date format
                var date = dateFormatter.date(from: strTimeStamp!)

                //메시지 붙이기
                ConversationSaver.save(sender: String(sender), timeStamp: strTimeStamp!, message: String(content) + " [낫 러닝에서 노티로 켬]")

                //MessegeBox를 저장
                MessageBoxSaver.save(sender: String(sender), timeStamp: date!, lastMessage: String(content))


                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            })
        }
        sleep(1)
        return true
    }

    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive(_ application: UIApplication)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground(_ application: UIApplication)")
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("TEST ::applicationWillEnterForeground(_ application: UIApplication)")
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
    
    
    
    //사용자에게 푸쉬 노티피케이션에 대한 메시지를 알림.
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            //리모트 노티피케이션에 대한 환경 설정 등록을 함
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    //리모트노티피케이션에 환경 설정 등록을 하면 자동으로 호출 됨.<성공시>
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        DeviceToken.Instance.token = token
    }
    //리모트노티피케이션에 환경 설정 등록을 하면 자동으로 호출 됨.<실패시>
    //실패의 몇가지 이유: 시뮬레이터 작동시 실패/ 앱 아이디 환경설정이 부적절할 때. -> 메시지에 다 나옴
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        
        
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var body = notification.request.content.body
        
        if body == ""{
            print("읽어서 뱃치 최신화")
            completionHandler(UNNotificationPresentationOptions.badge)
            return
        }
        
        var senderAndMessage = body.split(separator: ":")
        var sender = senderAndMessage[0].dropLast()
        if let currentViewController = UIApplication.shared.keyWindow?.topMostViewController(){
            //현재 뷰 컨트롤러
            if let currentViewController = UIApplication.shared.keyWindow?.topMostViewController(){
                //만약 최상위 뷰 컨트롤러 채트룸이고 해당 센더와 같다면
                if currentViewController.sender == sender{
                    //노티를 띄우지 않음
                    return
                }
            }
        }
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound, UNNotificationPresentationOptions.badge])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if(myApp.applicationState == .active){
            //포그라운드 상태에서 노티가 도착햇을 경우
            print("포그라운드 상태에서 노티가 도착햇을 경우")
            var dic = userInfo["aps"] as? [String: AnyObject]
            let body = dic!["alert"] as? String
            let senderAndMessage = body?.split(separator: ":")
            var sender = senderAndMessage![0].dropLast()
            var message = senderAndMessage![1].dropFirst()
            var timeStamp = dic!["category"] as? String
            
            //메시지 붙이기
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS" //Your date format
            var date = dateFormatter.date(from: timeStamp!)
            
            //conversation저장하기1
            ConversationSaver.save(sender: String(sender), timeStamp: timeStamp!, message: String(message+" [프론트 챗룸 아님]"))
            //MessegeBox를 저장
            MessageBoxSaver.save(sender: String(sender), timeStamp: date!, lastMessage: String(message))
            
            NotificationCenter.default.post(name: .myNotification, object: nil)
            NotificationCenter.default.post(name: .myNotification2, object: nil)
            print("FORGROUND2")

        }
        else if(myApp.applicationState == .background){
            //백그라운드에서 노티가 안눌렸을 경우
            print("백그라운드에서 노티가 안눌렸을 경우")
            var dic = userInfo["aps"] as? [String: AnyObject]
            let body = dic!["alert"] as? String
            let senderAndMessage = body?.split(separator: ":")
            var sender = senderAndMessage![0].dropLast()
            var message = senderAndMessage![1].dropFirst()
            var timeStamp = dic!["category"] as? String
            
            
            //메시지 붙이기
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS" //Your date format
            var date = dateFormatter.date(from: timeStamp!)
            
            //conversation저장하기1
            ConversationSaver.save(sender: String(sender), timeStamp: timeStamp!, message: String(message+" [노티를 안누른애]"))
            //MessegeBox를 저장
            MessageBoxSaver.save(sender: String(sender), timeStamp: date!, lastMessage: String(message))
        }
        else if(myApp.applicationState == .inactive){
            //백그라운드 혹은 not Running 상태에서 노티가 눌렸을 경우
            print("백그라운드 상태에서 노티가 눌렸을 경우")
            var dic = userInfo["aps"] as? [String: AnyObject]
            let body = dic!["alert"] as? String
            let senderAndMessage = body?.split(separator: ":")
            var sender = senderAndMessage![0].dropLast()

            //메인스레드에서 루트 뷰 컨트롤러 변경
            DispatchQueue.main.async {
                Switcher.openChatRoom(with: String(sender))
            }
        }
        else{
           //do nothin'
        }
    }
}

