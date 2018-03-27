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
    
    @objc public class func showAsViewController(viewController:UIViewController, campaignId: String, colorPrimary: UIColor = UIColor.clear) {
        let CVC:CampaignViewController = CampaignViewController()
        CVC.modalPresentationStyle = .fullScreen
        CVC.campaignId = campaignId
        CVC.colorPrimary = colorPrimary
        viewController.present(CVC,animated: true, completion: nil)
        
    }
    
    @objc public class func showAsViewController(viewController:UIViewController, campaignId: String, colorPrimary:UIColor = UIColor.clear, onSucces:@escaping (() -> Void), onError:@escaping (() -> Void)) {
        let CVC:CampaignViewController = CampaignViewController()
        CVC.modalPresentationStyle = .fullScreen
        CVC.campaignId = campaignId
        CVC.colorPrimary = colorPrimary
        CVC.onSuccess = onSucces
        viewController.present(CVC,animated: true, completion: nil)
    }
    
    @objc public class func showAsDialog(viewController:UIViewController, campaignView: UIView, campaignId: String, colorPrimary:UIColor = UIColor.clear) {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let dialog:LoyagramDialog = LoyagramDialog(frame: frame, viewController:viewController, campaignId: campaignId, colorPrimary: colorPrimary)
        campaignView.addSubview(dialog)
        
        dialog.translatesAutoresizingMaskIntoConstraints = false
        //Dialog view constraints
        
        let campaignViewTrailing  = NSLayoutConstraint(item: dialog, attribute: .trailing, relatedBy: .equal, toItem: campaignView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: dialog, attribute: .leading, relatedBy: .equal, toItem: campaignView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: dialog, attribute: .top, relatedBy: .equal, toItem: campaignView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: dialog, attribute: .bottom, relatedBy: .equal, toItem: campaignView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
    }
    
    
    @objc public class func showFromBottom(viewController: UIViewController, campaignView: UIView, campaignId: String, colorPrimary:UIColor = UIColor.clear) {
        
        let loyagramCampaignView = LoyagramCampaignView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), color: colorPrimary)
        
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        campaignView.layer.add(transition, forKey: nil)
        loyagramCampaignView.translatesAutoresizingMaskIntoConstraints = false
        campaignView.addSubview(loyagramCampaignView)
        loyagramCampaignView.setDialogView(view: campaignView)
        loyagramCampaignView.setCampaignType(type: 2)
        
        //Constrinats for campaignView
        
        let campaignViewBottom  = NSLayoutConstraint(item: loyagramCampaignView, attribute: .bottom, relatedBy: .equal, toItem: campaignView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let campaignViewTrailing  = NSLayoutConstraint(item: loyagramCampaignView, attribute: .trailing, relatedBy: .equal, toItem: campaignView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: loyagramCampaignView, attribute: .leading, relatedBy: .equal, toItem: campaignView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let campaignViewHeight = NSLayoutConstraint(item: loyagramCampaignView, attribute: .height, relatedBy: .equal, toItem: campaignView, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        campaignViewHeight.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewBottom,campaignViewHeight])
        
        requestCampaignFromServer(campaignId: campaignId, completion: { (campaign) -> Void in
            let questionCount: Int = campaign.questions?.count ?? 0
            if questionCount > 0 {
                DispatchQueue.main.async() {
                    loyagramCampaignView.setCampaign(campaign: campaign)
                }
            } else {
                DispatchQueue.main.async() {
                   loyagramCampaignView.campaignErrorHandler(error: "Something unexpected happened, please try again after sometime!!!")
                }
            }
            
        }, failure:{(error:String) -> Void in
            DispatchQueue.main.async() {
                loyagramCampaignView.campaignErrorHandler(error: error)
            }
        })
    }
    
    class func requestCampaignFromServer(campaignId: String, completion: @escaping ((_ campaign:Campaign) -> Void), failure: @escaping (_ error:String) -> Void ) {
        RequestQuestion.requestQuestion(campaignId: campaignId, completion: { (campaign) -> Void in
            completion(campaign)
        }, failure: {(error:String) -> Void in
            failure(error)
        })
    }
    
    @objc public class func addAttributes(attributes:[String:String]) {
        LoyagramAttribute.getInstance().setAttributes(attributes: attributes)
    }
    
    @objc public class func addAttribute(key:String, value:String) {
        LoyagramAttribute.getInstance().setAttribute(key: key, value: value)
    }
}
