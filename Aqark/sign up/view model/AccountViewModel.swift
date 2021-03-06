//
//  AccountViewModel.swift
//  Aqark
//
//  Created by Mahmoud Fouad on 5/12/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
import UIKit
//MARK: - Properties and Initialization
class AccountViewModel:Validation{
   var email:String!
   var password:String!
   var confirmPassword:String!
   var username:String!
   var phone:String!
   var country:String!
   var company:String!
   var role:String!
   var brokenRules: [SignUpBrokenRule] = [SignUpBrokenRule]()
   var isValid: Bool{
        get{
            self.brokenRules = [SignUpBrokenRule]()
            self.validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    init(email:String,password:String,confirmPassword:String,username:String) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.username = username
        self.role = "user"
        self.phone=""
        self.company=""
        self.country=""
    }
    
    convenience init(email:String,password:String,confirmPassword:String,username:String,
                     phone:String,country:String,company:String,role:String) {
        
         self.init(email: email, password: password, confirmPassword: confirmPassword, username: username)
        self.phone = phone
        self.country = country
        self.company = company
        self.role = role
    }
}
//MARK: -  Perform Creation
extension AccountViewModel{
    func performCreation(dataAccess:SignUpDataAccess,completion:@escaping (String,Bool)->Void)
    {
       let user =  User(email:email, password: password, username: username, phone: phone, country: country, company: company, role: role)
        dataAccess.createAccount(user:user, completion: {(result,flag)in
            completion(result,flag)
        })
    }
}
//MARK: - Validate
extension AccountViewModel{
   private func validate()
    {
        switch role.lowercased() {
        case "user":
            self.validateEmail()
            self.validatePassword()
            self.validateConfirmPassword()
            self.validateUsername()
        default:
            self.validateEmail()
            self.validatePassword()
            self.validateConfirmPassword()
            self.validateUsername()
            self.validatePhone()
            self.validateAddress()
        }
    }
}
//MARK: - Validate Email
extension AccountViewModel{
    private func validateEmail(){
        if(email.isEmpty)
        {
            self.brokenRules.append(SignUpBrokenRule(name:"Email".localize,message:"An email address must be provided.".localize))
        }
        else {
             let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
             let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
             if (!emailPred.evaluate(with: email))
             {
                self.brokenRules.append(SignUpBrokenRule(name:"Email".localize,message:"The email address is badly formatted.".localize))
             }
        }
    }
}
//MARK: - Validate Password
extension AccountViewModel{
    private func validatePassword(){
        if(password.isEmpty || password.count<6)
        {
            self.brokenRules.append(SignUpBrokenRule(name:"Password".localize,message:"The password must be 6 characters long or more.".localize))
        }
    }
}

//MARK: - Validate Confirm Password
extension AccountViewModel{
    func validateConfirmPassword(){
        if(self.confirmPassword.isEmpty || !self.confirmPassword.elementsEqual(self.password)){
            self.brokenRules.append(SignUpBrokenRule(name:"Confirm Password".localize,message:"Those passwords did not match.".localize))
        }
    }
}

//MARK: - Validate Username
extension AccountViewModel{
    func validateUsername(){
        if (self.username.isEmpty){
            self.brokenRules.append(SignUpBrokenRule(name:"Username".localize,message:"Username must be provided.".localize))
        }
        else
        {
            let usernameRegEX = "^(?=.{6,20}$)(?![0-9._])(?!.*[_.]{2})[a-zA-Z0-9._\\u0621-\\u064A ]+(?<![_.])$";
            let usernamePred = NSPredicate(format:"SELF MATCHES %@",usernameRegEX )
            if (!usernamePred.evaluate(with: username))
            {
                self.brokenRules.append(SignUpBrokenRule(name:"Username".localize,
                                                         message:"Username must start of letter and be between 6 and 20 characters.".localize))
            }
        }
    }
}

//MARK: - Validate Phone
extension AccountViewModel{
    func validatePhone()
    {
        if(self.phone.isEmpty)
        {
            self.brokenRules.append(SignUpBrokenRule(name:"phone".localize,message: "Phone number must be provided.".localize))
        }
        else {
            let phoneRegex = "^[0][1]\\d{9}$".localize
            let phonePred = NSPredicate(format:"SELF MATCHES %@",phoneRegex)
            if (!phonePred.evaluate(with: phone))
            {
                self.brokenRules.append(SignUpBrokenRule(name:"phone".localize,message: "Phone number is badly formatted.".localize))
            }
        }
    }
}

//MARK: - Validate Address
extension AccountViewModel{
    func validateAddress()
    {
        if(self.country.isEmpty)
        {
            self.brokenRules.append(SignUpBrokenRule(name:"address",message: "Address must be provided.".localize))
        }
        
    }
}






