//
//  MainViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 10..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, logInBoxDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var IDTextField: UITextField! {didSet { IDTextField.delegate = self } }
    @IBOutlet weak var PWTextField: UITextField! {didSet { PWTextField.delegate = self } }
    var user = User(id: "", pw: "")
    var logInService = LogInService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInService.delegate = self
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func logInAccepted() {
        print("log in succeed-------")
        //여기서 유저 정보를 저장함
        print("login user id : \(IDTextField.text!)")
        print("login user pw : \(PWTextField.text!)")
        self.user.id = IDTextField.text!
        self.user.pw = PWTextField.text!
        var isSaved = saveUser()
         LogInUserInfo.Instance.userID = self.user.id
        print("save Success? : \(isSaved)")
        print("---------------------")
        
        let tabMainView = self.storyboard!.instantiateViewController(withIdentifier: "MainTabVC")
        self.present(tabMainView, animated: false)
    }
    
    func logInDenied(message: String) {
        print("log in failed")
        let deniedAlert = UIAlertController(title: "로그인 실패", message : message, preferredStyle: .alert)
        let deniedOK = UIAlertAction(title: "확인", style: .default)
        deniedAlert.addAction(deniedOK)
        self.present(deniedAlert, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resoaurces that can be recreated.
    }
    
    @IBAction func SignIn(_ sender: Any) {
        let signInView = self.storyboard!.instantiateViewController(withIdentifier: "SignInVC")
        self.present(signInView, animated: false)
    }
    
    @IBAction func LogIn(_ sender: Any) {
        logInService.getUser().setID(id: IDTextField.text!)
        logInService.getUser().setPW(pw: PWTextField.text!)
        logInService.getUser().deviceToken = DeviceToken.Instance.token
        logInService.logIn()
    }
    
    func saveUser() -> Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.user, toFile: User.ArchiveURL.path)
        
        return isSuccessfulSave
    }
}
