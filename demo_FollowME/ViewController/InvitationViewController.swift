//
//  InvitationViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 20..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class InvitationViewController: UIViewController {
    
    var userID = ""
    var city = ""
    var getInvitationService = GetInvitationService()

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InvitationVC viewDidLoad userID : \(userID)")
        print("InvitationVC viewDidLoad city : \(city)")

        
        
        getInvitationService.getInvitation(city: self.city, user: self.userID){result, errormessage in
            if let result = result {
                
                print("completion : \(result.city)")
                print("completion : \(result.userid)")
                
                var langLabelStr = ""
                for x in result.languages {
                    
                    if langLabelStr != "" {
                        langLabelStr.append(", ")
                    }
                    langLabelStr.append(x)
                }
                print("completion : \(langLabelStr)")
//                self.cityLabel.text = result.city
//                self.userIdLabel.text = result.userid
//                self.languagesLabel.text = langLabelStr
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
   
    @IBAction func sendMessage(_ sender: Any) {
        print("send message() in InvitationViewController")
        
        if let chatRoomVC =  self.storyboard!.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController {
            
            chatRoomVC.sender = self.userID
            //센더를 추가하여 ChatRoomView로 넘김
            self.present(chatRoomVC, animated: false, completion: nil)
        }
        
//        //탭바로 가기
//        var appDelegate = UIApplication.shared.delegate as! AppDelegate
//        var rootViewController = appDelegate.window!.rootViewController
//        var storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        var vc = storyboard.instantiateViewController(withIdentifier: "MainTabVC")
//        appDelegate.window?.rootViewController = vc
//        appDelegate.window?.makeKeyAndVisible()
    }
    
    func presentVC(sender: String){
        if let chatRoomVC =  self.storyboard!.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController {
            
            chatRoomVC.sender = sender
            //센더를 추가하여 ChatRoomView로 넘김
            self.present(chatRoomVC, animated: false, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
