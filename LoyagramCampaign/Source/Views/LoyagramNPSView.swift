//
//  LoyagramNPSView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 21/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

protocol LoyagramNPSDelegate: class {
    func setNPS(rating: Int!)
    func enableNPSFollowUp(enable:Bool)
    func setNPSFollowUpEmail(email:String)
}

class LoyagramNPSView: UIView, UITableViewDelegate, UITableViewDataSource, LoyagramCampaignButtonDelegate, UITextFieldDelegate, UITextViewDelegate, LoyagramLanguageDelegate {
    func languageChanged(lang: Language) {
        currentLanguage = lang
        setQuestion()
        setLikelyText()
        if(campaignType ?? "" == "NPS") {
            setFeedBackQuestion()
            setFollowUpQuestion()
            changeLabelLanguage()
            chk.text = staticTexts.translation["FOLLOW_UP_REQUEST_CHECKBOX_LABEL"] ?? ""
            chk.setNeedsDisplay()
            feedbackTextField.placeholder = staticTexts.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"] ?? ""
        }
        if(feedbackTextView != nil) {
            if feedbackTextView.text == placeHolderText {
                placeHolderText = staticTexts.translation["INPUT_PLACEHOLDER_TEXT"] ?? ""
                feedbackTextView.text = placeHolderText
                moveCursorToStart(txtView: feedbackTextView)
            } else {
                placeHolderText = staticTexts.translation["INPUT_PLACEHOLDER_TEXT"] ?? ""
            }
            
        }
    }
    
    var txtQuestion : UITextView!
    var txtFollowUpQuestion : UITextView!
    var txtFeedBackQuestion : UITextView!
    var currentQuestion : Question!
    var followUpQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var npsContainer : UIView!
    var followUpTableView : UITableView!
    //var feedbackContainer : UIView!
    var scrollView: UIScrollView!
    var chk: LoyagramCheckBox!
    var feedbackTextField: UITextField!
    var feedbackTextView:UITextView!
    var delegate: LoyagramNPSDelegate!
    var campaignView: LoyagramCampaignView!
    var campaignType: String!
    var tblHeight: NSLayoutConstraint!
    var feedBackContainerCenterY: NSLayoutConstraint!
    var scrollViewBottomConstraint : NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var heightConsraint: NSLayoutConstraint!
    var staticTexts: StaticTextTranslation!
    var txtLikely: UILabel!
    var txtNotLikely: UILabel!
    var response:Response!
    var currentRating: Int!
    var npsButtons : [UIButton]!
    var placeHolderText = ""
    
    public init(frame: CGRect, campaignType: String, question: Question, followUpQuestion: Question, currentLang: Language, primaryLang: Language, color: UIColor, campaignView: LoyagramCampaignView, bottomConstraint:NSLayoutConstraint, staticTexts: StaticTextTranslation, response:Response) {
        super.init(frame: frame)
        currentQuestion = question
        self.campaignType = campaignType
        self.followUpQuestion = followUpQuestion
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        self.campaignView = campaignView
        self.bottomConstraint = bottomConstraint
        self.campaignView.campaignButtonDelegate = self
        self.autoresizesSubviews = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.isUserInteractionEnabled = true
        self.campaignView.languageDelegate = self
        self.staticTexts = staticTexts
        self.response = response
        placeHolderText = staticTexts.translation["INPUT_PLACEHOLDER_TEXT"] ?? ""
        initNPSView()
        addNPSButtons()
        setQuestion()
        if(campaignType == "NPS") {
            initFeedbackView()
            initFollowUpView()
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setQuestion() {
        
        let langCode = currentLanguage.language_code ?? ""
        let questionTranslations = currentQuestion.question_translations
        for questionTranslation in questionTranslations! {
            if(questionTranslation.language_code != nil && questionTranslation.language_code == langCode) {
                txtQuestion.text = questionTranslation.text ?? ""
                break
            }
        }
    }
    
    @objc func setFollowUpQuestion() {
        let langCode = currentLanguage.language_code ?? ""
        let questionTranslations = followUpQuestion.question_translations
        for questionTranslation in questionTranslations! {
            if(questionTranslation.language_code != nil && questionTranslation.language_code == langCode) {
                txtFollowUpQuestion.text = questionTranslation.text ?? ""
                break
            }
        }
    }
    
    @objc func setFeedBackQuestion() {
        let langCode = currentLanguage.language_code ?? ""
        let settingsTranslations = currentQuestion.settings_translations
        for sT in settingsTranslations! {
            if(sT.language_code != nil && sT.language_code == langCode) {
                let requestReasonSettings = sT.text?.settings?.nps_settings?.request_reason_settings
                txtFeedBackQuestion.text = requestReasonSettings?.all?.message ?? ""
                break
            }
        }
    }
    
    @objc func initNPSView() {
        txtQuestion = UITextView()
        txtQuestion.isEditable = false
        //scrollView = UIScrollView()
        npsContainer = UIView()
        npsContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(npsContainer)
        
        self.addSubview(txtQuestion)
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = ""
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = GlobalConstants.FONT_MEDIUM
        
        //TextView Question constraints
        let txtQuestionBottom = NSLayoutConstraint(item: txtQuestion, attribute: .bottom, relatedBy: .equal, toItem: npsContainer, attribute: .top, multiplier: 1.0, constant: -5.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        NSLayoutConstraint.activate([txtQuestionBottom,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
    }
    
    @objc func initFollowUpView() {
        //ScrollView Question constraints
        followUpTableView = UITableView()
        txtFollowUpQuestion = UITextView()
        txtFollowUpQuestion.isEditable = false
        
        
        followUpTableView.isHidden = true
        followUpTableView.translatesAutoresizingMaskIntoConstraints = false
        txtFollowUpQuestion.isHidden = true
        self.addSubview(followUpTableView)
        self.addSubview(txtFollowUpQuestion)
        followUpTableView.delegate = self
        followUpTableView.dataSource = self
        followUpTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        followUpTableView.isScrollEnabled = true
        followUpTableView.bounces = false
        followUpTableView.separatorStyle = .none
        followUpTableView.allowsSelection = true;
        followUpTableView.isUserInteractionEnabled = true
        followUpTableView.showsVerticalScrollIndicator = false
        followUpTableView.showsHorizontalScrollIndicator = false
        
        txtFollowUpQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtFollowUpQuestion.text = ""
        txtFollowUpQuestion.textColor = UIColor.black
        txtFollowUpQuestion.textAlignment = .center
        txtFollowUpQuestion.font = GlobalConstants.FONT_MEDIUM
        
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .bottom, relatedBy: .equal, toItem: followUpTableView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        //Table View constrinats
        
        //let tableViewWidth =  NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        
        let tblLeading = NSLayoutConstraint(item: followUpTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let tblTrailing = NSLayoutConstraint(item: followUpTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let centerX = NSLayoutConstraint(item: followUpTableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: followUpTableView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 30.0)
        
        tblHeight = NSLayoutConstraint(item: followUpTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([tblLeading, tblTrailing, tblHeight, centerX, centerY])
        //followUpTableView.backgroundColor = UIColor.red
        
        setFollowUpQuestion()
    }
    
    @objc func addNPSButtons() {
        
        let buttonWidth:CGFloat = 25.0
        //NPS Container Constraints
        let containerWidth = NSLayoutConstraint(item: npsContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 295)
        
        let containerHeight = NSLayoutConstraint(item: npsContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 55)
        
        let centerHorizontal = NSLayoutConstraint(item: npsContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        let centerVertical = NSLayoutConstraint(item: npsContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 33)
        
        NSLayoutConstraint.activate([containerWidth, containerHeight, centerHorizontal, centerVertical])
        
        txtLikely = UILabel()
        txtLikely.translatesAutoresizingMaskIntoConstraints = false
        txtLikely.font = GlobalConstants.FONT_SMALL
        txtLikely.textAlignment = .right
        txtLikely.adjustsFontSizeToFitWidth = true
        
        txtNotLikely = UILabel()
        //txtNotLikely.adjustsFontSizeToFitWidth = true
        txtNotLikely.translatesAutoresizingMaskIntoConstraints = false
        txtNotLikely.font = GlobalConstants.FONT_SMALL
        txtNotLikely.textAlignment = .left
        //txtNotLikely.text = staticTextes.translation[""]
        
        npsContainer.addSubview(txtLikely)
        npsContainer.addSubview(txtNotLikely)
        setLikelyText()
        //Likely constraints
        
        NSLayoutConstraint(item: txtLikely, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 145).isActive = true
        NSLayoutConstraint(item: txtLikely, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30).isActive = true
        
        NSLayoutConstraint(item: txtLikely, attribute: .right, relatedBy: .equal, toItem: npsContainer, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: txtLikely, attribute: .bottom, relatedBy: .equal, toItem: npsContainer, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        //NOt Likely constraints
        
        NSLayoutConstraint(item: txtNotLikely, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 145).isActive = true
        NSLayoutConstraint(item: txtNotLikely, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30).isActive = true
        
        NSLayoutConstraint(item: txtNotLikely, attribute: .left, relatedBy: .equal, toItem: npsContainer, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: txtNotLikely, attribute: .bottom, relatedBy: .equal, toItem: npsContainer, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        var xPoint:CGFloat = 0
        npsButtons = [UIButton]()
        for i in 0..<11 {
            
            let frame = CGRect(x: CGFloat(xPoint), y: 0, width: buttonWidth, height: buttonWidth)
            let npsButton = UIButton(type: .system)
            npsButton.frame = frame
            xPoint += buttonWidth + 2
            npsButton.layer.cornerRadius = 0.5*buttonWidth
            npsButton.setTitle(String(i), for: .normal)
            npsButton.layer.borderWidth = 1.0
            npsButton.layer.borderColor = primaryColor.cgColor
            npsContainer.addSubview(npsButton)
            npsButton.tag = i + 1
            npsButton.setTitleColor(primaryColor, for: .normal)
            npsButton.addTarget(self, action: #selector(npsButtonAction(sender:)), for: .touchUpInside)
            npsButtons.append(npsButton)
            //
            let responseAnswer = getResponseAnswer(id: currentQuestion.id!)
            if(responseAnswer != nil) {
                if(responseAnswer?.answer != nil && i == responseAnswer?.answer) {
                  npsButton.backgroundColor = primaryColor
                  npsButton.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
    }
    
    @objc func npsButtonAction (sender: UIButton) {
        if(currentRating != nil) {
            if(self.viewWithTag(currentRating) as? UIButton != nil) {
                let button:UIButton = self.viewWithTag(currentRating) as! UIButton
                button.backgroundColor = UIColor.white
                button.setTitleColor(primaryColor, for: .normal)
            }
        }
        currentRating = sender.tag
        setNpsResponse(id: currentQuestion.id!, val: sender.tag - 1)
        saveResponseToDB()
        let responseAnswer = getResponseAnswer(id: currentQuestion.id!)
        if(responseAnswer != nil) {
            if(sender.tag - 1 == responseAnswer?.answer ?? -10) {
                sender.backgroundColor = primaryColor
                sender.setTitleColor(UIColor.white, for: .normal)
            }
        }
        if(delegate != nil && currentRating != nil) {
            delegate.setNPS(rating:currentRating - 1)
        }
    }
    
    func prevButtonPressed(iterator: Int) {
        switch iterator {
        case 0:
            break
        case 1:
            followUpTableView.isHidden = true
            txtFollowUpQuestion.isHidden = true
            npsContainer.isHidden = false
            txtQuestion.isHidden  = false
            break
        case 2:
            scrollView.isHidden = true
            followUpTableView.isHidden = false
            txtFollowUpQuestion.isHidden = false
            break
        default:
            break
        }
    }
    
    func nextButtonPressed(iterator: Int) {
        switch iterator {
        case 0:
            npsContainer.isHidden = true
            txtQuestion.isHidden  = true
            followUpTableView.isHidden = false
            txtFollowUpQuestion.isHidden = false
            break
        case 1:
            followUpTableView.isHidden = true
            txtFollowUpQuestion.isHidden = true
            scrollView.isHidden = false
            break
        case 2:
            break
        default:
            break
        }
    }
    
    @objc func initFeedbackView() {
        
        
        scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.isHidden = true
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = true;
        scrollView.delegate = self
        //scrollView.contentSize = CGSize(width: 250, height:200)
        //scrollView.backgroundColor = UIColor.blue
        
        txtFeedBackQuestion = UITextView()
        txtFeedBackQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtFeedBackQuestion.font = GlobalConstants.FONT_MEDIUM
        txtFeedBackQuestion.textAlignment = .center
        txtFeedBackQuestion.isEditable = false
        
        feedbackTextView = UITextView()
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.cornerRadius = 5
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView.delegate = self
        feedbackTextView.autocorrectionType = .no
        feedbackTextView.font = GlobalConstants.FONT_MEDIUM
        let currentText = getTextResponse()
        if(currentText != "") {
            feedbackTextView.text = currentText
        } else {
            placeHolderText = staticTexts.translation["INPUT_PLACEHOLDER_TEXT"] ?? ""
            applyPlaceholderStyle(textView: feedbackTextView, placeholderText: placeHolderText)
        }
        
        let chkContainer = UIView()
        chkContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let rect = CGRect(x: 0, y: 0, width: 320, height: 35)
        chk = LoyagramCheckBox(frame: rect, colorPrimary:primaryColor)
        chk.showTextLabel = true
        chk.tag = 1001
        chk.text = staticTexts.translation["FOLLOW_UP_REQUEST_CHECKBOX_LABEL"] ?? ""
        
        chk.addTarget(self, action: #selector(followUpCheckBoxAction(sender:)), for: .touchUpInside)
        chkContainer.addSubview(chk)
        feedbackTextField = UITextField()
        feedbackTextField.font = GlobalConstants.FONT_MEDIUM
        feedbackTextField.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextField.isHidden = true
        feedbackTextField.delegate = self
        feedbackTextField.autocorrectionType = .no
        feedbackTextField.placeholder = staticTexts.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"] ?? ""
        
        scrollView.addSubview(txtFeedBackQuestion)
        scrollView.addSubview(feedbackTextField)
        scrollView.addSubview(feedbackTextView)
        scrollView.addSubview(chkContainer)
        
        
        //ScroolView Constraint
        
        NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        heightConsraint = NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([heightConsraint])
        
        
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtFeedBackQuestion, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 5.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtFeedBackQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtFeedBackQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtFeedBackQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        
        //TextField Constraints
        let textViewTop = NSLayoutConstraint(item: feedbackTextView, attribute: .top, relatedBy: .equal, toItem: txtFeedBackQuestion, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        
        let textViewLeading = NSLayoutConstraint(item: feedbackTextView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textViewTrailing = NSLayoutConstraint(item: feedbackTextView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textViewHeight = NSLayoutConstraint(item: feedbackTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65.0)
        
        NSLayoutConstraint.activate([textViewTop,textViewLeading, textViewTrailing, textViewHeight])
        
        
        
        //CheckBox Constraints
        let chkTop = NSLayoutConstraint(item: chkContainer, attribute: .top, relatedBy: .equal, toItem: feedbackTextView, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        
        let chkLeading = NSLayoutConstraint(item: chkContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        //let chkTrailing = NSLayoutConstraint(item: chkContainer, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        
        let chkWidth = NSLayoutConstraint(item: chkContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 320.0)
        let chkHeight = NSLayoutConstraint(item: chkContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        NSLayoutConstraint.activate([chkTop,chkLeading, chkWidth, chkHeight])
        
        //TextField Constraints
        
        let textFieldTop = NSLayoutConstraint(item: feedbackTextField, attribute: .top, relatedBy: .equal, toItem: chkContainer, attribute: .bottom, multiplier: 1.0, constant: 20.0)
        
        let textFieldBottom = NSLayoutConstraint(item: feedbackTextField, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        
        let textFieldLeading = NSLayoutConstraint(item: feedbackTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textFieldTrailing = NSLayoutConstraint(item: feedbackTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textFieldHeight = NSLayoutConstraint(item: feedbackTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        
        NSLayoutConstraint.activate([textFieldTop, textFieldBottom, textFieldLeading, textFieldTrailing, textFieldHeight])
        
        setBorderForTextField()
        setFeedBackQuestion()
    }
    
    @objc func followUpCheckBoxAction (sender: LoyagramCheckBox) {
        if(sender.isChecked) {
            if(delegate != nil) {
                delegate.enableNPSFollowUp(enable: true)
            }
            
        } else {
            if(delegate != nil) {
                delegate.enableNPSFollowUp(enable: false)
            }
            if(response.email != nil) {
                response.email = ""
            }
        }
        feedbackTextField.isHidden = !feedbackTextField.isHidden
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(campaignType ?? "" == "NPS") {
            //table View height
            let viewHeight = self.frame.height
            let requiredHeight = CGFloat(followUpQuestion.labels?.count ?? 0) * 35
            if(requiredHeight <= viewHeight - 60) {
                tblHeight.constant = requiredHeight
            } else {
                tblHeight.constant = viewHeight - 60
            }
            //scrollview height
            let scrollViewHeight:CGFloat = 180.0
            if(viewHeight <= scrollViewHeight) {
                heightConsraint.constant = viewHeight
            } else {
                heightConsraint.constant = scrollViewHeight
            }
            setBorderForTextField()
        }
    }
    
    @objc func setBorderForTextField() {
        let borderLayer:CALayer = CALayer()
        let width = CGFloat(1.0)
        borderLayer.borderColor = UIColor.lightGray.cgColor
        borderLayer.frame = CGRect(x: 0, y: feedbackTextField.frame.size.height - width, width:  feedbackTextField.frame.size.width, height: feedbackTextField.frame.size.height)
        borderLayer.borderWidth = width
        feedbackTextField.layer.addSublayer(borderLayer)
        feedbackTextField.layer.masksToBounds = true
        
    }
    
    @objc func checkBoxAction (sender: LoyagramCheckBox) {
        if(sender.isChecked) {
            setMultiSelectResponse(id: CUnsignedLong(sender.tag), val: 1)
        } else {
            setMultiSelectResponse(id: CUnsignedLong(sender.tag), val: 0)
        }
        saveResponseToDB()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LanguageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.selectionStyle = .none
        //ContentView constrinats
        
        let cellContent = UIView()
        cell.contentView.addSubview(cellContent)
        cellContent.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: cellContent, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: cellContent, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let cellContentWidth = NSLayoutConstraint(item: cellContent, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 220.0)
        
        let cellContentHeight = NSLayoutConstraint(item: cellContent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
        
        NSLayoutConstraint.activate([cellContentWidth, cellContentHeight, centerX, centerY])
        
        getMultiSelectCell(checkBoxContainer: cellContent, row: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return followUpQuestion.labels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    @objc func getMultiSelectCell(checkBoxContainer: UIView, row:Int) {
        let label = followUpQuestion.labels?[row]
        let rect = CGRect(x: 0, y: 0, width: 220, height: 35)
        let chk = LoyagramCheckBox(frame: rect, colorPrimary:primaryColor)
        chk.showTextLabel = true
        checkBoxContainer.addSubview(chk)
        chk.tag = Int(label?.id ?? 0)
        chk.addTarget(self, action: #selector(checkBoxAction(sender:)), for: .touchUpInside)
        let labelTranslations = label?.label_translations
        let langCode = currentLanguage.language_code ?? ""
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code != nil && labelTranslation.language_code == langCode) {
                chk.text = labelTranslation.text ?? ""
                break
            }
        }
        
        let responseAnswer = getMulResponseAnswer(id: (label?.id!)!)
        if(responseAnswer != nil) {
            chk.isChecked = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        feedbackTextField.resignFirstResponder()
        return true
    }
    @objc func setLikelyText() {
        let settingsTransaltions = currentQuestion.settings_translations!
        for st in settingsTransaltions {
            if(st.language_code != nil && currentLanguage.language_code != nil && st.language_code == currentLanguage.language_code) {
                let npsSettings = st.text?.settings?.nps_settings!
                if(npsSettings == nil) {
                    break
                }
                let widget = npsSettings?.widget!
                txtLikely.text = widget?.very_likely ?? ""
                txtNotLikely.text = widget?.not_likely ?? ""
                break
                }
            }
        }
    @objc func changeLabelLanguage() {
        followUpTableView.reloadData()
    }
    
    func getResponseAnswer(id:CUnsignedLong) ->ResponseAnswer! {
        if(response.response_answers.count > 0) {
            for ra in response.response_answers {
                if(ra.question_id != nil && ra.question_id == id) {
                    return ra
                }
            }
        }
        return nil
    }
    
    func getMulResponseAnswer(id:CUnsignedLong) ->ResponseAnswer! {
        if(response.response_answers.count > 0) {
            for ra in response.response_answers {
                if (ra.question_label_id != nil && ra.question_label_id == id) {
                    return ra
                }
            }
        }
        return nil
    }
    
    func getNewResponseAnswer(questionId: UInt!) -> ResponseAnswer {
        let responseAnswer = ResponseAnswer()
        responseAnswer.biz_id = response.biz_id
        responseAnswer.biz_loc_id  = response.location_id
        responseAnswer.biz_user_id = response.user_id
        responseAnswer.campaign_id = response.campaign_id
        responseAnswer.response_id = response.id
        responseAnswer.question_id = questionId
        responseAnswer.at = CUnsignedLong(Date().timeIntervalSince1970 * 1000)
        responseAnswer.id = UUID().uuidString
        return responseAnswer
    }
    
    func setNpsResponse(id: CUnsignedLong, val:Int) {
        let answer = getResponseAnswer(id: id)
        if(answer != nil) {
            answer?.answer = val
        } else {
            let ra = getNewResponseAnswer(questionId:currentQuestion.id)
            ra.question_id = id
            ra.answer = Int(val)
            let responseAnswerText = ResponseAnswerText()
            responseAnswerText.response_answer_id = ra.id ?? ""
            ra.response_answer_text = responseAnswerText
            response.response_answers.append(ra)
        }
    }
    
    func setMultiSelectResponse(id: CUnsignedLong, val:Int) {
        let answer = getMulResponseAnswer(id: id)
        if(answer != nil) {
            if(val == 1) {
                answer?.answer = Int(id)
            } else {
                let index = response.response_answers.index(where:{$0 === answer!})
                response.response_answers.remove(at: index!)
            }
        } else {
            let ra = getNewResponseAnswer(questionId:followUpQuestion.id)
            ra.question_label_id = id
            ra.answer = Int(id)
            response.response_answers.append(ra)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (range.length > 1) {
            return false
        }
        if(textView.text == placeHolderText && text == "" && range.length == 0) {
            return true
        }
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            // check if the only text is the placeholder and remove it if needed
            if textView.text == placeHolderText {
                applyNonPlaceholderStyle(textView: feedbackTextView)
                textView.text = ""
            }
        } else if(newLength == 0 && textView.text != placeHolderText) {
            applyPlaceholderStyle(textView: textView, placeholderText: placeHolderText)
            moveCursorToStart(txtView: textView)
        }
        
        return true
    }
    
    @objc func getTextResponse() -> String {
        var text = ""
        let responseAnswers:[ResponseAnswer] = response.response_answers
        for responseAnswer in responseAnswers {
            if(responseAnswer.question_id != nil && currentQuestion.id != nil && currentQuestion.id == responseAnswer.question_id) {
                text = responseAnswer.response_answer_text?.text ?? ""
                break
            }
        }
        return text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let textViewText = textView.text
         let response = getResponseAnswer(id: currentQuestion.id!)
        if(textViewText != placeHolderText) {
            if (response?.response_answer_text != nil) {
                response?.response_answer_text?.text = textViewText
            }
            
        } else {
            if (response?.response_answer_text != nil) {
                response?.response_answer_text?.text = ""
            }
        }
        saveResponseToDB()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            response.email = txtAfterUpdate
            if(delegate != nil) {
                delegate.setNPSFollowUpEmail(email: txtAfterUpdate)
            }
            saveResponseToDB()
        }
        return true
    }
    
    @objc func saveResponseToDB() {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(response)
        let stringResponse = String(data: data, encoding: .utf8)!
        DBManager.instance.createTableResponse()
        DBManager.instance.insertResponseIntoDB(response: stringResponse)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == staticTexts.translation["INPUT_PLACEHOLDER_TEXT"] ?? "" {
            // move cursor to start
            moveCursorToStart(txtView:textView)
        }
        return true
    }
    
    func applyPlaceholderStyle(textView: UITextView, placeholderText: String) {
        // make it look (initially) like a placeholder
        textView.textColor = .lightGray
        textView.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(textView: UITextView) {
        // make it look like normal text instead of a placeholder
        textView.textColor = .black
        textView.alpha = 1.0
    }
    
    func moveCursorToStart(txtView: UITextView) {
        DispatchQueue.main.async() {
            self.feedbackTextView.selectedRange = NSMakeRange(0, 0)
        }
    }
}
