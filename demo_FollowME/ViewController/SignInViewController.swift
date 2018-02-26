//
//  SignInViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 10..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, signInBoxDelegate, UITextFieldDelegate {

    var user: User = User(id: "", pw: "")
    var signInService = SignInService()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var IDTextField: UITextField! { didSet { IDTextField.delegate = self } }
    @IBOutlet weak var PWTextField: UITextField! { didSet { PWTextField.delegate = self } }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        signInService.delegate = self
        
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageView.frame.height/2
        self.imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        
    }
    
    @objc func imagePicker(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            var cgSize = CGSize(width: 200.0, height: 200.0)
            self.imageView.image = self.resizeImage(image: image, targetSize: cgSize)
        }
        else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            var cgSize = CGSize(width: 200.0, height: 200.0)
            self.imageView.image = self.resizeImage(image: image, targetSize: cgSize)
        }
        
        
        

        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage{
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize : CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }else{
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage!
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
        let imageData = UIImagePNGRepresentation(self.imageView.image!)
        let base64String = imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)

        signInService.getUser().profileImage = base64String!
        signInService.signIn()
    }
    
    
    
}
