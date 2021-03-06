//
//  LoyagramCSATCESView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 21/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit


protocol LoyagramCSATCESDelegate: class {
    func setOptions(option:String!)
    func enableCSATCESFollowUp(enable:Bool)
    func setCSATCESFollowUpEmail(email:String)
}

class LoyagramCSATCESView: UIView, LoyagramCampaignButtonDelegate, UITableViewDelegate, UITableViewDataSource, LoyagramLanguageDelegate, UITextViewDelegate, UITextFieldDelegate {
    func languageChanged(lang: Language) {
        self.currentLanguage = lang
        setQuestion()
        changeFollowUpLabelLanguage()
        setFollowUpQuestion()
        setFeedBackQuestion()
        changeLabelLanguage()
        chk.text = staticTexts.translation["FOLLOW_UP_REQUEST_CHECKBOX_LABEL"] ?? ""
        chk.setNeedsDisplay()
        feedbackTextField.placeholder = staticTexts.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"] ?? ""
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
    var txtQuestion: UITextView!
    var txtFollowUpQuestion : UITextView!
    var txtFeedbackQuestion : UITextView!
    var currentQuestion : Question!
    var followUpQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var isCSAT: Bool = true
    var csatcesTableView: UITableView!
    var followUpScrollView : UIScrollView!
    var feedbackContainer : UIView!
    var chk: LoyagramCheckBox!
    var feedbackTextField: UITextField!
    var feedbackTextView:UITextView!
    var campaignView: LoyagramCampaignView!
    var delegate: LoyagramCSATCESDelegate!
    var noOfRows: Int!
    var tblHeight: NSLayoutConstraint!
    var scrollViewHeight: NSLayoutConstraint!
    var csatcesScrollView: UIScrollView!
    var isFollowUp : Bool!
    var radioGroup = [LoyagramRadioButton]()
    var staticTexts : StaticTextTranslation!
    var response: Response!
    var csatcesOption = "nuetral"
    var placeHolderText = ""
    
    public init(frame: CGRect, question: Question, followUpQuestion: Question, currentLang: Language, primaryLang: Language, color: UIColor, isCSAT: Bool, campaignView:LoyagramCampaignView, staticTexts: StaticTextTranslation, response:Response) {
        super.init(frame: frame)
        currentQuestion = question
        self.followUpQuestion = followUpQuestion
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        self.isCSAT = isCSAT
        self.campaignView = campaignView
        self.campaignView.campaignButtonDelegate =  self
        self.campaignView.languageDelegate = self
        noOfRows = question.labels?.count
        isFollowUp = false
        self.staticTexts = staticTexts
        self.response = response
        placeHolderText = staticTexts.translation["INPUT_PLACEHOLDER_TEXT"] ?? ""
        csatcesOption = String()
        initCSATCESView()
        initFollowUpView()
        setQuestion()
        initFeedbackView()
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
        
        let langCode = currentLanguage.language_code
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
                //txtFollowUpQuestion.text = questionTranslation.text
                if(isCSAT) {
                    let requestReasonSettings = sT.text?.settings?.csat_settings?.request_reason_settings
                    if(requestReasonSettings != nil) {
                        txtFeedbackQuestion.text = requestReasonSettings?.all?.message ?? ""
                    }
                } else {
                    let requestReasonSettings = sT.text?.settings?.ces_settings?.request_reason_settings
                    if(requestReasonSettings != nil) {
                        txtFeedbackQuestion.text = requestReasonSettings?.all?.message ?? ""
                    }
                }
                break
            }
        }
    }
    
    @objc func initCSATCESView() {
        txtQuestion = UITextView()
        txtQuestion.isEditable = false
        csatcesTableView = UITableView()
        csatcesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(csatcesTableView)
        self.addSubview(txtQuestion)
        csatcesTableView.delegate = self
        csatcesTableView.dataSource = self
        csatcesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        csatcesTableView.isScrollEnabled = true
        csatcesTableView.bounces = false
        csatcesTableView.separatorStyle = .none
        csatcesTableView.allowsSelection = true;
        csatcesTableView.isUserInteractionEnabled = true
        csatcesTableView.showsVerticalScrollIndicator = false
        csatcesTableView.showsHorizontalScrollIndicator = false
        
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = ""
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = GlobalConstants.FONT_MEDIUM
        
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .bottom, relatedBy: .equal, toItem: csatcesTableView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        //Table View constrinats
        
        //let tableViewWidth =  NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        
        let tblLeading = NSLayoutConstraint(item: csatcesTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let tblTrailing = NSLayoutConstraint(item: csatcesTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let centerX = NSLayoutConstraint(item: csatcesTableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: csatcesTableView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 30.0)
        
        tblHeight = NSLayoutConstraint(item: csatcesTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([tblLeading, tblTrailing, tblHeight, centerX, centerY])
        
    }
    
    @objc func initFollowUpView() {
        
        txtFollowUpQuestion = UITextView()
        txtFollowUpQuestion.isEditable = false
        txtFollowUpQuestion.isHidden = true
        self.addSubview(txtFollowUpQuestion)
        txtFollowUpQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtFollowUpQuestion.font = GlobalConstants.FONT_MEDIUM
        txtFollowUpQuestion.textAlignment = .center
        
        let txtQuestionTop = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .bottom, relatedBy: .equal, toItem: csatcesTableView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        setFollowUpQuestion()
    }
    
    @objc func initFeedbackView() {
        
        csatcesScrollView = UIScrollView()
        self.addSubview(csatcesScrollView)
        csatcesScrollView.isHidden = true
        csatcesScrollView.bounces = false
        csatcesScrollView.translatesAutoresizingMaskIntoConstraints = false
        csatcesScrollView.isScrollEnabled = true
        csatcesScrollView.isUserInteractionEnabled = true
        csatcesScrollView.showsVerticalScrollIndicator = true;
        csatcesScrollView.delegate = self
        //scrollView.contentSize = CGSize(width: 250, height:200)
        //scrollView.backgroundColor = UIColor.blue
        
        txtFeedbackQuestion = UITextView()
        txtFeedbackQuestion.isEditable = false
        txtFeedbackQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtFeedbackQuestion.font = GlobalConstants.FONT_MEDIUM
        txtFeedbackQuestion.textAlignment = .center
        
        
        feedbackTextView = UITextView()
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.cornerRadius = 5
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView.autocorrectionType = .no
        feedbackTextView.delegate = self
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
        chk.text = staticTexts.translation["FOLLOW_UP_REQUEST_CHECKBOX_LABEL"] ?? ""
        chk.addTarget(self, action: #selector(followUpCheckBoxAction(sender:)), for: .touchUpInside)
        chk.tag = 1001
        chkContainer.addSubview(chk)
        let chkGesture = UITapGestureRecognizer(target: self, action: #selector(followUpTextFieldAction))
        chkGesture.numberOfTapsRequired = 1
        chkContainer.addGestureRecognizer(chkGesture)
        feedbackTextField = UITextField()
        feedbackTextField.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextField.isHidden = true
        feedbackTextField.autocorrectionType = .no
        feedbackTextField.placeholder = staticTexts.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"] ?? ""
        feedbackTextField.delegate = self
        
        csatcesScrollView.addSubview(txtFeedbackQuestion)
        csatcesScrollView.addSubview(feedbackTextField)
        csatcesScrollView.addSubview(feedbackTextView)
        csatcesScrollView.addSubview(chkContainer)
        
        
        //ScroolView Constraint
        
        NSLayoutConstraint(item: csatcesScrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: csatcesScrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: csatcesScrollView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: csatcesScrollView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        scrollViewHeight = NSLayoutConstraint(item: csatcesScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scrollViewHeight])
        
        
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtFeedbackQuestion, attribute: .top, relatedBy: .equal, toItem: csatcesScrollView, attribute: .top, multiplier: 1.0, constant: 5.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtFeedbackQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtFeedbackQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtFeedbackQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        
        //TextField Constraints
        let textViewTop = NSLayoutConstraint(item: feedbackTextView, attribute: .top, relatedBy: .equal, toItem: txtFeedbackQuestion, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        
        let textViewLeading = NSLayoutConstraint(item: feedbackTextView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textViewTrailing = NSLayoutConstraint(item: feedbackTextView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textViewHeight = NSLayoutConstraint(item: feedbackTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65.0)
        
        NSLayoutConstraint.activate([textViewTop,textViewLeading, textViewTrailing, textViewHeight])
        
        
        
        //CheckBox Constraints
        let chkTop = NSLayoutConstraint(item: chkContainer, attribute: .top, relatedBy: .equal, toItem: feedbackTextView, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        
        let chkLeading = NSLayoutConstraint(item: chkContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let chkWidth = NSLayoutConstraint(item: chkContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 320.0)
        let chkHeight = NSLayoutConstraint(item: chkContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        NSLayoutConstraint.activate([chkTop,chkLeading, chkWidth, chkHeight])
        
        //TextField Constraints
        
        let textFieldTop = NSLayoutConstraint(item: feedbackTextField, attribute: .top, relatedBy: .equal, toItem: chkContainer, attribute: .bottom, multiplier: 1.0, constant: 20.0)
        
        let textFieldBottom = NSLayoutConstraint(item: feedbackTextField, attribute: .bottom, relatedBy: .equal, toItem: csatcesScrollView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        
        let textFieldLeading = NSLayoutConstraint(item: feedbackTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textFieldTrailing = NSLayoutConstraint(item: feedbackTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textFieldHeight = NSLayoutConstraint(item: feedbackTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        
        NSLayoutConstraint.activate([textFieldTop, textFieldBottom, textFieldLeading, textFieldTrailing, textFieldHeight])
        
        setBorderForTextField()
        setFeedBackQuestion()
    }
    
    @objc func followUpCheckBoxAction (sender: LoyagramCheckBox) {
       /*
        if(sender.isChecked) {
            if(delegate != nil) {
                delegate.enableCSATCESFollowUp(enable: true)
            }
        } else {
            if(delegate != nil) {
                delegate.enableCSATCESFollowUp(enable: false)
            }
            if(response.email != nil) {
                response.email = ""
            }
        }
        feedbackTextField.isHidden = !feedbackTextField.isHidden
        */
    }
    
    @objc func followUpTextFieldAction () {
        let chk = self.viewWithTag(1001) as? LoyagramCheckBox
        if chk != nil {
            if(chk?.isChecked)! {
                chk?.isChecked = false
                if(delegate != nil) {
                    delegate.enableCSATCESFollowUp(enable: false)
                }
                
            } else {
                chk?.isChecked = true
                if(delegate != nil) {
                    delegate.enableCSATCESFollowUp(enable: true)
                }
                if(response.email != nil) {
                    response.email = ""
                }
            }
            chk?.setNeedsDisplay()
            feedbackTextField.isHidden = !feedbackTextField.isHidden
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewHeight = self.frame.height
        let requiredHeight = CGFloat(noOfRows) * 35
        if(requiredHeight <= viewHeight - 60) {
            tblHeight.constant = requiredHeight
        } else {
            tblHeight.constant = viewHeight - 60
        }
        //let scrollViewHeight:CGFloat = 150.0
        if(viewHeight <= 180) {
            scrollViewHeight.constant = viewHeight
        } else {
            scrollViewHeight.constant = 180.0
        }
        setBorderForTextField()
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

    
    @objc func radioButtonAction (sender: LoyagramRadioButton) {
        radioGroup.forEach {
            $0.isSelected = false
        }
        sender.isSelected = !sender.isSelected
        setCSATCESResponse(id: CUnsignedLong(sender.labelId), val: 1)
        saveResponseToDB()
        switch(sender.csatcesOption) {
        case "very_dissatisfied":
            csatcesOption = "dissatisfied"
            break
        case "somewhat_dissatisfied":
            csatcesOption = "dissatisfied"
            break
        case "neither_satisfied_nor_dissatisfied":
            csatcesOption = "neutral"
            break
        case "somewhat_satisfied":
            csatcesOption = "satisfied"
            break
        case "very_satisfied":
            csatcesOption = "satisfied"
            break
        case "agree":
            csatcesOption = "agree"
            break
        case "somewhat_agree":
            csatcesOption = "agree"
            break
        case "neither_agree_nor_disagree":
            csatcesOption = "neutral"
            break
        case "somewhat_disagree":
            csatcesOption = "disagree"
            break
        case "disagree":
            csatcesOption = "disagree"
            break
        default:
            break
        }
        if(delegate != nil) {
            delegate.setOptions(option:csatcesOption)
        }
        
    }
    
    func prevButtonPressed(iterator: Int) {
        switch iterator {
        case 0:
            break
        case 1:
            isFollowUp = false
            txtQuestion.isHidden = false
            txtFollowUpQuestion.isHidden = true
            noOfRows = currentQuestion.labels?.count ?? 0
            csatcesTableView.reloadData()
            self.layoutSubviews()
            break
        case 2:
            csatcesScrollView.isHidden = true
            isFollowUp = true
            noOfRows = followUpQuestion.labels?.count ?? 0
            txtFollowUpQuestion.isHidden = false
            csatcesTableView.isHidden = false
            csatcesTableView.reloadData()
            self.layoutSubviews()
            break
        default:
            break
        }
    }
    
    func nextButtonPressed(iterator: Int) {
        switch iterator {
        case 0:
            isFollowUp = true
            noOfRows = followUpQuestion.labels?.count ?? 0
            txtFollowUpQuestion.isHidden = false
            txtQuestion.isHidden = true
            csatcesTableView.reloadData()
            self.layoutSubviews()
            break
        case 1:
            txtFollowUpQuestion.isHidden = true
            csatcesTableView.isHidden = true
            csatcesScrollView.isHidden = false
            break
        case 2:
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = LanguageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        cell.selectionStyle = .none
        
        //ContentView constrinats
        
        let cellContent = UIView()
        
        cell.contentView.addSubview(cellContent)
        
        cell.contentView.isUserInteractionEnabled = false
        cellContent.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: cellContent, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: cellContent, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let cellContentWidth = NSLayoutConstraint(item: cellContent, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 220.0)
        
        let cellContentHeight = NSLayoutConstraint(item: cellContent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([cellContentWidth, cellContentHeight, centerX, centerY])
        
        if(!isFollowUp) {
            getSingleSelectCell(radioButtonContainer: cellContent, row: indexPath.row)
        } else {
            getMultiSelectCell(checkBoxContainer: cellContent, row: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return noOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell != nil) {
            let cellSubViews = (cell?.contentView.subviews)!
            if(!isFollowUp) {
                for subView in cellSubViews {
                    if !(subView is UILabel) {
                        let radioButtonSubViews = subView.subviews
                        for sv in radioButtonSubViews {
                            if (sv is LoyagramRadioButton) {
                                let button = sv as! LoyagramRadioButton
                                radioButtonAction(sender: button)
                            }
                        }
                        
                    }
                }
            } else {
                for subView in cellSubViews {
                    if !(subView is UILabel) {
                        let chkSubViews = subView.subviews
                        for sv in chkSubViews {
                            if (sv is LoyagramCheckBox) {
                                let button = sv as! LoyagramCheckBox
                                button.isChecked = !button.isChecked
                                button.setNeedsDisplay()
                                checkBoxAction(sender: button)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    @objc func getSingleSelectCell(radioButtonContainer: UIView, row:Int) {
        
        let label = currentQuestion.labels?[row]
        let rect = CGRect(x: 0, y: 10, width: 20, height: 20)
        let radioButton = LoyagramRadioButton(frame: rect, primaryColor: primaryColor)
        radioButtonContainer.addSubview(radioButton)
        let radioLabel = UILabel()
        radioButtonContainer.addSubview(radioLabel)
        //radioButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioLabel.translatesAutoresizingMaskIntoConstraints = false
        radioLabel.tag = Int(label?.id ?? 0)
        radioButton.labelId = Int(label?.id ?? 0)
        radioButton.csatcesOption = label?.name ?? ""
        
        let ra = getResponseAnswer(id: label?.id ?? 0)
        if(ra != nil && ra?.question_label_id != nil && label?.id != nil && ra?.question_label_id == label?.id) {
            radioButton.isSelected = true
        }
        
        //Radio button cosntraints
        
        let radioTop = NSLayoutConstraint(item: radioButton, attribute: .top, relatedBy: .equal, toItem: radioButtonContainer, attribute: .top, multiplier: 1.0, constant: 6.0)
        
        let radioLeading = NSLayoutConstraint(item: radioButton, attribute: .leading, relatedBy: .equal, toItem: radioButtonContainer, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let radioWidth = NSLayoutConstraint(item: radioButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
        let radioHeight = NSLayoutConstraint(item: radioButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
        
        
        NSLayoutConstraint.activate([radioTop, radioLeading, radioWidth, radioHeight])
        
        //Radio label Constraints
        let labelTop = NSLayoutConstraint(item: radioLabel, attribute: .top, relatedBy: .equal, toItem: radioButtonContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
        let labelLeading = NSLayoutConstraint(item: radioLabel, attribute: .leading, relatedBy: .equal, toItem: radioButton, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        let labelTrailing = NSLayoutConstraint(item: radioLabel, attribute: .trailing, relatedBy: .equal, toItem: radioButtonContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let labelHeight = NSLayoutConstraint(item: radioLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
        
        
        NSLayoutConstraint.activate([labelTop,labelLeading, labelTrailing, labelHeight])
        //radioButton.addTarget(self, action: #selector(radioButtonAction(sender:)), for: .touchUpInside)
        radioGroup.append(radioButton)
        
        let labelTranslations = label?.label_translations
        let langCode = currentLanguage.language_code ?? ""
        
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code != nil && labelTranslation.language_code == langCode) {
                radioLabel.text = labelTranslation.text ?? ""
                break
            }
        }
        
    }
    @objc func getMultiSelectCell(checkBoxContainer: UIView, row:Int) {
        let label = followUpQuestion.labels?[row]
        let rect = CGRect(x: 0, y: 0, width: 220, height: 35)
        let chk = LoyagramCheckBox(frame: rect, colorPrimary:primaryColor)
        chk.showTextLabel = true
        chk.tag = Int(label?.id ?? 0)
        checkBoxContainer.addSubview(chk)
        //chk.addTarget(self, action: #selector(checkBoxAction(sender:)), for: .touchUpInside)
        let labelTranslations = label?.label_translations
        let langCode = currentLanguage.language_code ?? ""
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code != nil && labelTranslation.language_code == langCode) {
                chk.text = labelTranslation.text ?? ""
                break
            }
        }
        
        let responseAnswer = getMulResponseAnswer(id: label?.id ?? 0)
        if(responseAnswer != nil) {
            chk.isChecked = true
        }
        
    }
    @objc func checkBoxAction (sender: LoyagramCheckBox) {
        if(sender.isChecked) {
            setMultiSelectResponse(id: CUnsignedLong(sender.tag), val: 1)
        } else {
            setMultiSelectResponse(id: CUnsignedLong(sender.tag), val: 0)
        }
        saveResponseToDB()
    }
    
    @objc func changeLabelLanguage() {
        
        let questionLabels = currentQuestion.labels!
        for ql in questionLabels {
            let labelTranslations = ql.label_translations!
            for labelTranslation in labelTranslations {
                if (labelTranslation.language_code ?? "" == currentLanguage.language_code ?? "") {
                    if(currentQuestion.type ?? "" == "SINGLE_SELECT") {
                        if(self.viewWithTag(Int(ql.id ?? 0)) != nil) {
                            let radioLabel:UILabel = self.viewWithTag(Int(ql.id ?? 0)) as! UILabel
                             radioLabel.text = labelTranslation.text ?? ""
                        }
                    }
                    break
                }
            }
        }  
    }
    @objc func changeFollowUpLabelLanguage() {
        csatcesTableView.reloadData()
    }
    
    func getResponseAnswerByQuestionId(id: CUnsignedLong) -> ResponseAnswer! {
        if(response.response_answers.count > 0) {
            for ra in response.response_answers {
                if(ra.question_id != nil && ra.question_id == id) {
                    return ra
                }
            }
        }
        return nil
    }
    
    func getResponseAnswer(id:CUnsignedLong) ->ResponseAnswer! {
        if(response.response_answers.count > 0) {
            for ra in response.response_answers {
                if(ra.question_label_id != nil && ra.question_label_id == id) {
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
    
    func setCSATCESResponse(id: CUnsignedLong, val:Int) {
        let responseAnswer = getResponseAnswerByQuestionId(id: currentQuestion.id!)
        if(responseAnswer != nil) {
            responseAnswer?.answer = Int(id)
            responseAnswer?.question_label_id = id
        } else {
            let ra = getNewResponseAnswer(questionId:currentQuestion.id)
            ra.question_label_id = id
            ra.answer = Int(id)
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
    
    @objc func getTextResponse() -> String {
        var text = ""
        let responseAnswers:[ResponseAnswer] = response.response_answers
        for responseAnswer in responseAnswers {
            if(responseAnswer.question_id != nil && responseAnswer.response_answer_text?.text != nil && currentQuestion.id != nil && currentQuestion.id == responseAnswer.question_id) {
                text = responseAnswer.response_answer_text!.text ?? ""
                break
            }
        }
        return text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (range.length > 1) {
            return false
        }
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            if feedbackTextView.text == placeHolderText {
                applyNonPlaceholderStyle(textView: feedbackTextView)
                textView.text = ""
            }
        } else if(newLength == 0 && textView.text != placeHolderText) {
            applyPlaceholderStyle(textView: feedbackTextView, placeholderText: placeHolderText)
            moveCursorToStart(txtView: feedbackTextView)
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let textViewText = textView.text
        let response = getResponseAnswerByQuestionId(id: currentQuestion.id!)
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
                delegate.setCSATCESFollowUpEmail(email: txtAfterUpdate)
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
