//
//  FavouriteViewController.swift
//  Aqark
//
//  Created by Mostafa Samir on 5/29/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit


class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    @IBOutlet weak var labelPlaceHolder: UILabel!
    var coreDataViewModel: CoreDataViewModel?
    var adViewModel: FavouriteViewModel!
    var adsCount:Int=0
    var favouriteListViewModel:FavouriteListViewModel!
    var alert: UIAlertController!
    var arrOfAdViewModel:[FavouriteViewModel]! = []{
        didSet{
            if arrOfAdViewModel.count == 0{
                setEmptyAdvertisments(flag: false)
            }else{
                setEmptyAdvertisments(flag: true)
            }
            self.favouriteCollectionView.reloadData()
        }
    }
    func setupObjects(){
        favouriteListViewModel=FavouriteListViewModel(dataAccess: FavouriteDataAccess())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favourite".localize
        self.view.backgroundColor = UIColor(rgb: 0xf1faee)
        favouriteCollectionView.backgroundColor = UIColor(rgb: 0xf1faee)
        self.setupCoredata()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if !FavoriteNetworking.checkNetworkConnection(){
            favouriteCollectionView.isHidden = true
            labelPlaceHolder.text = "Internet Connection Not Available".localize
        }else{
            labelPlaceHolder.isHidden = true
            setupObjects()
            getCollectionViewData()
        }
    }
    
    func showDeletedAdsAlert(){
        if (adsCount != 0){
            self.alert = UIAlertController(title: "Deleted Advertisment".localize, message: "There are".localize + self.convertNumbers(lang: "lang".localize, stringNumber: String(adsCount)).1 + "Advertisment deleted from your Favourite List".localize, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            adsCount=0
        }
    }
    
    func setEmptyAdvertisments(flag: Bool){
        self.labelPlaceHolder.isHidden = flag
        self.labelPlaceHolder.text = "There is no advertisements in favourite list.".localize
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        if favouriteListViewModel != nil{
            favouriteListViewModel.removeFavObserver()
        }
        coreDataViewModel=nil
        favouriteListViewModel=nil
        alert = nil
        print("favourite Disappear")
    }
  
}
