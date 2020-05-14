//
//  LoginViewModel.swift
//  Aqark
//
//  Created by ZeyadEl3ssal on 5/13/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation

class LoginViewModel : ValidationProtocol{
    var userEmail : String!
    var userPassword : String!
    var brokenRules: [BrokenRule] = [BrokenRule]()
    var isValid: Bool {
        get{
            self.brokenRules.removeAll()
            self.validate()
            return brokenRules.count == 0
        }
    }
    var dao = DataAccessLayer()
    
    func validate(){
        if(!(userEmail.isEmpty)){
            if(!(isValidEmail(email: userEmail))){
                self.brokenRules.append(BrokenRule(propertyName: "User Email", message: "The email or password you entered is invalid"))
            }
        }else{
            self.brokenRules.append(BrokenRule(propertyName: "User Email", message: "Email is required"))
        }
        
        if(!(userPassword.isEmpty)){
            if(userPassword.count < 6){
                self.brokenRules.append(BrokenRule(propertyName: "User Password", message: "The email or password you entered is invalid"))
            }
        }else{
            self.brokenRules.append(BrokenRule(propertyName: "User password", message: "Password is required"))
        }
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func authenticateLogin(){
        dao.login(userEmail: userEmail, userPassword: userPassword)
    }
}

