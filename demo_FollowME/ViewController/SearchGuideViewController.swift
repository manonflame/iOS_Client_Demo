//
//  SearchGuideViewController.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 10..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

class SearchGuideViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchInvitationService = SearchInvitationService()
    var list = [Invitation]()

    
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("tablieView for count : \(list.count)")
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationCell") as! InvitationCell

        let userid = cell.viewWithTag(101) as? UILabel
        let city = cell.viewWithTag(102) as? UILabel

        userid?.text = row.userid
        city?.text = row.city


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DID SELECTED ID: \(list[indexPath.row].userid) AND CITY : \(list[indexPath.row].city)")
        if let invitationVC = self.storyboard!.instantiateViewController(withIdentifier: "InvitationVC") as? InvitationViewController {
            invitationVC.userID = list[indexPath.row].userid
            invitationVC.city = list[indexPath.row].city
            self.present(invitationVC, animated: false, completion: nil)
        }
        
        
    }

    
    func loadUser() -> User? {
        print("loadUser() in SearchGuideVC")
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
    }
    
    
}
