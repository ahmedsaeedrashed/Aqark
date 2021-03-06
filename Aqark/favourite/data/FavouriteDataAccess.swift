//
//  FavouriteDataAccess.swift
//  Aqark
//
//  Created by Mostafa Samir on 5/29/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SDWebImage

class FavouriteDataAccess {
    
    var advertisementImage : String!
    var advertisementPropertyType : String!
    var advertisementType : String!
    var advertisementId  : String!
    var advertisementAddress : String!
    var advertisementCountry : String!
    var advertisementPropertySize : String!
    var advertisementBedRoomsNum : String!
    var advertisementBathRoomsNum : String!
    var advertisementPropertyPrice : String!
    var advertisementPropertyLocation : String!
    var advertisementPropertyLongtiude : String!
    var advertisementPropertyLatitude : String!
    var advertisementDate : String!
    var addressDictionary: [String: String] = [:]
    var coreDataAccess: CoreDataAccess! = CoreDataAccess()
    var advertisementRef:DatabaseReference! = Database.database().reference()
    
    func getAllFavouriteAdvertisements(completionForGetAllAdvertisements : @escaping (_ searchResults:[FavouriteModel],Int) -> Void){
        var advertismentCount = 0
        var advertisementsData = [FavouriteModel]()
        let idsArray = coreDataAccess.getAllAdvertisment()
        if (idsArray.count != 0){
            for index in 0..<idsArray.count{
                advertisementRef.child("Advertisements").child(idsArray[index]).observeSingleEvent(of: .value, with: { [weak self](snapshot) in
                    if snapshot.exists(){
                        let dict = snapshot.value as? [String : Any]
                        let key = snapshot.key as String
                        advertisementsData.append((self?.createAdvertisementSearchModel(dict: dict , key: key))!)
                    }else{
                        advertismentCount += 1
                        self?.coreDataAccess.deleteFromFavourite(id: idsArray[index])
                    }
                    if (advertismentCount + advertisementsData.count == idsArray.count){
                        completionForGetAllAdvertisements(advertisementsData,advertismentCount)
                    }
                })
            }
        }
        
    }
    
    func createAdvertisementSearchModel(dict : [String : Any]?, key : String)-> FavouriteModel{
        let images = dict!["images"] as? [Any]
        self.advertisementImage = images?[0] as? String ?? "NoImage"
        self.advertisementPropertyType = dict?["propertyType"] as? String ?? "Not Applied"
        self.advertisementType = dict?["Advertisement Type"] as? String ?? "Not Applied"
        self.advertisementCountry = dict?["country"] as? String ?? "Not Applied"
        self.advertisementId = key
        self.advertisementPropertySize = dict?["size"] as? String ?? "Not Applied"
        self.advertisementDate = dict?["date"] as? String ?? "Not Applied"
        self.advertisementBedRoomsNum = dict?["bedRooms"] as? String ?? "Not Applied"
        self.advertisementBathRoomsNum = dict?["bathRooms"] as? String ?? "Not Applied"
        self.advertisementPropertyPrice = Localization.convertNumbers(lang: "lang".localize, stringNumber: (dict?["price"] as? String) ?? "0").0.stringValue
        if var unwrappedAddressDict = dict?["Address"] {
            unwrappedAddressDict = dict?["Address"] as! [String : String]
            self.addressDictionary = unwrappedAddressDict as! [String : String]
            self.advertisementPropertyLocation = self.addressDictionary["location"] ?? "Not Applied"
            self.advertisementPropertyLatitude = self.addressDictionary["latitude"] ?? "0.0"
            self.advertisementPropertyLongtiude = self.addressDictionary["longitude"] ?? "0.0"
        }else{
            self.advertisementPropertyLocation = "Not Applied"
        }
        return FavouriteModel(
            image: self.advertisementImage, propertyType  : self.advertisementPropertyType,
            advertisementType: self.advertisementType,
            advertisementId: self.advertisementId,
            price: Double(self.advertisementPropertyPrice),
            address: self.advertisementPropertyLocation,
            country: self.advertisementCountry,
            size: self.advertisementPropertySize,
            bedRoomsNumber: self.advertisementBedRoomsNum,
            bathRoomsNumber:  self.advertisementBathRoomsNum,
            date : self.advertisementDate
        )
    }
    
    func removeFavouriteObserver()
    {
        
        advertisementRef = nil
        coreDataAccess = nil
    }
    
}
