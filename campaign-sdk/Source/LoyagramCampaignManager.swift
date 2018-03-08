//
//  LoyagramCampaignManager.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 12/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

public class LoyagramCampaignManager {
    
    @objc public class func showAsViewController(VC:UIViewController, campaignId: String) {
        let CVC:CampaignViewController = CampaignViewController()
        CVC.modalPresentationStyle = .fullScreen
        CVC.campaignId = campaignId
        VC.present(CVC,animated: true, completion: nil)
    }
    
    class func requestCampaignFromServer(campaignId: String, completion: @escaping ((_ campaign:Campaign) -> Void), failure: @escaping () -> Void ) {
        RequestQuestion.requestQuestion(campaignId: campaignId, completion: { (campaign) -> Void in
            completion(campaign)
        }, failure: {() -> Void in
            failure()
        })
    }
}
