//
//  AddInvitationViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 22..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class AddInvitationViewController: UIViewController, UITextFieldDelegate {

    /*
    UITextFieldDelegate
    { didSet { IDTextField.delegate = self } }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    */
    
    
    @IBOutlet weak var cityTextField: UITextField!{ didSet { cityTextField.delegate = self } }
    @IBOutlet weak var languageTextField: UITextField! { didSet { languageTextField.delegate = self } }
    
    @IBOutlet weak var languages1st: UILabel!
    @IBOutlet weak var languages2nd: UILabel!  
    @IBOutlet weak var languages3rd: UILabel!
    @IBOutlet weak var languages4th: UILabel!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    var saveInvitationService = SaveInvitationService()
    
    var invitation = Invitation()
    var languageCount = 0
    
    
    @IBAction func addLanguage(_ sender: Any) {
        print("addLanguage Clicked in AddInvitationVC ")
        if self.languageTextField.text != ""{
            invitation.languages.append(languageTextField.text!)
            languageCount += 1
            
            switch languageCount {
            case 1:
                languages1st.text = invitation.languages[0]
                languages2nd.text = ""
                languages3rd.text = ""
                languages4th.text = ""
            case 2:
                languages1st.text = invitation.languages[0]
                languages2nd.text = invitation.languages[1]
                languages3rd.text = ""
                languages4th.text = ""
            case 3:
                languages1st.text = invitation.languages[0]
                languages2nd.text = invitation.languages[1]
                languages3rd.text = invitation.languages[2]
                languages4th.text = ""
            case 4:
                languages1st.text = invitation.languages[0]
                languages2nd.text = invitation.languages[1]
                languages3rd.text = invitation.languages[2]
                languages4th.text = invitation.languages[3]
            default:
                languages1st.text = ""
                languages2nd.text = ""
                languages3rd.text = ""
                languages4th.text = ""
            }
            languageTextField.text = ""
        }
    }
    
    @IBAction func remove1stLang(_ sender: Any) {
        print("remove1stLang Clicked in AddInvitationVC ")
        invitation.languages.remove(at: 0)
        if(languageCount >= 1){
            languageCount -= 1
        }
        switch languageCount {
        case 1:
            languages1st.text = invitation.languages[0]
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        case 2:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = ""
            languages4th.text = ""
        case 3:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = ""
        case 4:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = invitation.languages[3]
        default:
            languages1st.text = ""
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        }
    }
    
    @IBAction func remove2ndLang(_ sender: Any) {
        print("remove2ndLang Clicked in AddInvitationVC ")
        invitation.languages.remove(at: 1)
        if(languageCount >= 2){
            languageCount -= 1
        }
        switch languageCount {
        case 1:
            languages1st.text = invitation.languages[0]
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        case 2:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = ""
            languages4th.text = ""
        case 3:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = ""
        case 4:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = invitation.languages[3]
        default:
            languages1st.text = ""
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        }
    }
    
    @IBAction func remove3rdLang(_ sender: Any) {
        print("remove3rdLang Clicked in AddInvitationVC ")
        invitation.languages.remove(at: 2)
        if(languageCount >= 3){
            languageCount -= 1
        }
        switch languageCount {
        case 1:
            languages1st.text = invitation.languages[0]
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        case 2:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = ""
            languages4th.text = ""
        case 3:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = ""
        case 4:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = invitation.languages[3]
        default:
            languages1st.text = ""
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        }
    }
    
    @IBAction func remove4thLang(_ sender: Any) {
        print("remove4thLang Clicked in AddInvitationVC ")
        invitation.languages.remove(at: 3)
        if(languageCount >= 4){
            languageCount -= 1
        }
        switch languageCount {
        case 1:
            languages1st.text = invitation.languages[0]
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        case 2:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = ""
            languages4th.text = ""
        case 3:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = ""
        case 4:
            languages1st.text = invitation.languages[0]
            languages2nd.text = invitation.languages[1]
            languages3rd.text = invitation.languages[2]
            languages4th.text = invitation.languages[3]
        default:
            languages1st.text = ""
            languages2nd.text = ""
            languages3rd.text = ""
            languages4th.text = ""
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDLabel.text = invitation.userid
        // Do any additional setup after loading the view.
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
    
    @IBAction func cancelMakingInvitation(_ sender: Any) {
        print("Cancel Clicked in AddInvitationVC ")
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @IBAction func confirmMakingInvitation(_ sender: Any) {
        print("Confirm Clicked in AddInvitationVC ")
        
        invitation.city = cityTextField.text!
        
        print("-----Confirm-----")
        print("userid : \(invitation.userid)")
        print("city : \(invitation.city)")
        for i in 0 ..< languageCount {
            print("languages \(i+1) : \(invitation.languages[i])")
        }
        print("-----------------")
        self.saveInvitationService.invitation = self.invitation
        self.saveInvitationService.confirm()
        
        self.presentingViewController?.dismiss(animated: false)
    }
}
