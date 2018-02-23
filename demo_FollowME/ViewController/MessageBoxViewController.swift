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
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MessageBoxViewController viewWillAppear()")
        if let result = loadMessageBoxes(){
            self.dataList = result
            self.tableView.reloadData()
        }
    }
    
    @objc func willEnterForeground(){
        print("MessageBoxViewController willEnterForeground()")
        if let result = loadMessageBoxes(){
            self.dataList = result
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadMessageBoxes() -> [MessageBox]? {
        print("MessageBoxViewController Load MessageBoxes")
        return NSKeyedUnarchiver.unarchiveObject(withFile: MessageBox.ArchiveURL.path) as? [MessageBox]
    }

}
