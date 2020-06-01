//
//  AgentPropertiesView.swift
//  Aqark
//
//  Created by Mahmoud Fouad on 5/28/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit
import Cosmos

class AgentPropertiesView: UIViewController {
    
    @IBOutlet weak var rateHeight: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var advertisementsCollection: UICollectionView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rate: CosmosView!
    var agentId:String!
    var agentName:String!
    var agentRateViewModel:AgentRateViewModel!
    let networkIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let agentDataAccess:AgentDataAccess = AgentDataAccess()
    var listOfAdvertisements:[AgentAdvertisementViewModel] = []{
        didSet{
            if listOfAdvertisements.count>0{
                statusLabel.isHidden = true
            }
            else
            {
                statusLabel.text = "No Advertisements Available"
                statusLabel.isHidden = false
            }
            advertisementsCollection.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!AgentPropertiesNetworking.checkNetworkConnection())
        {
            statusLabel.isHidden = false
            statusLabel.text = "Internet Connection Not Available"
        }
        self.navigationItem.title = "\(agentName ?? "Agent")'s Properties"
        setupCollection()
    }
    override func viewWillAppear(_ animated: Bool) {
        if(AgentPropertiesNetworking.checkNetworkConnection())
        {
            showIndicator()
            bindCollectionData()
            setupAgentRate()
            statusLabel.isHidden = true
        }
        else
        {
            statusLabel.isHidden = false
            statusLabel.text = "Internet Connection Not Available"
        }
    }
}


//MARK: - UIViewIndicator
extension AgentPropertiesView{
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
