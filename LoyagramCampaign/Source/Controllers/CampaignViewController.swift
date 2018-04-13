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
    var statusBar: UIView!
    var campaignId: String!
    var campaignView: LoyagramCampaignView!
    var colorPrimary: UIColor!
    var onSuccess: (() -> Void)?
    var onError: (() -> Void)?
    var statusBarTop: NSLayoutConstraint!
    var campaignViewTop: NSLayoutConstraint!
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
        campaignView = LoyagramCampaignView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), color:colorPrimary)
        campaignView.setCampaignType(type: 0)
        self.mainView.addSubview(campaignView)
        
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        
        statusBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        statusBar.translatesAutoresizingMaskIntoConstraints = false
        
        //
        mainView.addSubview(statusBar)
        campaignView.setViewController(vc: self, statusBar: statusBar)
        //statusbar constrinats
        let statusBarTrailing  = NSLayoutConstraint(item: statusBar, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let statusBarLeading  = NSLayoutConstraint(item: statusBar, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let statusBarHeight  = NSLayoutConstraint(item: statusBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        statusBarTop = NSLayoutConstraint(item: statusBar, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([statusBarTrailing,statusBarLeading,statusBarHeight, statusBarTop])
        if(colorPrimary != nil) {
            statusBar.backgroundColor = colorPrimary
        } else {
            statusBar.backgroundColor = UIColor.white
        }
        
        //Campaign View Constrinats
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        campaignViewTop  = NSLayoutConstraint(item: campaignView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
        
        getCampaignFromServer(campaignId: campaignId)
        
        campaignView.onError = self.onError
        campaignView.onSuccess = self.onSuccess
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
                    self.campaignView.campaignErrorHandler(error: "Something unexpected happened, please try again after sometime!!!")
                }
            }
            
        }, failure:{(error:String) -> Void in
            DispatchQueue.main.async() {
                self.campaignView.campaignErrorHandler(error: error)
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
    
    override func viewDidLayoutSubviews() {
        
        if(statusBarTop == nil || campaignViewTop == nil) {
            return
        }
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let deviceType = UIDevice.current.userInterfaceIdiom
        var isIpad = false
        if(deviceType == .pad) {
           isIpad = true
        }
        if(screenHeight > screenWidth || isIpad) {
            statusBarTop.constant = 0
            campaignViewTop.constant = 20
        } else {
            statusBarTop.constant = -20
            campaignViewTop.constant = 0
        }
        
    }
}
