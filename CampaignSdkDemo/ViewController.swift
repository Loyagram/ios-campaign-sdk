//
//  ViewController.swift
//  CampaignSdkDemo
//
//  Created by iOS-Apps on 07/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit
import campaign_sdk

class ViewController: UIViewController {
    
    var radioGroupView: UIView!
    @IBOutlet var mainView: UIView!
    var rdbGroup: [LGRadioButton]!
    
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
    }
    
    @objc func initRadioButtonView() {
        let rdbNPS = LGRadioButton(frame: CGRect(x: 0, y: 10, width: 20, height: 30))
        rdbNPS.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbNPS.tag = 101
        let lblNPS = UILabel(frame: CGRect(x:25, y:10, width:40, height:30))
        lblNPS.text = "NPS"
        
        let rdbSurvey = LGRadioButton(frame: CGRect(x: 70, y: 10, width: 20, height: 30))
        rdbSurvey.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbNPS.tag = 102
        let lblSurvey = UILabel(frame: CGRect(x:95, y:10, width:60, height:30))
        lblSurvey.text = "Survey"
        
        let rdbCSAT = LGRadioButton(frame: CGRect(x: 160, y: 10, width: 20, height: 30))
        rdbCSAT.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbNPS.tag = 103
        let lblCSAT = UILabel(frame: CGRect(x:185, y:10, width:50, height:30))
        lblCSAT.text = "CSAT"
        
        let rdbCES = LGRadioButton(frame: CGRect(x: 240, y: 10, width: 20, height: 30))
        rdbCES.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        rdbNPS.tag = 104
        let lblCES = UILabel(frame: CGRect(x:265, y:10, width:40, height:30))
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
        
        //let campainView = LoyagramCampaignView(frame:CGRectMake(0,0,60,100))
        //let rect = CGRect(x: 0, y: 0, width: 300, height: 100)
        //let campaignView = LoyagramCampaignView(frame:rect)
        //mainView.addSubview(campaignView)
        LoyagramCampaignManager.showAsViewController(VC:self)
    }
    
    @objc func dialogButtonAction(sender:UIButton!) {
        
        //let campainView = LoyagramCampaignView(frame:CGRectMake(0,0,60,100))
        //let rect = CGRect(x: 0, y: 0, width: 300, height: 100)
        //let campaignView = LoyagramCampaignView(frame:rect)
        //mainView.addSubview(campaignView)
        LoyagramCampaignManager.showAsViewController(VC:self)
    }
    @objc func slideButtonAction(sender:UIButton!) {
        
        //let campainView = LoyagramCampaignView(frame:CGRectMake(0,0,60,100))
        //let rect = CGRect(x: 0, y: 0, width: 300, height: 100)
        //let campaignView = LoyagramCampaignView(frame:rect)
        //mainView.addSubview(campaignView)
        LoyagramCampaignManager.showAsViewController(VC:self)
    }
    
    @objc func previewButtonAction(sender:UIButton!) {
        
        //let campainView = LoyagramCampaignView(frame:CGRectMake(0,0,60,100))
        //let rect = CGRect(x: 0, y: 0, width: 300, height: 100)
        //let campaignView = LoyagramCampaignView(frame:rect)
        //mainView.addSubview(campaignView)
        LoyagramCampaignManager.showAsViewController(VC:self)
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
        
        let btnPreview = UIButton(type: .system)
        btnPreview.setTitle("PREVIEW", for: .normal)
        btnPreview.layer.cornerRadius = 2
        btnPreview.layer.borderWidth = 2
        btnPreview.layer.borderColor = color.cgColor
        btnPreview.setTitleColor(color, for: .normal)
        
        btnPreview.addTarget(self, action: #selector(previewButtonAction(sender:)), for: .touchUpInside)
        
        radioGroupView.addSubview(btnVC)
        radioGroupView.addSubview(btnDialog)
        radioGroupView.addSubview(btnSlideBottom)
        radioGroupView.addSubview(btnPreview)
        
        //Constraints for first show from controller botton
        btnVC.translatesAutoresizingMaskIntoConstraints = false;
        btnDialog.translatesAutoresizingMaskIntoConstraints = false;
        btnSlideBottom.translatesAutoresizingMaskIntoConstraints = false;
        btnPreview.translatesAutoresizingMaskIntoConstraints = false;
        
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
        let btnPreviewTop = NSLayoutConstraint(item: btnPreview,
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
        
    }

}

