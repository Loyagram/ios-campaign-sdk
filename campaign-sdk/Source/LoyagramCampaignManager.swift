//
//  LoyagramCampaignManager.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 12/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

public class LoyagramCampaignManager {
    
    @objc public class func showAsViewController(VC:UIViewController) {
        let CVC:CampaignViewController = CampaignViewController()
        CVC.modalPresentationStyle = .fullScreen
        VC.present(CVC,animated: true, completion: nil)
    }
}
