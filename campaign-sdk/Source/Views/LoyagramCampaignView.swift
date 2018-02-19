//
//  LoyagramCampaignView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 09/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

public class LoyagramCampaignView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var headerView: UIView!
    var contentView: UIView!
    var footerView: UIView!
    var lblPoweredBy : UILabel!
    var imageViewBrand : UIImageView!
    var imageViewArrow : UIImageView!
    var lblBrand : UILabel!
    var brandView : UIView!
    var btnClose : UIButton!
    var lblQuestionCount : UILabel!
    var btnLanguage: UIButton!
    var viewController : UIViewController!
    var tableViewLanguage : UITableView!
    var languages:NSArray = ["English", "Spanish", "Portugeese", "Hindi", "xyz"]
    var primaryColor : UIColor!
    var currentLang : Int!
    var nextPrevButtonView: UIView!
    var btnNext:UIButton!
    var btnPrev: UIButton!
    var campaignView: UIView!
    var campaignFrame: CGRect!
    var campaign: Campaign!
    var currentQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    
    override public init(frame: CGRect){
        super.init(frame: frame)
        
        let abc = "height--VC---- \(frame.height)"
        print(abc)
        primaryColor = UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        initHeaderView()
        initFooterView()
        initContentView()
        initTableView()
        
        let bundle = Bundle(for: type(of: self))
        btnClose.setImage(UIImage(named: "close.png", in: bundle, compatibleWith: nil), for:.normal)
        imageViewBrand.image = UIImage(named: "apple.png", in: bundle, compatibleWith: nil)
        btnLanguage.setImage(UIImage(named: "drop-down-arrow.png", in: bundle, compatibleWith: nil), for: .normal)
        btnLanguage.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
        btnLanguage.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        btnLanguage.semanticContentAttribute = .forceRightToLeft
        btnLanguage.contentHorizontalAlignment = .left
        
        tableViewLanguage.register(UITableViewCell.self, forCellReuseIdentifier: "languageCell")
        tableViewLanguage.delegate = self
        tableViewLanguage.dataSource = self
        tableViewLanguage.tableFooterView = UIView()
        tableViewLanguage.layer.zPosition = 1
        
        currentLang = 0
        
  
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
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
        btnLanguage = UIButton(type: .custom)
        //imageViewArrow = UIImageView()
        imageViewBrand.contentMode = .scaleAspectFit;
        
        lblBrand.textColor = UIColor.white
        lblBrand.textAlignment = .center
        brandView.addSubview(imageViewBrand)
        brandView.addSubview(lblBrand)
        
        
        headerView.addSubview(btnClose)
        headerView.addSubview(brandView)
        headerView.addSubview(btnLanguage)
        //headerView.addSubview(imageViewArrow)
        headerView.addSubview(lblQuestionCount)
        self.addSubview(headerView)
        
        headerView.backgroundColor = primaryColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        brandView.translatesAutoresizingMaskIntoConstraints = false
        lblBrand.translatesAutoresizingMaskIntoConstraints = false
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        imageViewBrand.translatesAutoresizingMaskIntoConstraints = false
        btnLanguage.translatesAutoresizingMaskIntoConstraints = false
        //imageViewArrow.translatesAutoresizingMaskIntoConstraints = false
        lblQuestionCount.translatesAutoresizingMaskIntoConstraints = false
        btnLanguage.setTitleColor(UIColor.white, for: .normal)
        btnLanguage.setTitleColor(UIColor.white, for: .normal)
        lblQuestionCount.textColor = UIColor.white
        
        //Hardcoded texts need to change once api request implemented
        
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
        let headerTop = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self,  attribute: .top, multiplier: 1.0, constant: 0.0)
        //Height
        let headerHeight = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 190.0)
        
        NSLayoutConstraint.activate([headerLeading, headerTrailing, headerTop, headerHeight])
        
        
        //Constraints for question label
        
        //Height
        let lblQuestionCountHeight = NSLayoutConstraint(item: lblQuestionCount, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 30.0)
        
        //Width
        let lblQuestionCountWidth = NSLayoutConstraint(item: lblQuestionCount, attribute: .width,  relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,   multiplier: 1.0, constant: 30.0)
        
        let lblQuestionCountBottom = NSLayoutConstraint(item: lblQuestionCount, attribute: .bottom,  relatedBy: .equal,  toItem: headerView,  attribute: .bottom, multiplier: 1.0, constant: -10.0)
        
        let lblQuestionCountTrailing = NSLayoutConstraint(item: lblQuestionCount, attribute: .trailing,  relatedBy: .equal,  toItem: headerView,  attribute: .trailing,   multiplier: 1.0,  constant: -15.0)
        
        NSLayoutConstraint.activate([lblQuestionCountHeight, lblQuestionCountWidth, lblQuestionCountBottom, lblQuestionCountTrailing])
        
        
        //Constraints for language label
        
        //Height
        let btnLanguageHeight = NSLayoutConstraint(item: btnLanguage, attribute: .height,  relatedBy: .equal,   toItem: nil,  attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        //Width
        let btnLanguageWidth = NSLayoutConstraint(item: btnLanguage,
                                                  attribute: .width, relatedBy: .equal,  toItem: nil,  attribute: .notAnAttribute,  multiplier: 1.0, constant: 100.0)
        
        let btnLanguageBottom = NSLayoutConstraint(item: btnLanguage,
                                                   attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom,  multiplier: 1.0,  constant: -10.0)
        
        let btnLanguageLeading = NSLayoutConstraint(item: btnLanguage,
                                                    attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 15.0)
        
        NSLayoutConstraint.activate([btnLanguageHeight, btnLanguageWidth, btnLanguageBottom, btnLanguageLeading])
        
        
        //Close Button Constraints
        
        //Height
        let closeButtonHeight = NSLayoutConstraint(item: btnClose, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        //Height
        let closeButtonWidth = NSLayoutConstraint(item: btnClose, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,   multiplier: 1.0,  constant: 20.0)
        
        let closeButtonTop = NSLayoutConstraint(item: btnClose, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 30.0)
        
        let closeButtonTrailing = NSLayoutConstraint(item: btnClose, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1.0, constant: -15.0)
        
        NSLayoutConstraint.activate([closeButtonWidth, closeButtonHeight, closeButtonTop, closeButtonTrailing])
        
        
        //BrandView Constraints
        let brandCenterHorizontally = NSLayoutConstraint(item: brandView, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let brandTop = NSLayoutConstraint(item: brandView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 40.0)
        //Height
        let brandHeight = NSLayoutConstraint(item: brandView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120.0)
        
        //Height
        let brandWidth = NSLayoutConstraint(item: brandView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0)
        
        NSLayoutConstraint.activate([brandCenterHorizontally, brandTop, brandWidth, brandHeight])
        
        
        //Brand Image Constraints
        
        let imgBrandCenterHorizontally = NSLayoutConstraint(item: imageViewBrand, attribute: .centerX, relatedBy: .equal, toItem: brandView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let imgBrandTop =  NSLayoutConstraint(item: imageViewBrand, attribute: .top, relatedBy: .equal,  toItem: brandView,  attribute: .top, multiplier: 1.0, constant: -25.0)
        
        
        let imgBrandWidth = NSLayoutConstraint(item: imageViewBrand, attribute: .width, relatedBy: .equal,  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        
        NSLayoutConstraint.activate([imgBrandCenterHorizontally, imgBrandTop, imgBrandWidth])
        
        
        //Brand Label Constraints
        
        let lblBrandHeight = NSLayoutConstraint(item: lblBrand, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        let lblBrandWidth = NSLayoutConstraint(item: lblBrand, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        
        
        let lblBrandCenterHorizontally = NSLayoutConstraint(item: lblBrand, attribute: .centerX, relatedBy: .equal, toItem: brandView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let lblBrandBottom =  NSLayoutConstraint(item: lblBrand, attribute: .bottom, relatedBy: .equal, toItem: brandView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([lblBrandWidth, lblBrandHeight, lblBrandCenterHorizontally, lblBrandBottom])
        
    }
    
    // MARK: UI Initialization
    @objc func initTableView() {
        
        tableViewLanguage = UITableView()
        tableViewLanguage.translatesAutoresizingMaskIntoConstraints = false
        tableViewLanguage.isScrollEnabled = true
        self.addSubview(tableViewLanguage)
        tableViewLanguage.separatorStyle = .none
        tableViewLanguage.isHidden = true
        tableViewLanguage.superview?.bringSubview(toFront: tableViewLanguage)
        tableViewLanguage.allowsSelection = true;
        tableViewLanguage.isUserInteractionEnabled = true
        tableViewLanguage.clipsToBounds = false;
        //Table View shadow effects
        tableViewLanguage.layer.masksToBounds = false
        tableViewLanguage.layer.shadowOffset = CGSize(width:1, height:1);
        tableViewLanguage.layer.shadowRadius = 5
        tableViewLanguage.layer.shadowOpacity = 0.6
        tableViewLanguage.layer.shadowColor = UIColor.darkGray.cgColor
        
        //Table view cosntraints
        let tableViewLangHeight = NSLayoutConstraint(item: tableViewLanguage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130.0)
        
        let tableViewLangWidth = NSLayoutConstraint(item: tableViewLanguage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110.0)
        
        
        let tableViewLangTop =  NSLayoutConstraint(item: tableViewLanguage, attribute: .top, relatedBy: .equal, toItem: btnLanguage, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let tableViewLangLeading = NSLayoutConstraint(item: tableViewLanguage, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 15.0)
        
        NSLayoutConstraint.activate([tableViewLangHeight, tableViewLangWidth, tableViewLangTop, tableViewLangLeading])
        
        
    }
    
    @objc func initContentView() {
        contentView = UIView()
        nextPrevButtonView = UIView()
        campaignView = UIView()
        btnNext = UIButton(type: .system)
        btnPrev = UIButton(type: .system)
        
        self.addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        nextPrevButtonView.addSubview(btnPrev)
        nextPrevButtonView.addSubview(btnNext)
        contentView.addSubview(nextPrevButtonView)
        contentView.addSubview(campaignView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        nextPrevButtonView.translatesAutoresizingMaskIntoConstraints = false;
        btnPrev.translatesAutoresizingMaskIntoConstraints = false;
        btnNext.translatesAutoresizingMaskIntoConstraints = false;
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        
        btnPrev.addTarget(self, action: #selector(prevButtonAction(sender:)), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(nextButtonAction(sender:)), for: .touchUpInside)
        
        //nextPrevButtonView.backgroundColor = UIColor.red
        
        //Style buttons
        btnPrev.layer.borderWidth = 2
        btnPrev.layer.cornerRadius = 15
        btnPrev.layer.borderColor = primaryColor.cgColor
        
        btnNext.layer.borderWidth = 2
        btnNext.layer.cornerRadius = 15
        btnNext.layer.borderColor = primaryColor.cgColor
        
        btnPrev.setTitleColor(primaryColor, for: .normal)
        btnNext.setTitleColor(primaryColor, for: .normal)
        
        btnPrev.setTitle("Previous", for: .normal)
        btnNext.setTitle("Next", for: .normal)
        
        //Content View constraints
        
        //Leading
        let contentLeading  = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let contentTrailing  = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let contentBottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: footerView, attribute: .top, multiplier: 1.0, constant: 0.0)
        //Top
        let contentTop = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([contentLeading, contentTrailing, contentBottom, contentTop])
        
        //Button View Constraints
        
        //Leading
        let buttonViewLeading  = NSLayoutConstraint(item: nextPrevButtonView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let buttonViewTrailing  = NSLayoutConstraint(item: nextPrevButtonView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let buttonViewBottom = NSLayoutConstraint(item: nextPrevButtonView,
                                                  attribute: .bottom,
                                                  //relatedBy: .greaterThanOrEqual,
            relatedBy :.equal,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -10.0)
        let buttonViewHeight = NSLayoutConstraint(item: nextPrevButtonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant:40.0)
        
        NSLayoutConstraint.activate([buttonViewLeading, buttonViewTrailing, buttonViewBottom, buttonViewHeight])
        
        //Prev Button Constrinats
        let btnPrevHeight = NSLayoutConstraint(item: btnPrev, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0,  constant: 30.0)
        
        let btnPrevWidth = NSLayoutConstraint(item: btnPrev, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        let btnPrevleading = NSLayoutConstraint(item: btnPrev, attribute: .leading,  relatedBy: .equal, toItem: nextPrevButtonView, attribute: .leading, multiplier: 1.0, constant: 50.0)
        
        let btnPrevCenterVertically = NSLayoutConstraint(item: btnPrev, attribute: .centerY, relatedBy: .equal, toItem: nextPrevButtonView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([btnPrevHeight, btnPrevWidth, btnPrevleading, btnPrevCenterVertically])
        
        //Next Button Constrinats
        
        let btnNextHeight = NSLayoutConstraint(item: btnNext, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        let btnNextWidth = NSLayoutConstraint(item: btnNext, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        
        let btnNextCenterVertically = NSLayoutConstraint(item: btnNext, attribute: .centerY,  relatedBy: .equal, toItem: nextPrevButtonView, attribute: .centerY,  multiplier: 1.0, constant: 0.0)
        
        let btnNextTrailing = NSLayoutConstraint(item: btnNext, attribute: .trailing, relatedBy: .equal, toItem: nextPrevButtonView, attribute: .trailing, multiplier: 1.0, constant: -50.0)
        
        
        NSLayoutConstraint.activate([btnNextHeight, btnNextWidth, btnNextTrailing, btnNextCenterVertically])
        
        //Campaign View constraints
        
        //Leading
        let campaignLeading  = NSLayoutConstraint(item: campaignView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let campaignTrailing  = NSLayoutConstraint(item: campaignView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let campaignBottom = NSLayoutConstraint(item: campaignView, attribute: .bottom, relatedBy: .equal, toItem: nextPrevButtonView, attribute: .top, multiplier: 1.0, constant: 0.0)
        //Top
        let campaignTop = NSLayoutConstraint(item: campaignView,
                                             attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignLeading, campaignTrailing, campaignBottom, campaignTop])
        
    }
    @objc func initFooterView() {
        
        footerView = UIView()
        footerView.backgroundColor = primaryColor
        self.addSubview(footerView)
        lblPoweredBy = UILabel()
        lblPoweredBy.text = "Powered by Loyagram"
        lblPoweredBy.textColor = UIColor.white
        footerView.addSubview(lblPoweredBy)
        lblPoweredBy.translatesAutoresizingMaskIntoConstraints = false;
        //Layout Constraints
        
        let lblPoweredByCenterHorizontally = NSLayoutConstraint(item: lblPoweredBy, attribute: .centerX, relatedBy: .equal, toItem: footerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let blPoweredByCenterVertically = NSLayoutConstraint(item: lblPoweredBy, attribute: .centerY, relatedBy: .equal, toItem: footerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([lblPoweredByCenterHorizontally, blPoweredByCenterVertically])
        //Leading
        footerView.translatesAutoresizingMaskIntoConstraints = false;
        let footerLeading  = NSLayoutConstraint(item: footerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let footerTrailing  = NSLayoutConstraint(item: footerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let footerBottom = NSLayoutConstraint(item: footerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom,  multiplier: 1.0, constant: 0.0)
        //Height
        let footerHeight = NSLayoutConstraint(item: footerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 30.0)
        
        NSLayoutConstraint.activate([footerLeading, footerTrailing, footerBottom, footerHeight])
    }
    
    @objc func showQuestion() {
    
        let campaignContentView = LoyagramSurveyView(frame: campaignView.frame, question: currentQuestion, currentLang: currentLanguage, primaryLang: primaryLanguage, color: primaryColor)
        campaignView.addSubview(campaignContentView)
        
    
    }
    @objc func nextButtonAction(sender:UIButton!) {
        
        btnNext.backgroundColor = primaryColor
        btnNext.setTitleColor(UIColor.white, for: .normal)
        btnPrev.setTitleColor(primaryColor, for: .normal)
        btnPrev.backgroundColor = UIColor.white
        showQuestion()
    }
    
    @objc func prevButtonAction(sender:UIButton!) {
        btnPrev.backgroundColor = primaryColor
        btnPrev.setTitleColor(UIColor.white, for: .normal)
        btnNext.setTitleColor(primaryColor, for: .normal)
        btnNext.backgroundColor = UIColor.white
        
    }
    
    
    @objc func closeButtonAction(sender:UIButton!) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func languageButtonAction(sender:UIButton!) {
        
        tableViewLanguage.isHidden = !tableViewLanguage.isHidden
        self.bringSubview(toFront: tableViewLanguage)
        //tableViewLanguage.reloadData()
        self.sendSubview(toBack: contentView)
    }
    
    // MARK:-
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return languages.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LanguageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "LanguageCell")
        cell.selectionStyle = .none
        cell.lblLanguage.text = languages[indexPath.row] as? String
        //check if row is current language
        if(currentLang == indexPath.row) {
            cell.backgroundColor = UIColor.white
            cell.lblLanguage.textColor = primaryColor
        }
        else {
            cell.backgroundColor = primaryColor
            cell.lblLanguage.textColor = UIColor.white
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        tableViewLanguage.isHidden = !tableViewLanguage.isHidden
        currentLang = indexPath.row
        let cell = tableViewLanguage.cellForRow(at: indexPath) as! LanguageTableViewCell
        cell.backgroundColor = UIColor.white
        cell.lblLanguage.textColor = primaryColor
        tableViewLanguage.reloadData()
    }
    
    func setCampaign(campaign:Campaign) {
        
        self.campaign = campaign
        currentQuestion = campaign.questions[2]
        loadLanguages()
    }
    
    func loadLanguages() {
        let languages = campaign.settings.translation
        for language in languages! {
            if(language.primary) {
                currentLanguage = language
                primaryLanguage = language
                break
            }
        }
  
    }
}
