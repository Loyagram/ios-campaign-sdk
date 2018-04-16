//
//  ViewController.swift
//  CampaignSdkDemo
//
//  Created by iOS-Apps on 07/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import LoyagramCampaign

class ViewController: UIViewController {
    
    var radioGroupView: UIView!
    @IBOutlet var mainView: UIView!
    var rdbGroup: [LGRadioButton]!
    //var campaignId = "1020-f6c94dd5-d8c2-4f2d-9c8c-88d7237a8812"
    var campaignId = "1020-49bd1a50-1c51-445d-8043-fa8f907a0078"
    let colorPrimary = UIColor(red: 26.0/255.0, green: 55.0/255.0, blue: 156.0/255.0, alpha: 1.0)
    var campaignView: UIView!
    var campaignViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        radioGroupView = UIView()
        //radioGroupView.backgroundColor = UIColor.red
        radioGroupView.translatesAutoresizingMaskIntoConstraints = false;
        mainView.addSubview(radioGroupView)
        setRdbLayoutConstaints()
        
        initRadioButtonView()
        initButtonView()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func setRdbLayoutConstaints() {
        
        //Leading
        let leadingConstraint  = NSLayoutConstraint(item: radioGroupView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 5)
        
        //Trailing
        let trailingConstraint  = NSLayoutConstraint(item: radioGroupView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -5)
        
        //top
        let topConstraint = NSLayoutConstraint(item: radioGroupView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self.view,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 40.0)
        //height
        let heightConstraint = NSLayoutConstraint(item: radioGroupView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: 210.0)
        
        //height
        let widthConstraint = NSLayoutConstraint(item: radioGroupView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 300.0)
        
        //centerHorizontal
        let centerHorizontally = NSLayoutConstraint(item: radioGroupView,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .centerX,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint, topConstraint, widthConstraint, heightConstraint, centerHorizontally])
        
    }
    @objc func manualAction (sender: LGRadioButton) {
        
        rdbGroup.forEach { $0.isSelected = false}
        sender.isSelected = !sender.isSelected
        switch(sender.tag) {
        case 101:
            //campaignId = "1020-f6c94dd5-d8c2-4f2d-9c8c-88d7237a8812"
            campaignId = "1020-49bd1a50-1c51-445d-8043-fa8f907a0078"
            break
        case 102:
            //campaignId = "1020-3ded49df-965b-436c-b3cb-3ca43fb86d3d"
            campaignId = "1020-80c64203-5484-4a52-b41d-5ef485cc80f1"
            break
        case 103:
            campaignId = "1020-2d06b020-aeb6-472b-8321-556f3d4ec510"
            break
        case 104:
            campaignId = "1020-193be5eb-870d-4d27-971a-268cff4add88"
            break
        default: break
        }
    }
    
    @objc func initRadioButtonView() {
        let rdbNPS = LGRadioButton(frame: CGRect(x: 0, y: 10, width: 25, height: 30))
        rdbNPS.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbNPS.tag = 101
        let lblNPS = UILabel(frame: CGRect(x:30, y:10, width:40, height:30))
        lblNPS.text = "NPS"
        rdbNPS.isSelected = true
        
        let rdbSurvey = LGRadioButton(frame: CGRect(x: 70, y: 10, width: 25, height: 30))
        rdbSurvey.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbSurvey.tag = 102
        let lblSurvey = UILabel(frame: CGRect(x:100, y:10, width:60, height:30))
        lblSurvey.text = "Survey"
        
        let rdbCSAT = LGRadioButton(frame: CGRect(x: 160, y: 10, width: 25, height: 30))
        rdbCSAT.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbCSAT.tag = 103
        let lblCSAT = UILabel(frame: CGRect(x:190, y:10, width:50, height:30))
        lblCSAT.text = "CSAT"
        
        let rdbCES = LGRadioButton(frame: CGRect(x: 240, y: 10, width: 25, height: 30))
        rdbCES.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbCES.tag = 104
        let lblCES = UILabel(frame: CGRect(x:270, y:10, width:40, height:30))
        lblCES.text = "CES"
        rdbGroup = [rdbNPS,rdbSurvey, rdbCSAT, rdbCES]
        
        radioGroupView.addSubview(rdbNPS)
        radioGroupView.addSubview(lblNPS)
        radioGroupView.addSubview(rdbSurvey)
        radioGroupView.addSubview(lblSurvey)
        radioGroupView.addSubview(rdbCSAT)
        radioGroupView.addSubview(lblCSAT)
        radioGroupView.addSubview(rdbCES)
        radioGroupView.addSubview(lblCES)
    }
    
    @objc func controllerButtonAction(sender:UIButton!) {
        
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("----------start time \(minutes) : \(seconds)")
        
        var attributes = [String:String] ()
        attributes["username"] = "sandhil"
        attributes["cusotmerId"] = "1234"
        LoyagramCampaignManager.addAttributes(attributes: attributes)
        LoyagramCampaign.initialize(clientId: "68bc4d8b-705d-4e65-badf-927e1450c131", clientSecret: "d71290e5-be41-4466-84f7-dd9241476c88")
        //LoyagramCampaignManager.showAsViewController(VC:self, campaignId: campaignId, colorPrimary: colorPrimary)
        LoyagramCampaignManager.showAsViewController(viewController: self, campaignId: campaignId)
       
        /* LoyagramCampaignManager.showAsViewController(viewController: self, campaignId: campaignId, colorPrimary: colorPrimary, onSucces: {
            () -> Void in
            print("campaign success")
        }, onError:{ () -> Void in
            print("campaign error")
        }) */
    }
    
    @objc func dialogButtonAction(sender:UIButton!) {
        
        LoyagramCampaignManager.showAsDialog(viewController: self, campaignView: mainView, campaignId: campaignId, colorPrimary: colorPrimary)
    }
    @objc func slideButtonAction(sender:UIButton!) {
        
        initBottomCampaignView()
        LoyagramCampaignManager.showFromBottom(viewController: self, campaignView: campaignView, campaignId: campaignId, colorPrimary: colorPrimary)
    }
    
    @objc func previewButtonAction(sender:UIButton!) {
    }
    
    @objc func initButtonView() {
        let btnVC = UIButton(type: .system)
        let color: UIColor = UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        btnVC.setTitle("SHOW IN VIEW CONTROLLER", for: .normal)
        btnVC.layer.cornerRadius = 5
        btnVC.layer.borderWidth = 2
        btnVC.layer.borderColor = color.cgColor
        btnVC.setTitleColor(color, for: .normal)
        
        btnVC.addTarget(self, action: #selector(controllerButtonAction(sender:)), for: .touchUpInside)
        
        let btnDialog = UIButton(type: .system)
        btnDialog.setTitle("SHOW AS DIALOG", for: .normal)
        btnDialog.layer.cornerRadius = 2
        btnDialog.layer.borderWidth = 2
        btnDialog.layer.borderColor = color.cgColor
        btnDialog.setTitleColor(color, for: .normal)
        
        btnDialog.addTarget(self, action: #selector(dialogButtonAction(sender:)), for: .touchUpInside)
        
        let btnSlideBottom = UIButton(type: .system)
        btnSlideBottom.setTitle("SLIDE FROM BOTTOM", for: .normal)
        btnSlideBottom.layer.cornerRadius = 2
        btnSlideBottom.layer.borderWidth = 2
        btnSlideBottom.layer.borderColor = color.cgColor
        btnSlideBottom.setTitleColor(color, for: .normal)
        
        btnSlideBottom.addTarget(self, action: #selector(slideButtonAction(sender:)), for: .touchUpInside)
    
        
        radioGroupView.addSubview(btnVC)
        radioGroupView.addSubview(btnDialog)
        radioGroupView.addSubview(btnSlideBottom)
        //radioGroupView.addSubview(btnPreview)
        
        //Constraints for first show from controller botton
        btnVC.translatesAutoresizingMaskIntoConstraints = false;
        btnDialog.translatesAutoresizingMaskIntoConstraints = false;
        btnSlideBottom.translatesAutoresizingMaskIntoConstraints = false;
        //btnPreview.translatesAutoresizingMaskIntoConstraints = false;
        
        //top
        let btnVCTop = NSLayoutConstraint(item: btnVC,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: radioGroupView,
                                          attribute: .top,
                                          multiplier: 1.0,
                                          constant: 60.0)
        //height
        let btnVCHeight = NSLayoutConstraint(item: btnVC,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: 30.0)
        
        //height
        let btnVCwidth = NSLayoutConstraint(item: btnVC,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 270.0)
        
        //centerHorizontal
        let btnVCCenterHorizontally = NSLayoutConstraint(item: btnVC,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: radioGroupView,
                                                         attribute: .centerX,
                                                         multiplier: 1.0,
                                                         constant: 0.0)
        
        NSLayoutConstraint.activate([btnVCTop, btnVCHeight, btnVCwidth, btnVCCenterHorizontally])
        
        //top
        let btnDialogTop = NSLayoutConstraint(item: btnDialog,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: radioGroupView,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 100.0)
        //height
        let btnDialogHeight = NSLayoutConstraint(item: btnDialog,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 30.0)
        
        //Weight
        let btnDialogWidth = NSLayoutConstraint(item: btnDialog,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1.0,
                                                constant: 270.0)
        
        //centerHorizontal
        let btnDialogCenterHorizontally = NSLayoutConstraint(item: btnDialog,
                                                             attribute: .centerX,
                                                             relatedBy: .equal,
                                                             toItem: radioGroupView,
                                                             attribute: .centerX,
                                                             multiplier: 1.0,
                                                             constant: 0.0)
        
        NSLayoutConstraint.activate([btnDialogTop, btnDialogHeight, btnDialogWidth, btnDialogCenterHorizontally])
        
        //top
        let btnSlideBottomTop = NSLayoutConstraint(item: btnSlideBottom,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: radioGroupView,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: 140.0)
        //height
        let btnSlideBottomHeight = NSLayoutConstraint(item: btnSlideBottom,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1.0,
                                                      constant: 30.0)
        
        //weight
        let btnSlideBottomWidth = NSLayoutConstraint(item: btnSlideBottom,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: 270.0)
        
        //centerHorizontal
        let btnSlideBottomCenterHorizontally = NSLayoutConstraint(item: btnSlideBottom,
                                                                  attribute: .centerX,
                                                                  relatedBy: .equal,
                                                                  toItem: radioGroupView,
                                                                  attribute: .centerX,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
        
        NSLayoutConstraint.activate([btnSlideBottomTop, btnSlideBottomHeight, btnSlideBottomWidth, btnSlideBottomCenterHorizontally])
        
        //top
      /*  let btnPreviewTop = NSLayoutConstraint(item: btnPreview,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: radioGroupView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 180.0)
        //height
        let btnPreviewHeight = NSLayoutConstraint(item: btnPreview,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: 30.0)
        
        //weight
        let btnPreviewWidth = NSLayoutConstraint(item: btnPreview,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 270.0)
        
        //centerHorizontal
        let btnPreviewCenterHorizontally = NSLayoutConstraint(item: btnPreview,
                                                              attribute: .centerX,
                                                              relatedBy: .equal,
                                                              toItem: radioGroupView,
                                                              attribute: .centerX,
                                                              multiplier: 1.0,
                                                              constant: 0.0)
        
        NSLayoutConstraint.activate([btnPreviewTop, btnPreviewHeight, btnPreviewWidth, btnPreviewCenterHorizontally])
 */
        
    }
    
    @objc func initBottomCampaignView() {
        
        campaignView = UIView()
        //campaignView.isHidden = false
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(campaignView)
        NSLayoutConstraint(item: campaignView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: campaignView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: campaignView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        campaignViewHeight = NSLayoutConstraint(item: campaignView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewHeight])
        
        
    }
    override func viewDidLayoutSubviews() {
        
        if(campaignView == nil) {
            return
        }
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //portrait
        if(screenHeight > screenWidth) {
            campaignViewHeight.constant = 400
            //landscape
        } else if(screenHeight > 375){
            if(screenHeight > 575) {
                let constant = (screenHeight - 200)
                campaignViewHeight.constant = constant
            } else {
                campaignViewHeight.constant = 375
            }
        } else {
            campaignViewHeight.constant = screenHeight
        }
    }
    
}

