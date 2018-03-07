//
//  CampaignViewController.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 12/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class CampaignViewController: UIViewController {
    
    var mainView : UIView!
    var campaignId: String!
    var campaignView: LoyagramCampaignView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainView)
        
        
        //Main View Constrinats
        let mainViewTrailing  = NSLayoutConstraint(item: self.mainView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let mainViewLeading  = NSLayoutConstraint(item: self.mainView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let mainViewTop  = NSLayoutConstraint(item: self.mainView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let mainViewBottom  = NSLayoutConstraint(item: self.mainView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([mainViewTrailing,mainViewLeading,mainViewTop,mainViewBottom])
        self.view.layoutIfNeeded()
        campaignView = LoyagramCampaignView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        campaignView.setViewController(vc: self)
        self.mainView.addSubview(campaignView)
        
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        
        //Campaign View Constrinats
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: campaignView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
        
        getCampaignFromServer(campaignId: campaignId)
         print("fonts in sdk\(UIFont.familyNames)")
        
    }
    
    @objc func getCampaignFromServer(campaignId: String) {
        
        LoyagramCampaignManager.requestCampaignFromServer(campaignId: campaignId, completion: { (campaign) -> Void in
            if campaign.questions.count > 0 {
                
                DispatchQueue.main.async() {
                    self.campaignView.setCampaign(campaign: campaign)
                }
            }
            
        }, failure:{() -> Void in
            DispatchQueue.main.async() {
                self.campaignView.campaignErrorHandler()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
