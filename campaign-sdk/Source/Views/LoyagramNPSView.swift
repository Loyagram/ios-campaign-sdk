//
//  LoyagramNPSView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 21/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

protocol LoyagramNPSDelegate: class {
    func setNPS()
}

class LoyagramNPSView: UIView, UITableViewDelegate, UITableViewDataSource, LoyagramCampaignButtonDelegate, UITextFieldDelegate, UITextViewDelegate, LoyagramLanguageDelegate {
    func languageChanged(lang: Language) {
        currentLanguage = lang
        setQuestion()
        setLikelyText()
        if(campaignType == "NPS") {
            setFeedBackQuestion()
            setFollowUpQuestion()
            changeLabelLanguage()
            chk.text = staticTextes.translation["FOLLOW_UP_REQUEST_CHECKBOX_LABEL"]
            chk.setNeedsDisplay()
            feedbackTextField.placeholder = staticTextes.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"]
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
    var staticTextes: StaticTextTranslation!
    var txtLikely: UITextView!
    var txtNotLikely: UITextView!
    
    public init(frame: CGRect, campaignType: String, question: Question, followUpQuestion: Question, currentLang: Language, primaryLang: Language, color: UIColor, campaignView: LoyagramCampaignView, bottomConstraint:NSLayoutConstraint, staticTextes: StaticTextTranslation) {
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
        self.staticTextes = staticTextes
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
        
        let langCode = currentLanguage.language_code
        let questionTranslations = currentQuestion.question_translations
        for questionTranslation in questionTranslations! {
            if(questionTranslation.language_code == langCode) {
                txtQuestion.text = questionTranslation.text
                break
            }
        }
    }
    
    @objc func setFollowUpQuestion() {
        let langCode = currentLanguage.language_code
        let questionTranslations = followUpQuestion.question_translations
        for questionTranslation in questionTranslations! {
            if(questionTranslation.language_code == langCode) {
                txtFollowUpQuestion.text = questionTranslation.text
                break
            }
        }
    }
    
    @objc func setFeedBackQuestion() {
        let langCode = currentLanguage.language_code
        let settingsTranslations = currentQuestion.settings_translations
        for sT in settingsTranslations! {
            if(sT.language_code == langCode) {
                let requestReasonSettings = sT.text.settings.nps_settings.request_reason_settings
                txtFeedBackQuestion.text = requestReasonSettings?.all.message
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
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)
        
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
        txtFollowUpQuestion.text = " "
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
        
        let containerHeight = NSLayoutConstraint(item: npsContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        
        let centerHorizontal = NSLayoutConstraint(item: npsContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        let centerVertical = NSLayoutConstraint(item: npsContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 30)
        
        NSLayoutConstraint.activate([containerWidth, containerHeight, centerHorizontal, centerVertical])
        
        txtLikely = UITextView()
        txtLikely.translatesAutoresizingMaskIntoConstraints = false
        txtLikely.font = GlobalConstants.FONT_MEDIUM
        txtLikely.textAlignment = .right
        //txtLikely.text = staticTextes.translation[""]
        
        txtNotLikely = UITextView()
        txtNotLikely.translatesAutoresizingMaskIntoConstraints = false
        txtNotLikely.font = GlobalConstants.FONT_MEDIUM
        txtNotLikely.textAlignment = .left
        //txtNotLikely.text = staticTextes.translation[""]
        
        npsContainer.addSubview(txtLikely)
        npsContainer.addSubview(txtNotLikely)
        setLikelyText()
        //Likely constraints
        
        NSLayoutConstraint(item: txtLikely, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130).isActive = true
        NSLayoutConstraint(item: txtLikely, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30).isActive = true
        
        NSLayoutConstraint(item: txtLikely, attribute: .right, relatedBy: .equal, toItem: npsContainer, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: txtLikely, attribute: .bottom, relatedBy: .equal, toItem: npsContainer, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        //NOt Likely constraints
        
        NSLayoutConstraint(item: txtNotLikely, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130).isActive = true
        NSLayoutConstraint(item: txtNotLikely, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30).isActive = true
        
        NSLayoutConstraint(item: txtNotLikely, attribute: .left, relatedBy: .equal, toItem: npsContainer, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: txtNotLikely, attribute: .bottom, relatedBy: .equal, toItem: npsContainer, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        var xPoint:CGFloat = 0
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
            npsButton.setTitleColor(primaryColor, for: .normal)
            npsButton.addTarget(self, action: #selector(npsButtonAction(sender:)), for: .touchUpInside)
            
        }
    }
    
    @objc func npsButtonAction (sender: UIButton) {
        if(delegate != nil) {
            delegate.setNPS()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("sdc")
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
        
        let chkContainer = UIView()
        chkContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let rect = CGRect(x: 0, y: 0, width: 320, height: 35)
        chk = LoyagramCheckBox(frame: rect)
        chk.showTextLabel = true
        chk.tag = 1001
        chk.text = staticTextes.translation["FOLLOW_UP_REQUEST_CHECKBOX_LABEL"]
        chk.addTarget(self, action: #selector(followUpCheckBoxAction(sender:)), for: .touchUpInside)
        chkContainer.addSubview(chk)
        feedbackTextField = UITextField()
        feedbackTextField.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextField.isHidden = true
        feedbackTextField.delegate = self
        feedbackTextField.autocorrectionType = .no
        feedbackTextField.placeholder = staticTextes.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"]
        
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
        
        let textFieldTop = NSLayoutConstraint(item: feedbackTextField, attribute: .top, relatedBy: .equal, toItem: chkContainer, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        
        let textFieldBottom = NSLayoutConstraint(item: feedbackTextField, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        
        let textFieldLeading = NSLayoutConstraint(item: feedbackTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textFieldTrailing = NSLayoutConstraint(item: feedbackTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textFieldHeight = NSLayoutConstraint(item: feedbackTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        
        NSLayoutConstraint.activate([textFieldTop, textFieldBottom, textFieldLeading, textFieldTrailing, textFieldHeight])
        
        setBorderForTextField()
        setFeedBackQuestion()
    }
    
    @objc func followUpCheckBoxAction (sender: LoyagramRadioButton) {
        
        feedbackTextField.isHidden = !feedbackTextField.isHidden
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(campaignType == "NPS") {
            //table View height
            let viewHeight = self.frame.height
            let requiredHeight = CGFloat(followUpQuestion.labels.count) * 35
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
    
    @objc func checkBoxAction (sender: LoyagramRadioButton) {
        
        
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
        
        return followUpQuestion.labels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    @objc func getMultiSelectCell(checkBoxContainer: UIView, row:Int) {
        let label = followUpQuestion.labels[row]
        let rect = CGRect(x: 0, y: 0, width: 220, height: 35)
        let chk = LoyagramCheckBox(frame: rect)
        chk.showTextLabel = true
        checkBoxContainer.addSubview(chk)
        chk.tag = label.id
        chk.addTarget(self, action: #selector(checkBoxAction(sender:)), for: .touchUpInside)
        let labelTranslations = label.label_translations
        let langCode = currentLanguage.language_code
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code == langCode) {
                chk.text = labelTranslation.text
                break
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        feedbackTextField.resignFirstResponder()
        return true
    }
    @objc func setLikelyText() {
        let settingsTransaltions = currentQuestion.settings_translations!
        for st in settingsTransaltions {
            if(st.language_code == currentLanguage.language_code) {
                let npsSettings = st.text.settings.nps_settings!
                    let widget = npsSettings.widget!
                    txtLikely.text = widget.very_likely
                    txtNotLikely.text = widget.not_likely
                break
                }
            }
        }
    @objc func changeLabelLanguage() {
        
        followUpTableView.reloadData()
    }
}
