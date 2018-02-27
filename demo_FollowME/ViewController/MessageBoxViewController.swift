//
//  MessageBoxTableViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 16..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class MessageBoxViewController: UITableViewController {
    
    var dataList = [MessageBox]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MessageBoxViewController viewDidLoad()")
        if let result = loadMessageBoxes(){
            self.dataList = result
        }
        self.tableView.rowHeight = 75.0
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Notification.Name.myNotification2, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MessageBoxViewController viewWillAppear()")
        if let result = loadMessageBoxes(){
            self.dataList = result
            self.reorderBoxes()
            self.tableView.reloadData()
        }
    }
    
    @objc func willEnterForeground(){
        print("MessageBoxViewController willEnterForeground()")
        if let result = loadMessageBoxes(){
            self.dataList = result
            self.reorderBoxes()
            self.tableView.reloadData()
        }
    }
    
    @objc func refreshView(){
        print("MessageBoxViewController refreshView()")
        if let result = loadMessageBoxes(){
            self.dataList = result
            self.reorderBoxes()            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row = dataList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBox")!
        var cellMessageLabel = cell.viewWithTag(101) as? UILabel
        var cellSenderLabel = cell.viewWithTag(102) as? UILabel
        cellMessageLabel?.text = row.lastMessage
        cellSenderLabel?.text = row.sender
        
        //***대충 이렇게 만들고 폰트 사이즈에 맞춰서 다시 그려야함
        if row.badge != 0{
            var accesoryBadge = UILabel()
            var string = String(row.badge)
            accesoryBadge.text = string
            accesoryBadge.backgroundColor = UIColor.red
            accesoryBadge.textColor = UIColor.white
            accesoryBadge.font = UIFont.systemFont(ofSize: 12)
            accesoryBadge.textAlignment = NSTextAlignment.center
            accesoryBadge.layer.cornerRadius = 12.5
            accesoryBadge.clipsToBounds = true
            accesoryBadge.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            
            cell.accessoryView = accesoryBadge
        }
        else{
            cell.accessoryView = nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        var row = dataList[indexPath.row]
        if let chatRoomVC =  self.storyboard!.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController {
            
            chatRoomVC.sender = row.sender
            //센더를 추가하여 ChatRoomView로 넘김
            self.present(chatRoomVC, animated: false, completion: nil)
//            self.navigationController?.pushViewController(chatRoomVC, animated: true)
        }
    }

    func reorderBoxes(){
        try self.dataList.sort(by: { (messagebox1, messagebox2) -> Bool in
            return messagebox1.timeStamp.compare(messagebox2.timeStamp) == ComparisonResult.orderedDescending
        })
    }
    
    func loadMessageBoxes() -> [MessageBox]? {
        print("MessageBoxViewController Load MessageBoxes")
        return NSKeyedUnarchiver.unarchiveObject(withFile: MessageBox.ArchiveURL.path) as? [MessageBox]
    }
}
