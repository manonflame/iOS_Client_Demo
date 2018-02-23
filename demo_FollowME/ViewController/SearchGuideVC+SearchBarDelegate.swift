//
//  SearchGuideVC+SearchBarDelegate.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 1. 19..
//  Copyright © 2018년 민경준. All rights reserved.
//

import UIKit

extension SearchGuideViewController: UISearchBarDelegate {
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        print("searchBarSearchButtonClicked()")
        if !searchBar.text!.isEmpty {
            searchInvitationService.searchInvitations(city: searchBar.text!){
                results, errormessage in
                if let results = results {
                    self.list = results
                    self.tableView.reloadData()
                    
                    for x in self.list {
                        print(x.city)
                        print(x.userid)
                    }
                }
                else{
                    print("results가 비엇음")
                }
            }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}
