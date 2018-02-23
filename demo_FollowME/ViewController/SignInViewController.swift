//
//  SignInViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 10..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, signInBoxDelegate, UITextFieldDelegate {


    
    

    var user: User = User(id: "", pw: "")
    @IBOutlet weak var IDTextField: UITextField! { didSet { IDTextField.delegate = self } }
    @IBOutlet weak var PWTextField: UITextField! { didSet { PWTextField.delegate = self } }
    var signInService = SignInService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        signInService.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signInAccepted() {
        print("sign in succeed")
        let acceptedAlert = UIAlertController(title: "가입 완료", message : "성공적으로 가입되었습니다.", preferredStyle: .alert)
        let acceptedOK = UIAlertAction(title: "확인", style: .default){
            (_) in
            self.presentingViewController?.dismiss(animated: false)
        }
        acceptedAlert.addAction(acceptedOK)
        self.present(acceptedAlert, animated: false)
    }
    
    func singInDenied() {
        print("sign in denied")
        let deniedAlert = UIAlertController(title: "가입 실패", message : "이미 가입된 아이디 입니다.", preferredStyle: .alert)
        let deniedOK = UIAlertAction(title: "확인", style: .default)
        deniedAlert.addAction(deniedOK)
        self.present(deniedAlert, animated: false)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @IBAction func singIn(_ sender: Any) {
        signInService.getUser().setID(id: IDTextField.text!)
        signInService.getUser().setPW(pw: PWTextField.text!)
        signInService.signIn()
    }
    
    
    
}
