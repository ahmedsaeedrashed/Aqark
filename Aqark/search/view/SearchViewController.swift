//
//  SearchViewController.swift
//  Aqark
//
//  Created by shorouk mohamed on 5/11/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit
import ReachabilitySwift
import SDWebImage

class SearchViewController: UIViewController,UIActionSheetDelegate{
    /// the float button's trailing padding
                  fileprivate let floatButtonTrailingPadding: CGFloat = 15

              /// the float button's bottom padding
              fileprivate let floatButtonBottomPadding: CGFloat = 15
    
    
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var swapLabel: UIImageView!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var labelPlaceHolder: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    var btn = UIButton(type: .custom)
    var adViewModel : AdvertisementViewModel!
    var isSorting: String = "default"
    var collectionViewFlowLayout:UICollectionViewFlowLayout!
    var advertismentsListViewModel : AdvertisementListViewModel!
    let searchController = UISearchController(searchResultsController: nil)
    var data : AdvertisementData!
    var filteredAdsList = [AdvertisementViewModel]()
    var sortedList = [AdvertisementViewModel]()
    var adsSortedList = [AdvertisementViewModel]()
    var unFilteredAdsList = [AdvertisementViewModel]()
    let networkIndicator = UIActivityIndicatorView(style: .whiteLarge)
    var arrOfAdViewModel : [AdvertisementViewModel]!{
        didSet{
            self.searchCollectionView.reloadData()
            stopIndicator()
            notificationBtn.isHidden = false
            searchBar.isHidden = false
            filterBtn.isHidden = false
            filterImage.isHidden = false
            self.manageAppearence(sortBtn: false, swapLabel: false)
            UIView.animate(withDuration:2) {
                self.view.alpha = 1
            }
        }
    }
    var searchBarText:String!{
        didSet{
            filterContentForSearchBarText(searchBar.text!)
            if filteredAdsList.count == 0 {
                labelPlaceHolder.isHidden = false
                labelPlaceHolder.text = "No Advertisements Found"
                self.manageAppearence(sortBtn: true, swapLabel: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !checkNetworkConnection(){
            labelPlaceHolder.isHidden = false
            self.view.alpha = 1
            labelPlaceHolder.text = "No Internet Connection"
        }else{
            manageSearchBar()
            floatingButton()
            showIndicator()
            setUpCollectionView()
            getCollectionViewData()
        }
    }
    
    func manageAppearence(sortBtn: Bool,swapLabel: Bool ){
        self.sortBtn.isHidden = sortBtn
        self.swapLabel.isHidden = swapLabel
    }
    
    @IBAction func showSortingActionSheet(_ sender: Any) {
        showSortingAlert()
    }
    
    func checkNetworkConnection()->Bool
    {
        let connection = Reachability()
        guard let status = connection?.isReachable else{return false}
        return status
    }
   
}

//MARK: - UIViewIndicator
extension SearchViewController{
    func showIndicator()
    {
        networkIndicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        networkIndicator.center = view.center
        networkIndicator.startAnimating()
        view.addSubview(networkIndicator)
    }
    
    func stopIndicator() {
        networkIndicator.stopAnimating()
    }
}



