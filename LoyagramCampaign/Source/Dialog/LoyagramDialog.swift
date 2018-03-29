//
//  LoyagramDialog.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 16/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//


class LoyagramDialog: UIView {
    
    var backgroundView: UIView!
    var campaignView: LoyagramCampaignView!
    var dialogTop: NSLayoutConstraint?
    var dialogBottom: NSLayoutConstraint?
    
    init(frame: CGRect, viewController: UIViewController, campaignId: String, colorPrimary:UIColor) {
        super.init(frame: frame)
        initDialogView(viewController:viewController, colorPrimary: colorPrimary, campaignId: campaignId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initDialogView(viewController: UIViewController, colorPrimary: UIColor, campaignId: String) {
        //backgroundView.frame = frame
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.5
        addSubview(backgroundView)
        
        campaignView = LoyagramCampaignView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), color:colorPrimary)
        campaignView.setCampaignType(type: 1)
        campaignView.setDialogView(view:self)
        campaignView.setSecondaryViewController(vc: viewController)
        addSubview(campaignView)
        
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // background View constraints
        let bgTrailing  = NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let bgLeading  = NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let bgTop  = NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let bgBottom  = NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([bgTrailing,bgLeading,bgTop,bgBottom])
        
        
        //Campaign View constraints
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)

        let campaignCenterX  = NSLayoutConstraint(item: campaignView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)

        let campaignCenterY  = NSLayoutConstraint(item: campaignView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)


        dialogBottom = NSLayoutConstraint(item: campaignView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        dialogTop =  NSLayoutConstraint(item: campaignView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        dialogTop?.priority = UILayoutPriority(rawValue: 999)
        dialogBottom?.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignCenterX,campaignCenterY, dialogBottom!, dialogTop!])
        
        getCampaignFromServer(campaignId: campaignId)
    }
    
    override func layoutSubviews() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //portrait
        if(screenHeight > screenWidth) {
            dialogTop?.constant = 100.0
            dialogBottom?.constant = -100.0
        //landscape
        } else if(screenHeight > 375){
            let constant = (screenHeight - 375)/4
            dialogTop?.constant = constant
            dialogBottom?.constant = -constant
        } else {
            dialogTop?.constant = 0.0
            dialogBottom?.constant = 0.0
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
                    self.campaignView.campaignErrorHandler(error: "Something unexpected happened, please try again after sometime!!!")
                }
            }
            
        }, failure:{(error:String) -> Void in
            DispatchQueue.main.async() {
                self.campaignView.campaignErrorHandler(error: error)
            }
        })
    }
}
