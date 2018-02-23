//
//  MyInfoViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 22..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController {
    
    var user = User(id: "", pw: "")

    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBAction func makeInvitation(_ sender: Any) {
        if let addInvitationVC = self.storyboard!.instantiateViewController(withIdentifier: "AddInvitationVC") as? AddInvitationViewController {
            addInvitationVC.invitation.userid = user.id
            self.present(addInvitationVC, animated: false )
        }
    }
    
    @IBAction func LOGOUT(_ sender: Any) {
        let nilUser = User.init(id: "", pw: "")
        //로그인 유저삭제
        NSKeyedArchiver.archiveRootObject(nilUser, toFile: User.ArchiveURL.path)
        
        //채팅방 내용 모두 삭제
        
        //채팅방 목록 삭제
        
        //서버에서 디바이스 토큰 삭제
        
        //루트 뷰 컨트롤러 변경
        UserDefaults.standard.set(4, forKey: "status")
        Switcher.updateRootVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyInfoViewController:: viewDidLoad()")
        //user데이터 불러옴
        if let loadedUser = loadUser(){
            self.user = loadedUser
            print("loaded user ID : \(user.id)")
            userIDLabel.text = user.id
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MyInfoViewController:: viewWillAppear()")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUser() -> User? {
        print("loadUser() in MyInfoVC")
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
    }


}
