//
//  AdminUsersListViewModel.swift
//  Aqark
//
//  Created by ZeyadEl3ssal on 5/17/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation

class AdminUsersListViewModel{
    
    var adminViewList : [AdminUserViewModel] = [AdminUserViewModel]()
    var adminUsersList : [AdminUserViewModel] = [AdminUserViewModel]()
    var adminLawyersList : [AdminUserViewModel] = [AdminUserViewModel]()
    var adminInteriorDesignersList : [AdminUserViewModel] = [AdminUserViewModel]()
    let dataAccess : AdminDataAccessLayer
    
    init(dataAccess:AdminDataAccessLayer) {
        self.dataAccess = dataAccess
    }
    
    func populateUsers(completionForPopulateUsers : @escaping() -> Void){
        dataAccess.getUsers { (usersData) in
            self.filter(allUsersData: usersData)
            //            self.adminUsersList = usersData.map { userData in
            //                return AdminUserViewModel(adminUser: userData)
            //            }
            completionForPopulateUsers()
        }
    }
    
    private func filter(allUsersData : [AdminUser]){
        for user in allUsersData{
            switch user.userRole.lowercased() {
            case UserRole.user:
                let user = AdminUserViewModel(adminUser: user)
                adminUsersList.append(user)
            case UserRole.lawyer.lowercased():
                let lawyer = AdminUserViewModel(adminUser: user)
                adminLawyersList.append(lawyer)
            default:
                let interiorDesigner = AdminUserViewModel(adminUser: user)
                adminInteriorDesignersList.append(interiorDesigner)
            }
        }
        adminViewList = adminUsersList
    }
    
    func getUsersByType(type:Int){
        switch type {
        case 0:
            adminViewList = adminUsersList
        case 1:
            adminViewList = adminLawyersList
        default:
            adminViewList = adminInteriorDesignersList
        }
    }
    
    func getFilteredUsers(type:Int,searchText:String){
        if(searchText.isEmpty){
            switch type {
            case 0:
                adminViewList = adminUsersList
            case 1:
                adminViewList = adminLawyersList
            default:
                adminViewList = adminInteriorDesignersList
            }
        }else{
            switch type{
            case 0:
                adminViewList = adminUsersList.filter{(user:AdminUserViewModel) -> Bool in
                    return user.userName.lowercased().contains(searchText.lowercased())
                }
            case 1:
                adminViewList = adminLawyersList.filter{(user:AdminUserViewModel) -> Bool in
                    return user.userName.lowercased().contains(searchText.lowercased())
                }
            default:
                adminViewList = adminInteriorDesignersList.filter{(user:AdminUserViewModel) -> Bool in
                    return user.userName.lowercased().contains(searchText.lowercased())
                }            }
        }
    }
}
