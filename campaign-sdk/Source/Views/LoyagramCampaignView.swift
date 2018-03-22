//
//  LoyagramCampaignView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 09/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

protocol LoyagramCampaignButtonDelegate: class {
    
    func prevButtonPressed(iterator: Int)
    func nextButtonPressed(iterator: Int)
    
}

protocol LoyagramLanguageDelegate: class {
    
    func languageChanged(lang: Language)
    
}
public class LoyagramCampaignView: UIView, UITableViewDelegate, UITableViewDataSource, LoyagramCSATCESDelegate, LoyagramNPSDelegate {
    func setCSATCESFollowUpEmail(email: String) {
        followUpEmail = email
    }
    
    func setNPSFollowUpEmail(email: String) {
        followUpEmail = email
    }
    

    func enableCSATCESFollowUp(enable: Bool) {
        isEmailFollowUpEnabled = enable
        if(!enable) {
            txtValidation.isHidden = true
        }
    }
    
    func enableNPSFollowUp(enable: Bool) {
        isEmailFollowUpEnabled = enable
        if(!enable) {
            txtValidation.isHidden = true
        }
    }
    

    
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
    var dialogView: UIView!
    var tableViewLanguage : UITableView!
    var tableViewContainer : UIView!
    var languages = [Language]()
    var primaryColor : UIColor!
    var currentLang : Int!
    var nextPrevButtonView: UIView!
    var btnNext:UIButton!
    var btnPrev: UIButton!
    var campaignView: UIView!
    var campaignFrame: CGRect!
    var campaign: Campaign?
    var currentQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var questionNumber = 0
    var noOfQuestions = 0
    var btnStart: UIButton!
    var startButtonContainerView: UIView!
    var campaignButtonDelegate: LoyagramCampaignButtonDelegate!
    var onSuccess: (() -> Void)?
    var onError: (() -> Void)?
    var languageDelegate: LoyagramLanguageDelegate!
    var followUpIterator: Int = 0
    var bottomConstraint : NSLayoutConstraint!
    var topConstraint : NSLayoutConstraint!
    var mainView : UIView!
    var npsRating = 0
    var cescsatOption = "neutral"
    var staticTexts = StaticTextTranslation()
    var txtWelcomeMessage : UITextView!
    var txtWelcomeTip : UITextView!
    var activityIndicator: UIActivityIndicatorView!
    var response: Response!
    var chk: CheckBox!
    var thankYouView: UIView!
    var isColorSet = false
    var campaignViewType: Int?
    var isNextActive = false
    var isPrevActive = false
    var statusBar: UIView?
    var txtValidation: UITextView!
    var currentValidationString = ""
    var isEmailFollowUpEnabled = false
    var followUpEmail = ""
    
    public override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    init(frame:CGRect, color:UIColor) {
        super.init(frame:frame)
        if(color == UIColor.clear) {
            let tintColor = getTintColor()
            if(tintColor != nil) {
                isColorSet = true
                primaryColor = tintColor
            } else {
                primaryColor = UIColor.white
            }
        } else {
            primaryColor = color
            isColorSet = true
        }
        self.isUserInteractionEnabled = true
        GlobalConstants.initContstants()
        
        initMainView()
        initHeaderView()
        initFooterView()
        initContentView()
        initCampaignStartButton()
        initTableView()
        
        let bundle = Bundle(for: type(of: self))
        btnClose.setImage(UIImage(named: "close.png", in: bundle, compatibleWith: nil), for:.normal)
        btnLanguage.setImage(UIImage(named: "drop-down-arrow.png", in: bundle, compatibleWith: nil), for: .normal)
        btnLanguage.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
        btnLanguage.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btnLanguage.semanticContentAttribute = .forceRightToLeft
        btnLanguage.contentHorizontalAlignment = .left
        
        tableViewLanguage.register(UITableViewCell.self, forCellReuseIdentifier: "languageCell")
        tableViewLanguage.delegate = self
        tableViewLanguage.dataSource = self
        tableViewLanguage.tableFooterView = UIView()
        tableViewLanguage.layer.zPosition = 1
        currentLang = 0
        showActivityIndicator()
        hideCampaignView()
        if(isColorSet) {
            setTheme(colorTheme: primaryColor, isColorPrimarySet: true)
        } else{
            setTheme(colorTheme: UIColor.white, isColorPrimarySet: false)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setViewController(vc:UIViewController!, statusBar: UIView) {
        self.viewController = vc
        self.statusBar = statusBar
        statusBar.backgroundColor = primaryColor
    }
    
    @objc func setDialogView(view:UIView!) {
        dialogView = view
    }
    
    // 0 for controller , 1 for dialog, 2 for animate from bottom
    @objc func setCampaignType(type:Int) {
        campaignViewType = type
    }
    
    func setTheme(colorTheme: UIColor, isColorPrimarySet:Bool) {
        if(!isColorPrimarySet) {
            activityIndicator.color = UIColor.lightGray
        }else {
            activityIndicator.color = colorTheme
        }
        if(statusBar != nil) {
            statusBar?.backgroundColor = colorTheme
        }
        headerView.backgroundColor = colorTheme
        contentView.backgroundColor = UIColor.white
        footerView.backgroundColor = colorTheme
        btnStart.backgroundColor = colorTheme
        btnPrev.layer.borderColor = colorTheme.cgColor
        btnNext.layer.borderColor = colorTheme.cgColor
        btnStart.layer.borderColor = colorTheme.cgColor
    }
    
    @objc func initMainView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.isUserInteractionEnabled = true
        self.addSubview(mainView)
        
        NSLayoutConstraint(item: mainView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: mainView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        topConstraint = NSLayoutConstraint(item: mainView, attribute: .top, relatedBy: .equal, toItem: self,  attribute: .top, multiplier: 1.0, constant: 0.0)
        
        bottomConstraint = NSLayoutConstraint(item: mainView, attribute: .bottom, relatedBy: .equal, toItem: self,  attribute: .bottom, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([bottomConstraint, topConstraint])
        
    }
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    // MARK: UI Initialization
    @objc func initHeaderView () {
        headerView = UIView()
        brandView = UIView()
        imageViewBrand = UIImageView()
        lblBrand = UILabel()
        btnClose = UIButton()
        lblQuestionCount = UILabel()
        btnLanguage = UIButton(type: .custom)
        //imageViewArrow = UIImageView()
        //imageViewBrand.contentMode = .scaleAspectFit;
        imageViewBrand.contentMode = .scaleAspectFill
        
        lblBrand.textColor = UIColor.white
        lblBrand.textAlignment = .center
        brandView.addSubview(imageViewBrand)
        brandView.addSubview(lblBrand)
        
        
        headerView.addSubview(btnClose)
        headerView.addSubview(brandView)
        headerView.addSubview(btnLanguage)
        //headerView.addSubview(imageViewArrow)
        headerView.addSubview(lblQuestionCount)
        mainView.addSubview(headerView)
        
        //headerView.backgroundColor = primaryColor
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
        
        //lblQuestionCount.text = " "
        //btnLanguage.setTitle("English", for: .normal)
        
        lblBrand.font = GlobalConstants.FONT_MEDIUM
        btnLanguage.titleLabel?.font = GlobalConstants.FONT_MEDIUM
        lblQuestionCount.font = GlobalConstants.FONT_MEDIUM
        
        btnClose.addTarget(self, action: #selector(closeButtonAction(sender:)), for: .touchUpInside)
        btnLanguage.addTarget(self, action: #selector(languageButtonAction(sender:)), for: .touchUpInside)
        // Constriants to headerView
        
        //Leading
        let headerLeading  = NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let headerTrailing  = NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let headerTop = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: mainView,  attribute: .top, multiplier: 1.0, constant: 0.0)
        //Height
        let headerHeight = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130.0)
        
        NSLayoutConstraint.activate([headerLeading, headerTrailing, headerTop, headerHeight])
        
        
        //Constraints for question label
        
        //Height
        let lblQuestionCountHeight = NSLayoutConstraint(item: lblQuestionCount, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 30.0)
        
        //Width
        let lblQuestionCountWidth = NSLayoutConstraint(item: lblQuestionCount, attribute: .width,  relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,   multiplier: 1.0, constant: 40.0)
        
        let lblQuestionCountBottom = NSLayoutConstraint(item: lblQuestionCount, attribute: .bottom,  relatedBy: .equal,  toItem: headerView,  attribute: .bottom, multiplier: 1.0, constant: -5.0)
        
        let lblQuestionCountTrailing = NSLayoutConstraint(item: lblQuestionCount, attribute: .trailing,  relatedBy: .equal,  toItem: headerView,  attribute: .trailing,   multiplier: 1.0,  constant: -5.0)
        
        NSLayoutConstraint.activate([lblQuestionCountHeight, lblQuestionCountWidth, lblQuestionCountBottom, lblQuestionCountTrailing])
        
        
        //Constraints for language label
        
        //Height
        let btnLanguageHeight = NSLayoutConstraint(item: btnLanguage, attribute: .height,  relatedBy: .equal,   toItem: nil,  attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        //Width
        let btnLanguageWidth = NSLayoutConstraint(item: btnLanguage,
                                                  attribute: .width, relatedBy: .equal,  toItem: nil,  attribute: .notAnAttribute,  multiplier: 1.0, constant: 120.0)
        
        let btnLanguageBottom = NSLayoutConstraint(item: btnLanguage,
                                                   attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom,  multiplier: 1.0,  constant: -5.0)
        
        let btnLanguageLeading = NSLayoutConstraint(item: btnLanguage,
                                                    attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 15.0)
        
        NSLayoutConstraint.activate([btnLanguageHeight, btnLanguageWidth, btnLanguageBottom, btnLanguageLeading])
        
        
        //Close Button Constraints
        
        //Height
        let closeButtonHeight = NSLayoutConstraint(item: btnClose, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        //Height
        let closeButtonWidth = NSLayoutConstraint(item: btnClose, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,   multiplier: 1.0,  constant: 20.0)
        
        let closeButtonTop = NSLayoutConstraint(item: btnClose, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 10.0)
        
        let closeButtonTrailing = NSLayoutConstraint(item: btnClose, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        NSLayoutConstraint.activate([closeButtonWidth, closeButtonHeight, closeButtonTop, closeButtonTrailing])
        
        
        //BrandView Constraints
        let brandCenterHorizontally = NSLayoutConstraint(item: brandView, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let brandTop = NSLayoutConstraint(item: brandView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 10.0)
        
        //Height
        let brandHeight = NSLayoutConstraint(item: brandView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110.0)
        
        //Height
        let brandWidth = NSLayoutConstraint(item: brandView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0)
        
        NSLayoutConstraint.activate([brandCenterHorizontally, brandTop, brandWidth, brandHeight])
        
        
        //Brand Image Constraints
        let imgBrandCenterHorizontally = NSLayoutConstraint(item: imageViewBrand, attribute: .centerX, relatedBy: .equal, toItem: brandView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let imgBrandTop =  NSLayoutConstraint(item: imageViewBrand, attribute: .top, relatedBy: .equal,  toItem: brandView,  attribute: .top, multiplier: 1.0, constant: 0.0)
        
        
        let imgBrandWidth = NSLayoutConstraint(item: imageViewBrand, attribute: .width, relatedBy: .equal,  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70.0)
        let imgBrandHeight = NSLayoutConstraint(item: imageViewBrand, attribute: .height, relatedBy: .equal,  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70.0)
        
        NSLayoutConstraint.activate([imgBrandCenterHorizontally, imgBrandTop, imgBrandWidth, imgBrandHeight])
        
        
        //Brand Label Constraints
        
        let lblBrandHeight = NSLayoutConstraint(item: lblBrand, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        let lblBrandWidth = NSLayoutConstraint(item: lblBrand, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        
        
        let lblBrandCenterHorizontally = NSLayoutConstraint(item: lblBrand, attribute: .centerX, relatedBy: .equal, toItem: brandView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let lblBrandTop =  NSLayoutConstraint(item: lblBrand, attribute: .top, relatedBy: .equal, toItem: imageViewBrand, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([lblBrandWidth, lblBrandHeight, lblBrandCenterHorizontally, lblBrandTop]) 
    }
    
    
    @objc func initTableView() {
        
        tableViewContainer = UIView()
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(tableViewContainer)
        
        tableViewLanguage = UITableView()
        tableViewLanguage.translatesAutoresizingMaskIntoConstraints = false
        tableViewLanguage.isScrollEnabled = true
        tableViewLanguage.bounces = false
        tableViewContainer.addSubview(tableViewLanguage)
        tableViewLanguage.separatorStyle = .none
        tableViewContainer.isHidden = true
        tableViewLanguage.allowsSelection = true;
        tableViewLanguage.isUserInteractionEnabled = true
        tableViewContainer.layer.shadowOffset = CGSize(width:1, height:1);
        tableViewContainer.layer.shadowRadius = 5
        tableViewContainer.layer.shadowOpacity = 0.6
        tableViewContainer.layer.shadowColor = UIColor.darkGray.cgColor
        
        tableViewLanguage.showsVerticalScrollIndicator = false
        tableViewLanguage.showsHorizontalScrollIndicator = false
        
        
        //Table view cosntraints
        let containerHeight = NSLayoutConstraint(item: tableViewContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130.0)
        
        let containerWidth = NSLayoutConstraint(item: tableViewContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120.0)
        
        
        let containerTop =  NSLayoutConstraint(item: tableViewContainer, attribute: .top, relatedBy: .equal, toItem: btnLanguage, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let containerLeading = NSLayoutConstraint(item: tableViewContainer, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        NSLayoutConstraint.activate([containerHeight,containerWidth, containerTop, containerLeading])
        
        
        //NSLayoutConstraint.activate([tableViewLangHeight, tableViewLangWidth, tableViewLangTop, tableViewLangLeading])
        let tblBottom = NSLayoutConstraint(item: tableViewLanguage, attribute: .bottom, relatedBy: .equal, toItem: tableViewContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let tbltrailing = NSLayoutConstraint(item: tableViewLanguage, attribute: .trailing, relatedBy: .equal, toItem: tableViewContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        
        let tblTop =  NSLayoutConstraint(item: tableViewLanguage, attribute: .top, relatedBy: .equal, toItem: tableViewContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let tblleading = NSLayoutConstraint(item: tableViewLanguage, attribute: .leading, relatedBy: .equal, toItem: tableViewContainer, attribute: .leading, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([tblBottom,tbltrailing, tblTop, containerLeading, tblleading])
        
    }
    
    
    
    @objc func initContentView() {
        contentView = UIView()
        contentView.isUserInteractionEnabled = true
        nextPrevButtonView = UIView()
        nextPrevButtonView.isHidden = true
        campaignView = UIView()
        btnNext = UIButton(type: .system)
        btnPrev = UIButton(type: .system)
        
        //campaignView.backgroundColor = UIColor.red
        mainView.addSubview(contentView)
        //contentView.backgroundColor = UIColor.white
        nextPrevButtonView.addSubview(btnPrev)
        nextPrevButtonView.addSubview(btnNext)
        contentView.addSubview(nextPrevButtonView)
        contentView.addSubview(campaignView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        nextPrevButtonView.translatesAutoresizingMaskIntoConstraints = false;
        btnPrev.translatesAutoresizingMaskIntoConstraints = false;
        btnNext.translatesAutoresizingMaskIntoConstraints = false;
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        campaignView.isUserInteractionEnabled = true
        
        btnPrev.addTarget(self, action: #selector(prevButtonAction(sender:)), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(nextButtonAction(sender:)), for: .touchUpInside)
        
        
        //Style buttons
        btnPrev.layer.borderWidth = 2
        btnPrev.layer.cornerRadius = 15
        //btnPrev.layer.borderColor = primaryColor.cgColor
        
        btnNext.layer.borderWidth = 2
        btnNext.layer.cornerRadius = 15
        //btnNext.layer.borderColor = primaryColor.cgColor
        
        btnPrev.setTitleColor(primaryColor, for: .normal)
        btnNext.setTitleColor(primaryColor, for: .normal)
        
        txtValidation = UITextView()
        txtValidation.isEditable = false
        txtValidation.translatesAutoresizingMaskIntoConstraints = false
        txtValidation.isHidden = true
        txtValidation.font = GlobalConstants.FONT_SMALL
        
        nextPrevButtonView.addSubview(txtValidation)
        
        //txtValidation.text = "This field is required"
        
        txtValidation.textColor = UIColor.red
        txtValidation.textAlignment = .center
        
        //Content View constraints
        
        //Leading
        let contentLeading  = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let contentTrailing  = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: 0)
        
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
            constant: -5.0)
        let buttonViewHeight = NSLayoutConstraint(item: nextPrevButtonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant:55.0)
        
        NSLayoutConstraint.activate([buttonViewLeading, buttonViewTrailing, buttonViewBottom, buttonViewHeight])
        
        //Prev Button Constrinats
        let btnPrevHeight = NSLayoutConstraint(item: btnPrev, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0,  constant: 30.0)
        
        let btnPrevWidth = NSLayoutConstraint(item: btnPrev, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        let btnPrevleading = NSLayoutConstraint(item: btnPrev, attribute: .leading,  relatedBy: .equal, toItem: nextPrevButtonView, attribute: .leading, multiplier: 1.0, constant: 50.0)
        
        let btnPrevCenterVertically = NSLayoutConstraint(item: btnPrev, attribute: .centerY, relatedBy: .equal, toItem: nextPrevButtonView, attribute: .centerY, multiplier: 1.0, constant: 10.0)
        
        NSLayoutConstraint.activate([btnPrevHeight, btnPrevWidth, btnPrevleading, btnPrevCenterVertically])
        
        //Next Button Constraints
        
        let btnNextHeight = NSLayoutConstraint(item: btnNext, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        let btnNextWidth = NSLayoutConstraint(item: btnNext, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        
        let btnNextCenterVertically = NSLayoutConstraint(item: btnNext, attribute: .centerY,  relatedBy: .equal, toItem: nextPrevButtonView, attribute: .centerY,  multiplier: 1.0, constant: 10.0)
        
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
        
        
        //TextView Validation Constraints
        NSLayoutConstraint(item: txtValidation, attribute: .leading, relatedBy: .equal, toItem: nextPrevButtonView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: txtValidation, attribute: .trailing, relatedBy: .equal, toItem: nextPrevButtonView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: txtValidation, attribute: .top, relatedBy: .equal, toItem: nextPrevButtonView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: txtValidation, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        txtValidation.isScrollEnabled = false
        //txtValidation.backgroundColor = UIColor.green
    }
    @objc func initFooterView() {
        
        footerView = UIView()
        //footerView.backgroundColor = primaryColor
        mainView.addSubview(footerView)
        lblPoweredBy = UILabel()
        //lblPoweredBy.text = "Powered by Loyagram"
        lblPoweredBy.textColor = UIColor.white
        footerView.addSubview(lblPoweredBy)
        lblPoweredBy.translatesAutoresizingMaskIntoConstraints = false;
        lblPoweredBy.font = GlobalConstants.FONT_MEDIUM
        //Layout Constraints
        
        let lblPoweredByCenterHorizontally = NSLayoutConstraint(item: lblPoweredBy, attribute: .centerX, relatedBy: .equal, toItem: footerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let blPoweredByCenterVertically = NSLayoutConstraint(item: lblPoweredBy, attribute: .centerY, relatedBy: .equal, toItem: footerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([lblPoweredByCenterHorizontally, blPoweredByCenterVertically])
        //Leading
        footerView.translatesAutoresizingMaskIntoConstraints = false;
        let footerLeading  = NSLayoutConstraint(item: footerView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1, constant: 0)
        
        //Trailing
        let footerTrailing  = NSLayoutConstraint(item: footerView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Top
        let footerBottom = NSLayoutConstraint(item: footerView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom,  multiplier: 1.0, constant: 0.0)
        //Height
        let footerHeight = NSLayoutConstraint(item: footerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 30.0)
        
        NSLayoutConstraint.activate([footerLeading, footerTrailing, footerBottom, footerHeight])
    }
    
    @objc func initCampaignStartButton() {
        
        startButtonContainerView = UIView()
        startButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startButtonContainerView)
        btnStart = UIButton(type:.system)
        btnStart.translatesAutoresizingMaskIntoConstraints = false
        startButtonContainerView.addSubview(btnStart)
        //btnStart.setTitle("Start", for: .normal)
        btnStart.layer.borderWidth = 1.0
        btnStart.layer.cornerRadius = 15
        //btnStart.layer.borderColor = primaryColor.cgColor
        //        btnStart.backgroundColor = primaryColor
        btnStart.setTitleColor(UIColor.white, for: .normal)
        initWelcomeView()
        //Start Button Container
        NSLayoutConstraint(item: startButtonContainerView, attribute: .leading,  relatedBy: .equal, toItem: contentView, attribute: .leading,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: startButtonContainerView, attribute: .trailing,  relatedBy: .equal, toItem: contentView, attribute: .trailing,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: startButtonContainerView, attribute: .centerY,  relatedBy: .equal, toItem: contentView, attribute: .centerY,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: startButtonContainerView, attribute: .centerX,  relatedBy: .equal, toItem: contentView, attribute: .centerX,  multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: startButtonContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 120.0).isActive = true
        
        //Start button Constraints
        let btnHeight = NSLayoutConstraint(item: btnStart, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 30.0)
        
        let btnWidth = NSLayoutConstraint(item: btnStart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 80.0)
        
        let btnTop = NSLayoutConstraint(item: btnStart, attribute: .top,  relatedBy: .equal, toItem: txtWelcomeMessage, attribute: .bottom,  multiplier: 1.0, constant: 5.0)
        
        let btnCenterHorizontally = NSLayoutConstraint(item: btnStart, attribute: .centerX,  relatedBy: .equal, toItem: startButtonContainerView, attribute: .centerX,  multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([btnWidth, btnHeight, btnTop, btnCenterHorizontally])
        
        btnStart.addTarget(self, action: #selector(startButtonAction(sender:)), for: .touchUpInside)
        
        
    }
    
    @objc func initWelcomeView() {
        txtWelcomeMessage = UITextView()
        txtWelcomeMessage.isEditable = false
        txtWelcomeMessage.translatesAutoresizingMaskIntoConstraints = false
        startButtonContainerView.addSubview(txtWelcomeMessage)
        txtWelcomeMessage.textAlignment = .center
        
        //txtWelcomeMessage.backgroundColor = UIColor.red
        txtWelcomeTip = UITextView()
        txtWelcomeTip.isEditable = false
        txtWelcomeTip.translatesAutoresizingMaskIntoConstraints = false
        txtWelcomeTip.textAlignment = .center
        //txtWelcomeTip.backgroundColor = UIColor.red
        startButtonContainerView.addSubview(txtWelcomeTip)
        
        txtWelcomeTip.font = GlobalConstants.FONT_SMALL
        txtWelcomeMessage.font = GlobalConstants.FONT_MEDIUM
        txtWelcomeTip.textColor = UIColor.lightGray
        
        showHideWelcomeScreen(isShow: false)
        //Welcome message constrinats
        NSLayoutConstraint(item: txtWelcomeMessage, attribute: .leading,  relatedBy: .equal, toItem: startButtonContainerView, attribute: .leading,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: txtWelcomeMessage, attribute: .trailing,  relatedBy: .equal, toItem: startButtonContainerView, attribute: .trailing,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: txtWelcomeMessage, attribute: .top,  relatedBy: .equal, toItem: startButtonContainerView, attribute: .top,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: txtWelcomeMessage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 45.0).isActive = true
        
        //Welcome Tip constrinats
        NSLayoutConstraint(item: txtWelcomeTip, attribute: .leading,  relatedBy: .equal, toItem: startButtonContainerView, attribute: .leading,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: txtWelcomeTip, attribute: .trailing,  relatedBy: .equal, toItem: startButtonContainerView, attribute: .trailing,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: txtWelcomeTip, attribute: .bottom,  relatedBy: .equal, toItem: startButtonContainerView, attribute: .bottom,  multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: txtWelcomeTip, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 35.0).isActive = true
        
        
    }
    @objc func startButtonAction(sender: UIButton!) {
        startButtonContainerView.isHidden = true
        nextPrevButtonView.isHidden = false
        showQuestion(isFromRight: true)
    }
    
    @objc func showQuestion(isFromRight:Bool) {
        currentQuestion = campaign?.questions?[questionNumber-1]
        let campaignType = campaign?.type
        if(campaignType != nil) {
            if(campaignType == "SAT" ) {
                showCSATCESView(isCSAT: true, isFromRight: isFromRight)
            } else if(campaignType == "ES") {
                showCSATCESView(isCSAT: false,isFromRight: isFromRight)
            } else if (campaignType == "NPS") {
                showNPSView(isFromRight: isFromRight)
            }
            else {
                switch(currentQuestion.type ?? "") {
                case "SINGLE_SELECT":
                    showSurveyView(isFromRight: isFromRight)
                    break
                case "MULTI_SELECT":
                    showSurveyView(isFromRight: isFromRight)
                    break
                case "RATING":
                    showRatingView(isFromRight: isFromRight)
                    break
                case "NPS":
                    showNPSView(isFromRight: isFromRight)
                    break
                case "PARAGRAPH":
                    showTextView(isFromRight: isFromRight)
                    break
                case "SHORT_ANSWER":
                    showTextView(isFromRight: isFromRight)
                    break
                case "EMAIL":
                    showTextView(isFromRight: isFromRight)
                    break
                case "NUMBER":
                    showTextView(isFromRight: isFromRight)
                    break
                default :
                    break
                }
            }
        }
    }
    
    //MARK : Show Question Views
    @objc func showSurveyView(isFromRight:Bool) {
        let campaignContentView = LoyagramSurveyView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), question: currentQuestion, currentLang: currentLanguage, primaryLang: primaryLanguage, color: primaryColor, campaignView:self, resposne:response)
        animateCampaignView(isFromRight: isFromRight)
        campaignView.addSubview(campaignContentView)
        campaignContentView.translatesAutoresizingMaskIntoConstraints = false
        //CampaignContentView cosntraints
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignContentView, attribute: .trailing, relatedBy: .equal, toItem: campaignView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignContentView, attribute: .leading, relatedBy: .equal, toItem: campaignView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: campaignContentView, attribute: .top, relatedBy: .equal, toItem: campaignView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignContentView, attribute: .bottom, relatedBy: .equal, toItem: campaignView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
    }
    @objc func showRatingView(isFromRight:Bool) {
        let campaignContentView = LoyagramRatingView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), question: currentQuestion, currentLang: currentLanguage, primaryLang: primaryLanguage, color: primaryColor, campaignView:self, response:response)
        animateCampaignView(isFromRight: isFromRight)
        campaignView.addSubview(campaignContentView)
        campaignContentView.translatesAutoresizingMaskIntoConstraints = false
        //CampaignContentView cosntraints
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignContentView, attribute: .trailing, relatedBy: .equal, toItem: campaignView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignContentView, attribute: .leading, relatedBy: .equal, toItem: campaignView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: campaignContentView, attribute: .top, relatedBy: .equal, toItem: campaignView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignContentView, attribute: .bottom, relatedBy: .equal, toItem: campaignView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
        
    }
    @objc func showNPSView(isFromRight:Bool) {
        let followUpQuestion = campaign?.questions?[1]
        let campaignContentView = LoyagramNPSView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), campaignType:(campaign?.type)!, question: currentQuestion, followUpQuestion: followUpQuestion!, currentLang: currentLanguage, primaryLang: primaryLanguage, color: primaryColor, campaignView: self, bottomConstraint:bottomConstraint, staticTextes:staticTexts, response:response)
        animateCampaignView(isFromRight: isFromRight)
        campaignView.addSubview(campaignContentView)
        campaignContentView.isUserInteractionEnabled = true
        campaignContentView.delegate = self
        campaignContentView.translatesAutoresizingMaskIntoConstraints = false
        //CampaignContentView cosntraints
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignContentView, attribute: .trailing, relatedBy: .equal, toItem: campaignView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignContentView, attribute: .leading, relatedBy: .equal, toItem: campaignView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: campaignContentView, attribute: .top, relatedBy: .equal, toItem: campaignView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignContentView, attribute: .bottom, relatedBy: .equal, toItem: campaignView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
    }
    @objc func showTextView(isFromRight:Bool) {
        let campaignContentView = LoyagramTextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), question: currentQuestion, currentLang: currentLanguage, primaryLang: primaryLanguage, color: primaryColor, staticTexts: staticTexts, response:response, campaignView:self)
        animateCampaignView(isFromRight: isFromRight)
        campaignView.addSubview(campaignContentView)
        campaignContentView.translatesAutoresizingMaskIntoConstraints = false
        //CampaignContentView cosntraints
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignContentView, attribute: .trailing, relatedBy: .equal, toItem: campaignView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignContentView, attribute: .leading, relatedBy: .equal, toItem: campaignView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: campaignContentView, attribute: .top, relatedBy: .equal, toItem: campaignView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignContentView, attribute: .bottom, relatedBy: .equal, toItem: campaignView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
    }
    @objc func showCSATCESView(isCSAT: Bool, isFromRight:Bool) {
        let followUpQuestion = campaign?.questions?[1]
        let campaignContentView = LoyagramCSATCESView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), question: currentQuestion, followUpQuestion: followUpQuestion!, currentLang: currentLanguage, primaryLang: primaryLanguage, color: primaryColor, isCSAT:isCSAT, campaignView: self, staticTexts: staticTexts, response:response)
        campaignContentView.delegate = self
        animateCampaignView(isFromRight: isFromRight)
        campaignView.addSubview(campaignContentView)
        campaignContentView.translatesAutoresizingMaskIntoConstraints = false
        //CampaignContentView cosntraints
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignContentView, attribute: .trailing, relatedBy: .equal, toItem: campaignView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignContentView, attribute: .leading, relatedBy: .equal, toItem: campaignView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: campaignContentView, attribute: .top, relatedBy: .equal, toItem: campaignView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignContentView, attribute: .bottom, relatedBy: .equal, toItem: campaignView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
    }
    
    @objc func animateCampaignView(isFromRight:Bool) {
        campaignView.layer.removeAllAnimations()
        let transition = CATransition()
        transition.type = kCATransitionPush
        if(isFromRight) {
            transition.subtype = kCATransitionFromRight
            
        } else {
            transition.subtype = kCATransitionFromLeft
        }
        campaignView.layer.add(transition, forKey: nil)
    }
    
    @objc func hideCampaignView() {
        btnLanguage.isHidden = true
        brandView.isHidden = true
        lblQuestionCount.isHidden = true
        lblPoweredBy.isHidden = true
        nextPrevButtonView.isHidden = true
        startButtonContainerView.isHidden = true
        
    }
    @objc func showCampaignView() {
        
        brandView.isHidden = false
        lblPoweredBy.isHidden = false
        startButtonContainerView.isHidden = false
        if(campaign?.type == "SURVEY") {
            lblQuestionCount.isHidden = false
        }
        if(languages.count > 1) {
            btnLanguage.isHidden = false
        }
    }
    //MARK :- Question Navigation
    
    func setNPS(rating: Int!) {
        npsRating = rating
        showNextQuestion()
    }
    
    func setOptions(option:String!) {
        cescsatOption = option
        showNextQuestion()
        
    }
    
    @objc func nextButtonAction(sender:UIButton!) {
        
        if(!isNextActive) {
            isNextActive = true
            showNextQuestion()
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.2)) {
                self.isNextActive = false
            }
        }
        
    }
    
    @objc func prevButtonAction(sender:UIButton!) {
        
        if(!isPrevActive) {
            isPrevActive = true
            showPrevQuestion()
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.2)) {
                self.isPrevActive = false
            }
        }
        
    }
    
    @objc func showNextQuestion() {
        
        if(!currentQuestion.optional!) {
            if(isQuestionAttended(question: currentQuestion)) {
                txtValidation.isHidden = true
            } else {
                txtValidation.text = staticTexts.translation["MANDATORY_QUESTION_TEXT"]
                currentValidationString = "MANDATORY_QUESTION_TEXT"
                txtValidation.isHidden = false
                return
            }
            
        }
        let campaignType = campaign?.type
        btnNext.backgroundColor = primaryColor
        btnNext.setTitleColor(UIColor.white, for: .normal)
        btnPrev.setTitleColor(primaryColor, for: .normal)
        btnPrev.backgroundColor = UIColor.white
        if(campaignType != "SURVEY" && campaignButtonDelegate != nil) {
            switch(followUpIterator) {
            case 0:
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.campaignButtonDelegate.nextButtonPressed(iterator: self.followUpIterator)
                    self.followUpIterator += 1
                }
                
                break
            case 1: campaignButtonDelegate.nextButtonPressed(iterator: followUpIterator)
            followUpIterator += 1
            btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_SUBMIT_BUTTON_TEXT"], for: .normal)
                break
            case 2:
                if(isEmailFollowUpEnabled) {
                if(!isValidEmail(email: followUpEmail)) {
                    txtValidation.text = staticTexts.translation["EMAIL_NOT_VALID_TEXT"]
                    txtValidation.isHidden = false
                    currentValidationString = "EMAIL_NOT_VALID_TEXT"
                    return
                } else {
                    txtValidation.isHidden = true
                }
                }
            campaignButtonDelegate.nextButtonPressed(iterator: followUpIterator)
            submitCampaign()
            followUpIterator = 0
                break
            default:
                break
            }
            return
        }
        else {
            if(!currentQuestion.optional!) {
            switch(currentQuestion.type ?? "") {
            case "EMAIL":
                if(!isValidEmail(email: getTextResponse())) {
                    txtValidation.text = staticTexts.translation["EMAIL_NOT_VALID_TEXT"]
                    txtValidation.isHidden = false
                    currentValidationString = "EMAIL_NOT_VALID_TEXT"
                    return
                } else {
                    txtValidation.isHidden = true
                }
                break
            case "NUMBER":
                if(!isValidNumber(number: getTextResponse())) {
                    txtValidation.text = staticTexts.translation["VALIDATION_FAILED_TEXT"]
                    txtValidation.isHidden = false
                    currentValidationString = "VALIDATION_FAILED_TEXT"
                    return
                } else {
                    txtValidation.isHidden = true
                }
                break
            default:
                break
            }
            }
            
            if(btnNext.titleLabel?.text == staticTexts.translation["CAMPAIGN_MODE_SUBMIT_BUTTON_TEXT"]) {
                print("pressed when text is submit")
                submitCampaign()
                return
            }
            questionNumber += 1
            if(questionNumber == noOfQuestions) {
                btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_SUBMIT_BUTTON_TEXT"], for: .normal)
            }
            
            let questionCount: String = "\(questionNumber)/\(noOfQuestions)"
            lblQuestionCount.text = questionCount
            removeSubViews(view:self.campaignView)
            if(questionNumber <= (campaign?.questions?.count)!) {
                showQuestion(isFromRight: true)
            }
        }
    }
    
    @objc func removeSubViews(view: UIView) {
        for subView in view.subviews as [UIView] {
            subView.removeFromSuperview()
        }
    }
    @objc func showPrevQuestion() {
        txtValidation.isHidden = true
        let campaignType = campaign?.type
        btnPrev.backgroundColor = primaryColor
        btnPrev.setTitleColor(UIColor.white, for: .normal)
        btnNext.setTitleColor(primaryColor, for: .normal)
        btnNext.backgroundColor = UIColor.white
        if(campaignType != "SURVEY") {
            switch(followUpIterator) {
            case 0:
                break
            case 1: 
                campaignButtonDelegate.prevButtonPressed(iterator: followUpIterator)
            followUpIterator -= 1
                break
            case 2: campaignButtonDelegate.prevButtonPressed(iterator: followUpIterator)
            followUpIterator -= 1
            btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_NEXT_BUTTON_TEXT"], for: .normal)
                break
            default:
                break
            }
            return
        } else {
            if(questionNumber < 2) {
                return
            }
            if(questionNumber == noOfQuestions) {
                btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_NEXT_BUTTON_TEXT"], for: .normal)
            }
            questionNumber -= 1
            let questionCount: String = "\(questionNumber)/\(noOfQuestions)"
            lblQuestionCount.text = questionCount
            removeSubViews(view:self.campaignView)
            showQuestion(isFromRight: false)
        }
    }
    
    @objc func submitCampaign() {
        showThankYou()
         let encoder = JSONEncoder()
         encoder.outputFormatting = .prettyPrinted
         response.ended_at = CUnsignedLong(Date().timeIntervalSince1970 * 1000)
         response.language_code = currentLanguage.language_code
         let data = try! encoder.encode(response)
         let jsonString = String(data:data, encoding: .utf8)
         //let jsonString = String(data: data, encoding: String.Encoding.utf8)!.replacingOccurrences(of: "\\", with: "")
         let jsonStringWithData:[String:Any] = ["data":jsonString ?? ""]
//         let dict = NSMutableDictionary()
//         dict.setValue(jsonString, forKey: "data")
         let jsonData = try? JSONSerialization.data(withJSONObject: jsonStringWithData)
         //let valid = JSONSerialization.isValidJSONObject(jsonData)
        print(String(data:jsonData!, encoding : .utf8)!)
//        campaignDelegate = viewController.self as! LoyagramCampaignCallback!
        
        SubmitResponse.submitResponse(response: jsonData!, success: {() -> Void in
           self.deleteResponse()
            if let successCallback = self.onSuccess {
                successCallback ()
            }
         //print("sucessfully submited")
         }, failure: {() -> Void in
            if let successCallback = self.onError {
                successCallback ()
            }
         //print("failed to submit response")
         })
    }
    
    @objc func resetCampaign() {
        followUpIterator = 0
        if(thankYouView != nil) {
            thankYouView.removeFromSuperview()
        }
    }
    @objc func closeButtonAction(sender:UIButton!) {
        closeCampaign()
        DBManager.instance.closeDB()
        
    }
    
    @objc func closeCampaign() {
        resetCampaign()
            switch(campaignViewType ?? 5) {
            case 0 :
                self.viewController.dismiss(animated: true, completion: nil)
                break
            case 1 :
                dialogView.removeFromSuperview()
                break
            case 2 :
                dialogView.removeFromSuperview()
                break
            default:
                break
            }
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func languageButtonAction(sender:UIButton!) {
        
        tableViewContainer.isHidden = !tableViewContainer.isHidden
    }
    
    // MARK:-
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return languages.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LanguageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "LanguageCell")
        cell.selectionStyle = .none
        cell.lblLanguage.text = languages[indexPath.row].name
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
        tableViewContainer.isHidden = !tableViewContainer.isHidden
        currentLang = indexPath.row
        let cell = tableViewLanguage.cellForRow(at: indexPath) as! LanguageTableViewCell
        cell.backgroundColor = UIColor.white
        cell.lblLanguage.textColor = primaryColor
        tableViewLanguage.reloadData()
        let languages = campaign?.settings?.translation!
        if(currentLanguage.language_code != languages![indexPath.row].language_code) {
            currentLanguage = languages![indexPath.row]
            btnLanguage.setTitle(currentLanguage.name, for: .normal)
            changeLanguage()
        }
    }
    
    func setCampaign(campaign:Campaign) {
        
        self.campaign = campaign
        if(!isColorSet && campaign.color_primary != nil) {
            primaryColor = getColorFromHex(hexString: campaign.color_primary!)
            setTheme(colorTheme: primaryColor, isColorPrimarySet: true)
        }
        currentQuestion = campaign.questions?[0]
        questionNumber = 1
        noOfQuestions = (campaign.questions?.count)!
        let questionCount: String = "\(questionNumber)/\(noOfQuestions)"
        lblQuestionCount.text = questionCount
        loadLanguages()
        btnLanguage.setTitle(currentLanguage.name, for: .normal)
        tableViewLanguage.reloadData()
        getStaticTexts()
        setStaticTexts()
        hideActivityIndicator()
        if(campaign.welcome_message_enabled!) {
            showHideWelcomeScreen(isShow: true)
        }
        showCampaignView()
        if(Reachability.isConnectedToNetwork()) {
            getDataFromUrl(url: URL(string:(campaign.biz?.img_url)!)!, completion: ({ (data, response, error) in
                if(data != nil)  {
                    DispatchQueue.main.async() {
                        let image = UIImage(data: data!)
                        self.imageViewBrand.image = image
                        self.lblBrand.text = campaign.biz?.name
                    }
                } else {
                    DispatchQueue.main.async() {
                        self.lblBrand.text = campaign.biz?.name
                    }
                }
                
            }))
        } else {
            self.lblBrand.text = campaign.biz?.name
        }
        initResponse()
    }
    
    
    func campaignErrorHandler() {
        hideActivityIndicator()
        showAlert()
        if(!isColorSet) {
            primaryColor = UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
            setTheme(colorTheme: primaryColor, isColorPrimarySet: true)
        } 
    }
    func showAlert() {
        if(viewController != nil) {
            let message = "Something unexpected happened. Please try again after sometime!!! "
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            viewController.present(alert, animated: true)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                alert.dismiss(animated: true)
                
            })
            alert.addAction(okButton)
            // duration in seconds
            let duration: Double = 5
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                alert.dismiss(animated: true)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 15.0
        sessionConfig.timeoutIntervalForResource = 15.0
        let session = URLSession(configuration: sessionConfig)
        session.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func loadLanguages() {
        languages = (campaign?.settings?.translation)!
        for language in languages {
            if(language.primary)! {
                currentLanguage = language
                primaryLanguage = language
                break
            }
        }
        
    }
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    @objc func adjustingHeight(show:Bool, notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        var changeInHeight:CGFloat = 0.0
        if(show) {
            changeInHeight = CGFloat((keyboardFrame.height) * -1 )
        } else {
            changeInHeight = CGFloat((keyboardFrame.height) * 1 )
        }
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant = changeInHeight
            self.topConstraint.constant = changeInHeight
            if(!show) {
                self.bottomConstraint.constant = 0
                self.topConstraint.constant  = 0
            }
        })
    }
    
    @objc func changeLanguage () {
        getStaticTexts()
        setStaticTexts()
        if(languageDelegate != nil) {
            languageDelegate.languageChanged(lang: currentLanguage)
        }
    }
    
    @objc func showThankYou() {
        if(campaign?.thankyou_message_enabled)! {
            initThankYouView()
            self.perform(#selector(closeCampaign), with: self, afterDelay: 3.0)
        } else {
            closeCampaign()
        }
    }
    
    @objc func initThankYouView() {
        removeSubViews(view: self.campaignView)
        nextPrevButtonView.isHidden = true
        thankYouView = UIView()
        contentView.addSubview(thankYouView)
        //thankYouView.backgroundColor = UIColor.gray
        thankYouView.translatesAutoresizingMaskIntoConstraints = false
        let txtThankYou = UITextView()
        txtThankYou.isEditable = false
        txtThankYou.translatesAutoresizingMaskIntoConstraints = false
        txtThankYou.textAlignment = .center
        thankYouView.addSubview(txtThankYou)
        txtThankYou.font = GlobalConstants.FONT_MEDIUM
        
        let chkContainer = UIView()
        
        txtThankYou.text = setThankYouMessage()
        chk = CheckBox(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        chkContainer.addSubview(chk)
        chkContainer.translatesAutoresizingMaskIntoConstraints = false
        thankYouView.addSubview(chkContainer)
        
        //ThankYouView constraints
        let thankYouCenterX = NSLayoutConstraint(item: thankYouView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let thankYouCenterY = NSLayoutConstraint(item: thankYouView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let thankYouLeading = NSLayoutConstraint(item: thankYouView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let thankYouTrailing = NSLayoutConstraint(item: thankYouView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let thankYouHeight = NSLayoutConstraint(item: thankYouView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 120.0)
        
        NSLayoutConstraint.activate([thankYouCenterX, thankYouCenterY, thankYouLeading, thankYouTrailing, thankYouHeight])
        
        //ThankYou TextView constraints
        
        let txtTop = NSLayoutConstraint(item: txtThankYou, attribute: .top, relatedBy: .equal, toItem: thankYouView, attribute: .top, multiplier: 1.0, constant: 65.0)
        
        
        let txtLeading = NSLayoutConstraint(item: txtThankYou, attribute: .leading, relatedBy: .equal, toItem: thankYouView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let txtTrailing = NSLayoutConstraint(item: txtThankYou, attribute: .trailing, relatedBy: .equal, toItem: thankYouView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let txtHeight = NSLayoutConstraint(item: txtThankYou, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 55.0)
        
        NSLayoutConstraint.activate([txtTop, txtLeading, txtTrailing, txtHeight])
        //checkmark constraints
        
        NSLayoutConstraint(item: chkContainer, attribute: .centerX, relatedBy: .equal, toItem: thankYouView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: chkContainer, attribute: .top, relatedBy: .equal, toItem: thankYouView, attribute: .top, multiplier: 1.0, constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: chkContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 60.0).isActive = true
        NSLayoutConstraint(item: chkContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,  multiplier: 1.0, constant: 60.0).isActive = true
        
        
        DispatchQueue.main.async() {
            self.chk.isTickShown = false
            self.chk.setColorPrimary(color: self.primaryColor)
            self.chk.showCheckMarkAnimation()
        }
    }
    
    
    @objc func setThankYouMessage() -> String {
        
        var strThankYou = String()
        switch (campaign?.type ?? "") {
        case "NPS":
            strThankYou = getNPSThankYou();
            break;
        case "SAT":
            strThankYou = getCSATCESThankYou();
            break;
        case "ES":
            strThankYou = getCSATCESThankYou();
            break;
        case "SURVEY":
            strThankYou = getSurveyThankYou();
            break;
        default:
            break
        }
        return strThankYou
    }
    
    @objc func getNPSThankYou() -> String {
        var strThankYou = String()
        let langCode = currentLanguage.language_code
        let thankYouTranslations = campaign?.thank_you_and_redirect_settings_translations
        for thankYouTranslation in thankYouTranslations! {
            if(langCode == thankYouTranslation.language_code) {
                let thankYouAndRedirectSettings = thankYouTranslation.text!
                switch(thankYouAndRedirectSettings.type ?? "") {
                case "all" :
                    strThankYou = (thankYouAndRedirectSettings.all?.message)!
                    break
                case "score" :
                    if(npsRating <= 6) {
                        strThankYou = (thankYouAndRedirectSettings.custom?.detractors?.message)!
                    } else if(npsRating <= 8) {
                        strThankYou = (thankYouAndRedirectSettings.custom?.passives?.message)!
                    } else {
                        strThankYou = (thankYouAndRedirectSettings.custom?.promoters?.message)!
                    }
                    break
                default:
                    break
                }
            }
        }
        return strThankYou
    }
    
    @objc func getSurveyThankYou() -> String {
        var strThankYou = String()
        let langCode = currentLanguage.language_code
        let thankYouTranslations = campaign?.thank_you_and_redirect_settings_translations
        for thankYouTranslation in thankYouTranslations! {
            if(langCode == thankYouTranslation.language_code) {
                let thankYouAndRedirectSettings = thankYouTranslation.text!
                strThankYou = (thankYouAndRedirectSettings.all?.message)!
            }
        }
        return strThankYou
    }
    
    @objc func getCSATCESThankYou() -> String {
        var strThankYou = String()
        let langCode = currentLanguage.language_code
        let thankYouTranslations = campaign?.thank_you_and_redirect_settings_translations
        for thankYouTranslation in thankYouTranslations! {
            if(langCode == thankYouTranslation.language_code) {
                let thankYouAndRedirectSettings = thankYouTranslation.text!
                switch(thankYouAndRedirectSettings.type ?? "") {
                case "all" :
                    strThankYou = (thankYouAndRedirectSettings.all?.message)!
                    break
                case "custom" :
                    let customThankYou = thankYouAndRedirectSettings.custom!
                    switch(cescsatOption) {
                    case "neutral" :
                        strThankYou = (customThankYou.neutral?.message)!
                        break
                    case "dissatisfied" :
                        strThankYou = (customThankYou.dissatisfied?.message)!
                        break
                    case "satisfied" :
                        strThankYou = (customThankYou.satisfied?.message!)!
                        break
                    case "agree" :
                        strThankYou = (customThankYou.agree?.message!)!
                        break
                    case "disagree" :
                        strThankYou = (customThankYou.disagree?.message!)!
                        break
                    default:
                        break
                        
                    }
                    break
                default:
                    break
                }
            }
        }
        return strThankYou
    }
    
    @objc func getStaticTexts() {
        //staticTexts = [String: String]()
        let staticTranslations = campaign?.static_texts
        var staticText = String()
        staticTexts.translation["CAMPAIGN_MODE_BACK_BUTTON_TEXT"] = ""
        for staticTranslation in staticTranslations! {
            if(currentLanguage.language_code == staticTranslation.language_code) {
                staticText = staticTranslation.text!
                switch(staticTranslation.static_text_id ?? "") {
                case "CAMPAIGN_MODE_BACK_BUTTON_TEXT":
                    staticTexts.translation["CAMPAIGN_MODE_BACK_BUTTON_TEXT"] = staticText
                    break;
                case "CAMPAIGN_MODE_NEXT_BUTTON_TEXT":
                    staticTexts.translation["CAMPAIGN_MODE_NEXT_BUTTON_TEXT"] = staticText
                    break;
                case "CAMPAIGN_MODE_START_BUTTON_TEXT":
                    staticTexts.translation["CAMPAIGN_MODE_START_BUTTON_TEXT"] = staticText
                    break;
                case "CAMPAIGN_MODE_SUBMIT_BUTTON_TEXT":
                    staticTexts.translation["CAMPAIGN_MODE_SUBMIT_BUTTON_TEXT"] = staticText
                    break;
                case "CHANGE_SCORE_BUTTON_TEXT":
                    staticTexts.translation["CHANGE_SCORE_BUTTON_TEXT"] = staticText
                    break;
                case "POWERED_BY":
                    staticTexts.translation["POWERED_BY"] = staticText
                    
                    break;
                case "SCORE_MESSAGE_TEXT":
                    staticTexts.translation["SCORE_MESSAGE_TEXT"] = staticText
                    
                    break;
                case "CAMPAIGN_MODE_EXIT_DIALOG_TEXT":
                    staticTexts.translation["CAMPAIGN_MODE_EXIT_DIALOG_TEXT"] = staticText
                    break;
                case "CAMPAIGN_MODE_ANSWER_REQUIRED_DIALOG_TEXT":
                    staticTexts.translation["CAMPAIGN_MODE_ANSWER_REQUIRED_DIALOG_TEXT"] = staticText
                    break;
                case "FOLLOW_UP_REQUEST_CHECKBOX_LABEL":
                    staticTexts.translation["FOLLOW_UP_REQUEST_CHECKBOX_LABEL"] = staticText
                    break;
                case "PLUGIN_DIALOGUE_BOX_ACTIVE_BUTTON_TEXT":
                    staticTexts.translation["PLUGIN_DIALOGUE_BOX_ACTIVE_BUTTON_TEXT"] = staticText
                    break;
                case "PLUGIN_DIALOGUE_BOX_PASSIVE_BUTTON_TEXT":
                    staticTexts.translation["PLUGIN_DIALOGUE_BOX_PASSIVE_BUTTON_TEXT"] = staticText
                    break;
                case "EMAIL_ADDRESS_PLACEHOLDER_TEXT":
                    staticTexts.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"] = staticText
                    break;
                case "INPUT_PLACEHOLDER_TEXT":
                    staticTexts.translation["INPUT_PLACEHOLDER_TEXT"] = staticText
                    break;
                case "VALIDATION_FAILED_TEXT":
                    staticTexts.translation["VALIDATION_FAILED_TEXT"] = staticText
                    break;
                case "WIDGET_WELCOME_TIP":
                    staticTexts.translation["WIDGET_WELCOME_TIP"] = staticText
                    break;
                case "MANDATORY_QUESTION_TEXT":
                    staticTexts.translation["MANDATORY_QUESTION_TEXT"] = staticText
                    break;
                case "EMAIL_NOT_VALID_TEXT":
                    staticTexts.translation["EMAIL_NOT_VALID_TEXT"] = staticText
                    break;
                default:
                    break;
                }
            }
            
        }
        
    }
    @objc func setStaticTexts() {
        if (noOfQuestions == 1 || questionNumber == noOfQuestions) {
            btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_SUBMIT_BUTTON_TEXT"], for: .normal)
        } else if (campaign?.type == "SURVEY") {
            if (followUpIterator == 2) {
                btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_SUBMIT_BUTTON_TEXT"], for: .normal)
            } else {
                btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_NEXT_BUTTON_TEXT"], for: .normal)
            }
        } else {
            btnNext.setTitle(staticTexts.translation["CAMPAIGN_MODE_NEXT_BUTTON_TEXT"], for: .normal)
        }
        
        btnPrev.setTitle(staticTexts.translation["CAMPAIGN_MODE_BACK_BUTTON_TEXT"], for: .normal)
        lblPoweredBy.text = staticTexts.translation["POWERED_BY"]
        
        if (btnStart != nil) {
            btnStart.setTitle(staticTexts.translation["CAMPAIGN_MODE_START_BUTTON_TEXT"], for: .normal)
        }
        if(txtWelcomeTip != nil && txtWelcomeMessage != nil) {
            txtWelcomeTip.text = staticTexts.translation["WIDGET_WELCOME_TIP"]
            txtWelcomeMessage.text = getWelcomeText()
        }
        if(currentValidationString != "") {
            txtValidation.text = staticTexts.translation[currentValidationString]
        }
    }
    
    @objc func getWelcomeText() -> String? {
        let welcomeTranslations = campaign?.welcome_message_translations
        var str:String?
        for welcomeTranslation in welcomeTranslations! {
            if(welcomeTranslation.language_code != nil && welcomeTranslation.language_code == currentLanguage.language_code) {
              str = welcomeTranslation.text
                break
            }
        }
        return str
    }
    
    @objc func showHideWelcomeScreen(isShow:Bool) {
        if(isShow) {
            txtWelcomeMessage.isHidden = false
            txtWelcomeTip.isHidden = false
        } else {
            txtWelcomeMessage.isHidden = true
            txtWelcomeTip.isHidden = true
        }
    }
    @objc func showActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        //activityIndicator.color = primaryColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        //constrinats
        
        NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        activityIndicator.startAnimating()
    }
    
    @objc func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("---------- time  in hide activity\(minutes) : \(seconds)")
    }
    
    //Handle Resposne
    
    @objc func initResponse() {
        let savedCampaign = getResponseFromDB()
        if(savedCampaign == nil) {
            response = Response()
            response.channel = "MOBILE-SDK"
            response.sub_channel = "IOS"
            response.biz_id = UInt(campaign?.biz_id ?? 0)
            response.campaign_id = campaign?.id
            response.started_at = CUnsignedLong(Date().timeIntervalSince1970 * 1000)
            if(response.response_answers == nil) {
                response.response_answers = [ResponseAnswer]()
            }
            
            let attr = LoyagramAttribute.getInstance().attributes
            if(attr.count > 0) {
                response.attr = attr
            }
            saveResponseToDB()
        }else if(savedCampaign?.campaign_id == campaign?.id) {
            response = savedCampaign
        } else {
            response = Response()
            response.channel = "MOBILE-SDK"
            response.sub_channel = "IOS"
            response.biz_id = UInt(campaign?.biz_id ?? 0)
            response.campaign_id = campaign?.id
            response.started_at = CUnsignedLong(Date().timeIntervalSince1970 * 1000)
            if(response.response_answers == nil) {
                response.response_answers = [ResponseAnswer]()
            }
            let attr = LoyagramAttribute.getInstance().attributes
            if(attr.count > 0) {
                response.attr = attr
            }
            saveResponseToDB()
        }
    }
    
    @objc func saveResponseToDB() {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(response)
        let stringResponse = String(data: data, encoding: .utf8)!
        //DBManager.instance.createTableResponse()
        DBManager.instance.insertResponseIntoDB(response: stringResponse)
    }
    
    @objc func deleteResponse() {
        if(DBManager.instance.deleteResponseFromDB()) {
        } else {
        }
    }
    func getResponseFromDB() ->Response? {
        if(DBManager.instance.getResponseFromDB() != nil) {
            let jsonData = DBManager.instance.getResponseFromDB()!.data(using: .utf8)!
            let decoder = JSONDecoder()
            let response = try! decoder.decode(Response.self, from: jsonData)
            return response
        }
        return nil
    }
    func getTintColor() -> UIColor? {
        let window: UIWindow = (UIApplication.shared.delegate?.window as? UIWindow)!
        return window.tintColor
    }
    
    func getColorFromHex(hexString: String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,blue: CGFloat(rgbValue & 0x0000FF) / 255.0,alpha: CGFloat(1.0)
        )
    }
    
    @objc func getTextResponse() -> String {
        var text = " "
        let responseAnswers:[ResponseAnswer] = response.response_answers
        for responseAnswer in responseAnswers {
            if(currentQuestion.id == responseAnswer.question_id) {
                text = (responseAnswer.response_answer_text?.text)!
                break
            }
        }
        return text
    }
    func isQuestionAttended(question:Question) -> Bool {
        let responseAnswers:[ResponseAnswer] = response.response_answers
        switch currentQuestion.type ?? "" {
        case "SINGLE_SELECT":
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_id) {
                    if(responseAnswer.answer > 0) {
                        return true
                    }
                }
            }
            break
        case "MULTI_SELECT":
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_label_id) {
                    if(responseAnswer.answer > 0) {
                        return true
                    }
                }
            }
            break
        case "RATING":
            var attendedCount = 0
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_label_id) {
                    if(responseAnswer.answer > 0) {
                        attendedCount += 1
                    }
                }
                if(attendedCount == question.labels?.count) {
                    return true
                }
            }
            break
        case "NPS":
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_id) {
                    return true
                }
            }
            break
        case "TEXT":
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_id) {
                    return true
                }
            }
            break
        case "PARAGRAPH":
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_id) {
                    return true
                }
            }
            break
        case "EMAIL":
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_id) {
                    return true
                }
            }
            break
        case "NUMBER":
            for responseAnswer in responseAnswers {
                if(question.id == responseAnswer.question_id) {
                    return true
                }
            }
            break
        default:
            return true
        }
        return false
        
    }
    
    @objc func isValidNumber(number:String) ->Bool {
        if(number.count < 6 )  {
            return false
        }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+"]
        return Set(number).isSubset(of: nums)
    }
    @objc func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
        
    }
}
