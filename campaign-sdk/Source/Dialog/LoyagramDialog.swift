//
//  LoyagramDialog.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 16/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramDialog: UIView {
    
    var backgroundView = UIView()
    var campaignView: LoyagramCampaignView!
    var dialogHeight: NSLayoutConstraint?
    
    init(frame: CGRect, campaignId: String, colorPrimary:UIColor) {
        super.init(frame: frame)
        initDialogView(colorPrimary: colorPrimary, campaignId: campaignId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initDialogView(colorPrimary: UIColor, campaignId: String) {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        //backgroundView.alpha = 0.6
        addSubview(backgroundView)
        
        campaignView = LoyagramCampaignView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), color:colorPrimary)
        
        //addSubview(campaignView)
        
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // background View constraints
        let bgTrailing  = NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let bgLeading  = NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let bgTop  = NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let bgBottom  = NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([bgTrailing,bgLeading,bgTop,bgBottom])
        
        
        //Campaign View constraints
//        let campaignViewTrailing  = NSLayoutConstraint(item: campaignView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
//        let campaignViewLeading  = NSLayoutConstraint(item: campaignView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
//
//        let campaignCenterX  = NSLayoutConstraint(item: campaignView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
//
//        let campaignCenterY  = NSLayoutConstraint(item: campaignView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
//
//        dialogHeight = NSLayoutConstraint(item: campaignView, attribute: .height
//            , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 400.0)
//
//        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignCenterX,campaignCenterY, dialogHeight!])
        
        getCampaignFromServer(campaignId: campaignId)
    }
    
    override func layoutSubviews() {
        if(dialogHeight != nil)  {
            if(self.frame.height < self.frame.width) {
                dialogHeight?.constant = self.frame.width - 50
            } else {
                dialogHeight?.constant = 400
            }
        }
    }
    
    @objc func getCampaignFromServer(campaignId: String) {
        
        LoyagramCampaignManager.requestCampaignFromServer(campaignId: campaignId, completion: { (campaign) -> Void in
            let questionCount: Int = campaign.questions?.count ?? 0
            if questionCount > 0 {
                DispatchQueue.main.async() {
                    self.campaignView.setCampaign(campaign: campaign)
                }
            } else {
                DispatchQueue.main.async() {
                    self.campaignView.campaignErrorHandler()
                }
            }
            
        }, failure:{() -> Void in
            DispatchQueue.main.async() {
                self.campaignView.campaignErrorHandler()
            }
        })
    }
}
