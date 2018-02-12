//
//  LoyagramCampaignView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 09/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

public class LoyagramCampaignView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var headerView: UIView!
    var contentView: UIView!
    var footerView: UIView!
    var lblPoweredBy : UILabel!
    var imageViewBrand : UIImageView!
    var lblBrand : UILabel!
    var brandView : UIView!
    var btnClose : UIButton!
    var lblQuestionCount : UILabel!
    var btnLanguage: UIButton!
    var viewController : UIViewController!
    var tableViewLanguage : UITableView!
    var languages:Array = ["English", "Spanish", "Portugeese"]
    
    override public init(frame: CGRect){
        super.init(frame: frame)
        initHeaderView()
        initFooterView()
        initContentView()
        initTableView()
        
        let bundle = Bundle(for: type(of: self))
        btnClose.setImage(UIImage(named: "close.png", in: bundle, compatibleWith: nil), for:.normal)
        imageViewBrand.image = UIImage(named: "apple.png", in: bundle, compatibleWith: nil)
        tableViewLanguage.register(UITableViewCell.self, forCellReuseIdentifier: "languageCell")
        tableViewLanguage.delegate = self
        tableViewLanguage.dataSource = self
        //headerView.clipsToBounds = false
//        tableViewLanguage.clipsToBounds = false
//        headerView.layer.masksToBounds = false
//        tableViewLanguage.layer.masksToBounds = false
        tableViewLanguage.tableFooterView = UIView()
        tableViewLanguage.layer.zPosition = 1
        //contentView.layer.zPosition = 0
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func setViewController(vc:UIViewController!) {
        self.viewController = vc
    }
    
    @objc func initHeaderView () {
        headerView = UIView()
        brandView = UIView()
        imageViewBrand = UIImageView()
        lblBrand = UILabel()
        btnClose = UIButton()
        lblQuestionCount = UILabel()
        btnLanguage = UIButton()
        imageViewBrand.contentMode = .scaleAspectFit;
        //imageViewBrand.frame = rect
        
        lblBrand.textColor = UIColor.white
        lblBrand.textAlignment = .center
        brandView.addSubview(imageViewBrand)
        brandView.addSubview(lblBrand)
        
        
        headerView.addSubview(btnClose)
        headerView.addSubview(brandView)
        headerView.addSubview(btnLanguage)
        headerView.addSubview(lblQuestionCount)
        self.addSubview(headerView)
        
        let color: UIColor = UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        headerView.backgroundColor = color
        headerView.translatesAutoresizingMaskIntoConstraints = false
        brandView.translatesAutoresizingMaskIntoConstraints = false
        lblBrand.translatesAutoresizingMaskIntoConstraints = false
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        imageViewBrand.translatesAutoresizingMaskIntoConstraints = false
        btnLanguage.translatesAutoresizingMaskIntoConstraints = false
        lblQuestionCount.translatesAutoresizingMaskIntoConstraints = false
        btnLanguage.setTitleColor(UIColor.white, for: .normal)
        btnLanguage.setTitleColor(UIColor.white, for: .normal)
        lblQuestionCount.textColor = UIColor.white
        
        //Hardcoded texts
        
        lblBrand.text = "Loyagram"
        lblQuestionCount.text = "1/5"
        btnLanguage.setTitle("English", for: .normal)
        
        btnClose.addTarget(self, action: #selector(closeButtonAction(sender:)), for: .touchUpInside)
        btnLanguage.addTarget(self, action: #selector(languageButtonAction(sender:)), for: .touchUpInside)
        // Constriants to headerView
        
        //Leading
        let headerLeading  = NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let headerTrailing  = NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let headerTop = NSLayoutConstraint(item: headerView,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 0.0)
        //Height
        let headerHeight = NSLayoutConstraint(item: headerView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 200.0)
        
        NSLayoutConstraint.activate([headerLeading, headerTrailing, headerTop, headerHeight])
        
        
        //Constraints for question label
        
        //Height
        let lblQuestionCountHeight = NSLayoutConstraint(item: lblQuestionCount,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 30.0)
        
        //Width
        let lblQuestionCountWidth = NSLayoutConstraint(item: lblQuestionCount,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: 30.0)
        
        let lblQuestionCountBottom = NSLayoutConstraint(item: lblQuestionCount,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: headerView,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: -10.0)
        
        let lblQuestionCountTrailing = NSLayoutConstraint(item: lblQuestionCount,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: headerView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: -15.0)
        
        NSLayoutConstraint.activate([lblQuestionCountHeight, lblQuestionCountWidth, lblQuestionCountBottom, lblQuestionCountTrailing])
        
        
        //Constraints for language label
        
        //Height
        let btnLanguageHeight = NSLayoutConstraint(item: btnLanguage,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: 30.0)
        
        //Width
        let btnLanguageWidth = NSLayoutConstraint(item: btnLanguage,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1.0,
                                                       constant: 60.0)
        
        let btnLanguageBottom = NSLayoutConstraint(item: btnLanguage,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: headerView,
                                                        attribute: .bottom,
                                                        multiplier: 1.0,
                                                        constant: -10.0)
        
        let btnLanguageLeading = NSLayoutConstraint(item: btnLanguage,
                                                          attribute: .leading,
                                                          relatedBy: .equal,
                                                          toItem: headerView,
                                                          attribute: .leading,
                                                          multiplier: 1.0,
                                                          constant: 15.0)
        
        NSLayoutConstraint.activate([btnLanguageHeight, btnLanguageWidth, btnLanguageBottom, btnLanguageLeading])
        
        
        
        //Close Button Constraints
        
        //Height
        let closeButtonHeight = NSLayoutConstraint(item: btnClose,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: 20.0)
        
        //Height
        let closeButtonWidth = NSLayoutConstraint(item: btnClose,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 20.0)
        
        let closeButtonTop = NSLayoutConstraint(item: btnClose,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: headerView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 30.0)
        
        let closeButtonTrailing = NSLayoutConstraint(item: btnClose,
                                               attribute: .trailing,
                                               relatedBy: .equal,
                                               toItem: headerView,
                                               attribute: .trailing,
                                               multiplier: 1.0,
                                               constant: -15.0)
        
        NSLayoutConstraint.activate([closeButtonWidth, closeButtonHeight, closeButtonTop, closeButtonTrailing])
        
        
        //BrandView Constraints
        let brandCenterHorizontally = NSLayoutConstraint(item: brandView,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: headerView,
                                                    attribute: .centerX,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        let brandTop = NSLayoutConstraint(item: brandView,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: headerView,
                                                  attribute: .top,
                                                  multiplier: 1.0,
                                                  constant: 40.0)
        //Height
        let brandHeight = NSLayoutConstraint(item: brandView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 130.0)
        
        //Height
        let brandWidth = NSLayoutConstraint(item: brandView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: 120.0)
        
        NSLayoutConstraint.activate([brandCenterHorizontally, brandTop, brandWidth, brandHeight])
        
        
        //Brand Image Constraints
        
        let imgBrandCenterHorizontally = NSLayoutConstraint(item: imageViewBrand,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: brandView,
                                                            attribute: .centerX,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
        
        let imgBrandTop =  NSLayoutConstraint(item: imageViewBrand,
                                                 attribute: .top,
                                                 relatedBy: .equal,
                                                 toItem: brandView,
                                                 attribute: .top,
                                                 multiplier: 1.0,
                                                 constant: -25.0)
        
        
        let imgBrandWidth = NSLayoutConstraint(item: imageViewBrand,
                                               attribute: .width,
                                               relatedBy: .equal,
                                               toItem: nil,
                                               attribute: .notAnAttribute,
                                               multiplier: 1.0,
                                               constant: 100.0)
        
        NSLayoutConstraint.activate([imgBrandCenterHorizontally, imgBrandTop, imgBrandWidth])
        
        
        //Brand Label Constraints
        
        let lblBrandHeight = NSLayoutConstraint(item: lblBrand,
                                          attribute: .height,
                                          relatedBy: .equal,
                                          toItem: nil,
                                          attribute: .notAnAttribute,
                                          multiplier: 1.0,
                                          constant: 30.0)
        
        let lblBrandWidth = NSLayoutConstraint(item: lblBrand,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: nil,
                                           attribute: .notAnAttribute,
                                           multiplier: 1.0,
                                           constant: 100.0)
        
        
        let lblBrandCenterHorizontally = NSLayoutConstraint(item: lblBrand,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: brandView,
                                                    attribute: .centerX,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        let lblBrandBottom =  NSLayoutConstraint(item: lblBrand,
                                          attribute: .bottom,
                                          relatedBy: .equal,
                                          toItem: brandView,
                                          attribute: .bottom,
                                          multiplier: 1.0,
                                          constant: 0.0)
        
        NSLayoutConstraint.activate([lblBrandWidth, lblBrandHeight, lblBrandCenterHorizontally, lblBrandBottom])
    
    }
    
    // MARK: UI Initialization
    @objc func initTableView() {
        
        tableViewLanguage = UITableView()
        tableViewLanguage.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(tableViewLanguage)
        //tableViewLanguage.layer.zPosition = 1;
        tableViewLanguage.isHidden = true
        tableViewLanguage.superview?.bringSubview(toFront: tableViewLanguage)
        
        //Table view cosntraints
        let tableViewLangHeight = NSLayoutConstraint(item: tableViewLanguage,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1.0,
                                                constant: 150.0)
        
        let tableViewLangWidth = NSLayoutConstraint(item: tableViewLanguage,
                                               attribute: .width,
                                               relatedBy: .equal,
                                               toItem: nil,
                                               attribute: .notAnAttribute,
                                               multiplier: 1.0,
                                               constant: 110.0)
    
        
        let tableViewLangTop =  NSLayoutConstraint(item: tableViewLanguage,
                                                 attribute: .top,
                                                 relatedBy: .equal,
                                                 toItem: btnLanguage,
                                                 attribute: .bottom,
                                                 multiplier: 1.0,
                                                 constant: 0.0)
        
        let tableViewLangLeading = NSLayoutConstraint(item: tableViewLanguage,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: headerView,
                                                    attribute: .leading,
                                                    multiplier: 1.0,
                                                    constant: 15.0)
  
        NSLayoutConstraint.activate([tableViewLangHeight, tableViewLangWidth, tableViewLangTop, tableViewLangLeading])
        
        
    }
    
    @objc func initContentView() {
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        
        //Content View constraints
        
        //Leading
        let contentLeading  = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let contentTrailing  = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let contentBottom = NSLayoutConstraint(item: contentView,
                                               attribute: .bottom,
                                               relatedBy: .equal,
                                               toItem: footerView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 0.0)
        //Top
        let contentTop = NSLayoutConstraint(item: contentView,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: headerView,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 0.0)
        
        NSLayoutConstraint.activate([contentLeading, contentTrailing, contentBottom, contentTop])
    
    }
    
    @objc func initFooterView() {
        
        footerView = UIView()
        let color: UIColor = UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        footerView.backgroundColor = color
        self.addSubview(footerView)
        lblPoweredBy = UILabel()
        lblPoweredBy.text = "Powered by Loyagram"
        lblPoweredBy.textColor = UIColor.white
        footerView.addSubview(lblPoweredBy)
        lblPoweredBy.translatesAutoresizingMaskIntoConstraints = false;
        //Layout Constraints
        
        let lblPoweredByCenterHorizontally = NSLayoutConstraint(item: lblPoweredBy,
                                                             attribute: .centerX,
                                                             relatedBy: .equal,
                                                             toItem: footerView,
                                                             attribute: .centerX,
                                                             multiplier: 1.0,
                                                             constant: 0.0)
        
        let blPoweredByCenterVertically = NSLayoutConstraint(item: lblPoweredBy,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: footerView,
                                                    attribute: .centerY,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        NSLayoutConstraint.activate([lblPoweredByCenterHorizontally, blPoweredByCenterVertically])
        //Leading
        footerView.translatesAutoresizingMaskIntoConstraints = false;
        let footerLeading  = NSLayoutConstraint(item: footerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let footerTrailing  = NSLayoutConstraint(item: footerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let footerBottom = NSLayoutConstraint(item: footerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0.0)
        //Height
        let footerHeight = NSLayoutConstraint(item: footerView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 30.0)
        
        NSLayoutConstraint.activate([footerLeading, footerTrailing, footerBottom, footerHeight])
    }
    
    @objc func closeButtonAction(sender:UIButton!) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func languageButtonAction(sender:UIButton!) {
        
        tableViewLanguage.isHidden = !tableViewLanguage.isHidden
        //self.bringSubview(toFront: tableViewLanguage)
        self.sendSubview(toBack: contentView)
    }
    
    // MARK:-
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return languages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LanguageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "LanguageCell")
        //cell.textLabel!.text = "\(languages[indexPath.row])"
        cell.lblLanguage.text = languages[indexPath.row]
        return cell
    }
    
}
