//
//  ProfileAdvertisementViewModel.swift
//  Aqark
//
//  Created by Mahmoud Fouad on 5/20/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
class ProfileAdvertisementViewModel{
    var propertyType:String!
    var price:String!
    var address:String!
    var bedroom:String!
    var bathroom:String!
    var size:String!
    init(advertisement:ProfileAdvertisement) {
        self.propertyType = advertisement.propertyType
        self.price = advertisement.price
        self.address = advertisement.address
        self.bedroom = advertisement.bed
        self.bathroom = advertisement.bathroom
        self.size = advertisement.propertySize
    }
}


class ProfileAdvertisementListViewModel{
    var advertisements:[ProfileAdvertisementViewModel] = []
    var advertisementsData:ProfileDataAccess
    init(data:ProfileDataAccess) {
        self.advertisementsData = data
    }
    func getAllAdvertisements(completion:@escaping([ProfileAdvertisementViewModel])->Void)
    {
        advertisementsData.getProfileAdvertisementsIDs(completion: {[weak self]
            (store) in
            print(store.allAdvertisements.count)
            for advertisement in store.allAdvertisements
            {
                print(advertisement)
                self?.advertisements.append(ProfileAdvertisementViewModel(advertisement: advertisement))
            }
//            self?.advertisements = store.allAdvertisements.map{
//                advertisement in ProfileAdvertisementViewModel(advertisement: advertisement)
//            }
            //print(self?.advertisements)
            completion((self?.advertisements ?? []))
        })
    }
}