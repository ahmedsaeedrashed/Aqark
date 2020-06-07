//
//  AdminUsersViewController.swift
//  Aqark
//
//  Created by ZeyadEl3ssal on 5/16/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class AdminUsersViewController: UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var usersSearchBar: UISearchBar!
    
    @IBOutlet weak var usersSegment: CustomSegment!
    @IBOutlet weak var usersTableView: UITableView!
    var adminUsersViewModel : AdminUsersListViewModel!
    private var dataAccess : AdminDataAccess!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataAccess = AdminDataAccess()
        adminUsersViewModel = AdminUsersListViewModel(dataAccess: dataAccess)
        if(adminUsersViewModel.checkNetworkConnection()){
            activityIndicator.startAnimating()
            self.view.alpha = 0
            
            usersTableView.register(UINib(nibName: "AdminUserTableViewCell", bundle: nil), forCellReuseIdentifier: "User Cell")
            usersTableView.delegate = self
            usersTableView.dataSource = self
            usersSearchBar.delegate = self
            adminUsersViewModel.populateUsers {
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration:2) {
                    self.view.alpha = 1
                }
                self.usersSegment.isHidden = false
                if(self.adminUsersViewModel.adminUsersViewList.isEmpty){
                    self.setLabelForZeroCount(search: false)
                }else{
                    self.usersSearchBar.isHidden = false
                    self.usersTableView.reloadData()
                }
            }
        }else{
            noLabel.isHidden = false
            noLabel.text = "No Internet Connection."
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Users"
        
    }
    
    func setupViews(){
        usersSearchBar.isHidden = true
        usersSegment.isHidden = true
    }
    
    func setLabelForZeroCount(search:Bool){
        usersSearchBar.isHidden = !search
        noLabel.isHidden = false
        switch usersSegment.selectedIndex {
        case 0:
            noLabel.text = "No Available Users."
        case 1:
            noLabel.text = "No Available Lawyers."
        default:
            noLabel.text = "No Available Interior Designers."
        }
    }
    
    @IBAction func changeUserType(_ sender: Any) {
        adminUsersViewModel.getUsersByType(type: usersSegment.selectedIndex)
        if(self.adminUsersViewModel.adminUsersViewList.isEmpty){
            self.setLabelForZeroCount(search: false)
        }else{
            usersSearchBar.isHidden = false
            noLabel.isHidden = true
        }
        self.usersTableView.reloadData()
    }
}


