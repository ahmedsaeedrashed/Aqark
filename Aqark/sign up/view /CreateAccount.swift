//
//  CreateAccount.swift
//  Aqark
//
//  Created by Mahmoud Fouad on 5/19/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
//MARK: - create Account
extension SignUpView{
    func createUserAccount(email:String,password:String,confirm:String,username:String)
    {
        userViewModel = AccountViewModel(email: email, password: password, confirmPassword: confirm, username: username)
        checkValidation(for: userViewModel)
    }
    func createServiceAccount(email:String,password:String,confirm:String,username:String,
                              phone:String,country:String,company:String){
        serviceViewModel = AccountViewModel(email: email, password: password, confirmPassword: confirm, username: username, phone: phone, country: country, company: company,role:role)
        checkValidation(for: serviceViewModel)
    }
    
    func checkValidation(for viewModel : AccountViewModel)
    {
        if (viewModel.isValid)
        {
            signUpDataAccess = SignUpDataAccess()
            showActivityIndicator()
            viewModel.performCreation(dataAccess: signUpDataAccess ,completion: {[weak self]
                (result,flag) in
                
                if flag
                {
                    self?.stopActivityIndicator()
                    self?.gotoProfileView()
                }
                else
                {
                    self?.showAlert(with: result)
                }
            })
        }
        else
        {
            self.showAlert(with: viewModel.brokenRules[0].message)
        }
    }
    
    func gotoProfileView()
    {
        self.navigationController?.popViewController(animated: true)
        profileView = ProfileViewController()
        self.navigationController?.pushViewController(profileView, animated: true)
    }
}
