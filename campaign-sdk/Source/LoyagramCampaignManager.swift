//
//  LoyagramCampaignManager.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 12/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

public class LoyagramCampaignManager {
    var onHideComplete: (() -> Void)?
    
    @objc public class func showAsViewController(VC:UIViewController, campaignId: String, colorPrimary: UIColor = UIColor.clear) {
        let CVC:CampaignViewController = CampaignViewController()
        CVC.modalPresentationStyle = .fullScreen
        CVC.campaignId = campaignId
        CVC.colorPrimary = colorPrimary
        VC.present(CVC,animated: true, completion: nil)
        
    }
    
    @objc public class func showAsViewController(VC:UIViewController, campaignId: String, colorPrimary:UIColor = UIColor.clear, onSucces:@escaping (() -> Void), onError:@escaping (() -> Void)) {
        let CVC:CampaignViewController = CampaignViewController()
        CVC.modalPresentationStyle = .fullScreen
        CVC.campaignId = campaignId
        CVC.colorPrimary = colorPrimary
        CVC.onSuccess = onSucces
        VC.present(CVC,animated: true, completion: nil)
    }
    
    @objc public class func showAsDialog(VC:UIViewController, campaignId: String, colorPrimary:UIColor) {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let dialog:LoyagramDialog = LoyagramDialog(frame: frame, campaignId: campaignId, colorPrimary: colorPrimary)
        VC.view.addSubview(dialog)
    }
    
    class func requestCampaignFromServer(campaignId: String, completion: @escaping ((_ campaign:Campaign) -> Void), failure: @escaping () -> Void ) {
        RequestQuestion.requestQuestion(campaignId: campaignId, completion: { (campaign) -> Void in
            completion(campaign)
        }, failure: {() -> Void in
            failure()
        })
    }
    
    @objc public class func addAttributes(attributes:[String:String]) {
        LoyagramAttribute.getInstance().setAttributes(attributes: attributes)
    }
    
    @objc public class func addAttribute(key:String, value:String) {
        LoyagramAttribute.getInstance().setAttribute(key: key, value: value)
    }
}
