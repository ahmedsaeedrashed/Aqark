//
//  ProfileData.swift
//  Aqark
//
//  Created by Mahmoud Fouad on 5/16/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
import Firebase
class ProfileDataAccess{
    
    var profileDataRef:DatabaseReference! = Database.database().reference()
    var profileDataHandle:DatabaseHandle!
    var profileAdvertisementsIDsRef:DatabaseReference! = Database.database().reference()
    var profileAdvertisementsIDsHandel:DatabaseHandle!
    var allAdvertisementsRef:DatabaseReference! = Database.database().reference()
    var deleteRef:DatabaseReference! = Database.database().reference()
    var deletAdsRef:DatabaseReference! = Database.database().reference()
    func getProfileData(onSuccess:@escaping(Profile)->Void,onFailure:@escaping(Error)-> Void){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        profileDataHandle =  profileDataRef.child("Users").child(userID).observe(.value, with: { (snapshot) in
            
            if(snapshot.exists())
            {
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                let userRole = value?["role"] as? String ?? ""
                let picture = value?["picture"] as? String ?? ""
                let country = value?["country"] as? String ?? ""
                let company = value?["company"] as? String ?? ""
                let phone = value?["phone"] as? String ?? ""
                let exp = value?["experience"] as? String ?? ""
                let rate = value?["rate"] as? [String:Double] ?? ["":0.0]
                let ban = value?["banned"] as? Bool ?? false
                let profile:Profile = Profile(role: userRole, picture: picture, username: username, country: country, company: company, phone: phone, experience: exp, rate: rate, ban: ban)
                onSuccess(profile)
                
            }
        }) { (error) in
            onFailure(error)
        }
    }
    
    func profileLogout()
    {
        if ProfileNetworking.checkNetworkConnection(){
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    
    func reomveProfileDataObserver()
    {
        profileDataRef.removeObserver(withHandle: profileDataHandle)
        profileDataRef = nil
        profileDataHandle = nil
    }
}


