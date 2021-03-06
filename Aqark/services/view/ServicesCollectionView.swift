//
//  ServicesCollectionView.swift
//  Aqark
//
//  Created by ZeyadEl3ssal on 6/12/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
import UIKit

extension ServicesViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.servicesViewModel.serviceUsersViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let serviceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Service Cell", for: indexPath) as! ServicesCollectionViewCell
        serviceCell.serviceUserCellIndex = indexPath
        serviceCell.serviceUserDelegate = self
        serviceCell.serviceUserName.text = servicesViewModel.serviceUsersViewList[indexPath.row].serviceUserName
        serviceCell.serviceUserCompany.text = servicesViewModel.serviceUsersViewList[indexPath.row].serviceUserCompany
        serviceCell.serviceUserLocation.text = splitCountry(servicesViewModel.serviceUsersViewList[indexPath.row].serviceUserCountry).localize
        if "lang".localize.elementsEqual("en")
        {
            serviceCell.serviceUserExperience.text = self.convertNumbers(lang: "lang".localize, stringNumber: servicesViewModel.serviceUsersViewList[indexPath.row].serviceUserExperience).1 + " exp years.".localize
        }else{
            let numberOfExp = self.convertNumbers(lang: "lang".localize, stringNumber: servicesViewModel.serviceUsersViewList[indexPath.row].serviceUserExperience).0.intValue
            if numberOfExp == 0 {
                serviceCell.serviceUserExperience.text = ""
            }
            else if numberOfExp == 1{
                
                serviceCell.serviceUserExperience.text = "سنه خبره"
            }else if numberOfExp == 2{
                
                serviceCell.serviceUserExperience.text = "سنتين خبره"
            }else{
                
                serviceCell.serviceUserExperience.text = self.convertNumbers(lang: "lang".localize, stringNumber: String(numberOfExp)).1 + " exp years.".localize
            }
        }
        
        serviceCell.serviceUserRating.rating =
            servicesViewModel.serviceUsersViewList[indexPath.row].serviceUserServiceRating
        let serviceUserImageURL = URL(string: servicesViewModel.serviceUsersViewList[indexPath.row].ServiceUserImage)
        serviceCell.serviceUserImage.sd_setImage(with:serviceUserImageURL , placeholderImage: UIImage(named: "profile_user"))
//        if(isUserLogged == !(servicesViewModel.checkLoggedUser())){
//            isUserLogged = servicesViewModel.checkLoggedUser()
//            serviceCell.setNeedsLayout()
//        }
        return serviceCell
    }
}

extension ServicesViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 170)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}


