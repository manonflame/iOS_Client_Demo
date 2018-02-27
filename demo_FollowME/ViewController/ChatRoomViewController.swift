//
//  ChatRoomViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 14..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageCheckService = MessageCheckService()
    
    var sender = "EMPTY SENDER"
    @IBOutlet weak var msgTextField: UITextField! { didSet { msgTextField.delegate = self } }
    var timeStamp = Date()
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    var ArchiveURL : URL?
    var conversation = [Message]()
    var lastMessage = ""
    var sendingMessageService = SendingMessageService()
    
    var opositeImage = UIImage(named: "empty_profile_img")
    var getImageService = GetImageService()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CRVC viewDidLoad")
        getImageService.getImage(of: sender){ imageString, errormessage in
            if imageString != "empty"{
                print("이미지가 비어있지 않음 \(imageString)")
                var data = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!
                var image = UIImage(data: data)
                self.opositeImage = image!
                self.tableView.reloadData()
            }
            else{
                print("이미지가 비었음")
                self.opositeImage = UIImage(named: "empty_profile_img")!
                self.tableView.reloadData()
            }
        }

        //sender를 이용해서 저장된 메시지들을 불러들임
        ArchiveURL = ChatRoomViewController.DocumentsDirectory.appendingPathComponent("\(self.sender)")
        
        if let savedMessages = loadMessages() {
            conversation += savedMessages
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Notification.Name.myNotification, object: nil)
        self.navigationTitle.title = self.sender
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification : Notification){
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            self.bottomConstraint.constant = keyboardSize.height
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (complete) in
            
            if self.conversation.count > 0{
                self.tableView.scrollToRow(at: IndexPath(item:self.conversation.count - 1,section:0), at: UITableViewScrollPosition.bottom, animated: true)
                
            }
        })
    }
    @objc func keyboardWillHide(notification:Notification){
        self.bottomConstraint.constant = 20
        self.view.layoutIfNeeded()
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CRVC viewWillAppear")
        self.reorderConversations()
        
        self.tableView.reloadData()
        if self.conversation.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(item:self.conversation.count - 1, section:0), at: UITableViewScrollPosition.bottom, animated: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        messageCheckService.check(from: self.sender)
        MessageBoxSaver.resetMessageBox(sender: self.sender)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func willEnterForeground(){
        print("willEnterForeground")
        self.reorderConversations()
        self.tableView.reloadData()
        if self.conversation.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(item:self.conversation.count - 1, section:0), at: UITableViewScrollPosition.bottom, animated: true)
        }
        messageCheckService.check(from: self.sender)
        MessageBoxSaver.resetMessageBox(sender: self.sender)
    }
    
    @objc func refreshView(){
        print("CRVC take Post of NotificationCenter")
        //sender를 이용해서 저장된 메시지들을 불러들임
        if let savedMessages = loadMessages() {
            conversation = savedMessages
        }
        self.reorderConversations()
        self.tableView.reloadData()
        if self.conversation.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(item:self.conversation.count - 1, section:0), at: UITableViewScrollPosition.bottom, animated: true)
        }
        messageCheckService.check(from: self.sender)
        MessageBoxSaver.resetMessageBox(sender: self.sender)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if self.presentingViewController == nil{
            UserDefaults.standard.set(1, forKey: "status")
            Switcher.updateRootVC()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.conversation[indexPath.row].isMyComment{
            var cell = self.tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            cell.label_message.text = self.conversation[indexPath.row].comment
            cell.label_message.numberOfLines = 0
            
            return cell
        }
        else{
            var cell = self.tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
        
            cell.profileImage.image = self.opositeImage
            cell.label_message.text = self.conversation[indexPath.row].comment
            cell.label_name.text = self.conversation[indexPath.row].sender
            cell.label_message.numberOfLines = 0
            
            return cell
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func sendButton(_ sender: Any) {
        if self.msgTextField.text != ""{
            self.timeStamp = Date()
            let newMessage = Message.init(sender: self.sender, timeStamp: timeStamp, comment: self.msgTextField.text!, isMyComment: true)
        
            //서버로 메시지 보내기
            self.sendingMessageService.message = newMessage
            self.sendingMessageService.send()
            
            print("sendButton:: \(newMessage.isMyComment) ")
            conversation.append(newMessage)
            self.lastMessage = self.msgTextField.text!
            self.msgTextField.text = ""
            self.reorderConversations()
            self.tableView.reloadData()
            
            if self.conversation.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item:self.conversation.count - 1, section:0), at: UITableViewScrollPosition.bottom, animated: true)
            }
            saveMessages()
        }
    }
    
    func loadMessages() -> [Message]? {
        print("Load Messages")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [Message]
    }
    
    func saveMessages() {

        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(conversation, toFile: (ArchiveURL?.path)!)
        if isSuccessfulSave {
            print("Save Messages Successfully")
        }else{
            print("Save Messages Failed")
        }
        
        //메시지 박스 최신화
        MessageBoxSaver.save(sender: self.sender, timeStamp: self.timeStamp, lastMessage: self.lastMessage)
        MessageBoxSaver.resetMessageBox(sender: self.sender)
    }
    
    func reorderConversations(){
        try self.conversation.sort(by: { (message1, message2) -> Bool in
            return message1.timeStamp.compare(message2.timeStamp) == ComparisonResult.orderedAscending
        })
    }
}

class MyMessageCell : UITableViewCell {
    @IBOutlet weak var label_message: UILabel!
    
}

class DestinationMessageCell : UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var label_message: UILabel!
    @IBOutlet weak var label_name: UILabel!
    
}
