import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        
        let status = UserDefaults.standard.integer(forKey: "status")
        print("Switcher.updateRootVC()::status::\(status)")
        if(status == 0){
            let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController
            tabVC?.selectedIndex = 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabVC
            
        }
        else if(status == 1){
            let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController
            tabVC?.selectedIndex = 1
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabVC
            
        }
        else if(status == 2){
            let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController
            tabVC?.selectedIndex = 2
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabVC
    
        }
        else{
            let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootVC
        }
    }
    
    static func openChatRoom(with: String){
        let chatRoomVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController
        chatRoomVC?.sender = with
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = chatRoomVC
    }
}
