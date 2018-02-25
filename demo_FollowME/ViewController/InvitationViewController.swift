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
        
        getInvitationService.getInvitation(city: self.city, user: self.userID){result, errormessage in
            if let result = result {
                
                var langLabelStr = ""
                for x in result.languages {
                    
                    if langLabelStr != "" {
                        langLabelStr.append(", ")
                    }
                    langLabelStr.append(x)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        print("send message() in InvitationViewController")
        
        if let chatRoomVC =  self.storyboard!.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController {
            
            chatRoomVC.sender = self.userID
            //센더를 추가하여 ChatRoomView로 넘김
            self.present(chatRoomVC, animated: false, completion: nil)
        }
        
    }
    
    func presentVC(sender: String){
        if let chatRoomVC =  self.storyboard!.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController {
            
            chatRoomVC.sender = sender
            //센더를 추가하여 ChatRoomView로 넘김
            self.present(chatRoomVC, animated: false, completion: nil)
        }
    }
}
