//
//  extensionSegment.swift
//  Aqark
//
//  Created by AhmedSaeed on 5/27/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
import UIKit

extension AddAdvertisementViewController{
    
//MARK:- func to Config segment
   
   @IBAction func selectAdvertisementType(_ sender: UISegmentedControl) {
       switch sender.selectedSegmentIndex {
       case 0:
           advertisementType = "Rent"
       case 1:
           advertisementType = "Buy"
       default:
           print("error")
       }
       
       updatePlaceholderForPriceTextFeild()
   }
    
    
   func updatePlaceholderForPriceTextFeild(){
       
       if advertisementType == "Rent"
       {
           switch propertyType {
           case "Apartment":
               priceTxtField.placeholder = "minimum price is 500$"
           case "Villa":
               priceTxtField.placeholder = "minimum price is 5000$"
           case "Room":
               priceTxtField.placeholder = "minimum price is 200$ "
           default:
               print("noselection")
           }
           
       }else{
           switch propertyType {
           case "Apartment":
               priceTxtField.placeholder = "minimum price is 50,000$ "
           case "Villa":
               priceTxtField.placeholder = "minimum price is 500,000$ "
           case "Room":
               priceTxtField.placeholder = "minimum price is 10,000$ "
               
           default:
               print("noselection")
           }
           
       }
   }
    
    
}
