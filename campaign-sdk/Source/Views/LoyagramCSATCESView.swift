//
//  LoyagramCSATCESView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 21/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit


protocol LoyagramCSATCESDelegate: class {
    func setOptions()
}

class LoyagramCSATCESView: UIView, LoyagramCampaignButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
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
    
    public init(frame: CGRect, question: Question, followUpQuestion: Question, currentLang: Language, primaryLang: Language, color: UIColor, isCSAT: Bool, campaignView:LoyagramCampaignView) {
        super.init(frame: frame)
        currentQuestion = question
        self.followUpQuestion = followUpQuestion
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        self.isCSAT = isCSAT
        self.campaignView = campaignView
        campaignView.buttonCampaignButtonDelegate = self
        noOfRows = question.labels.count
        isFollowUp = false
        initCSATCESView()
        initFollowUpView()
        setQuestion()
        
        initFeedbackView()
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
                //txtFollowUpQuestion.text = questionTranslation.text
                if(isCSAT) {
                    let requestReasonSettings = sT.text.settings.csat_settings.request_reason_settings
                    txtFeedbackQuestion.text = requestReasonSettings?.all.message
                } else {
                    let requestReasonSettings = sT.text.settings.ces_settings.request_reason_settings
                    txtFeedbackQuestion.text = requestReasonSettings?.all.message
                }
                break
            }
        }
    }
    
    @objc func initCSATCESView() {
        txtQuestion = UITextView()
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
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)
        
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .bottom, relatedBy: .equal, toItem: csatcesTableView, attribute: .top, multiplier: 1.0, constant: -5.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
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
        txtFollowUpQuestion.isHidden = true
        self.addSubview(txtFollowUpQuestion)
        txtFollowUpQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtFollowUpQuestion.font = GlobalConstants.FONT_MEDIUM
        txtFollowUpQuestion.textAlignment = .center
        
        let txtQuestionTop = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .bottom, relatedBy: .equal, toItem: csatcesTableView, attribute: .top, multiplier: 1.0, constant: -5.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
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
        txtFeedbackQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtFeedbackQuestion.font = GlobalConstants.FONT_MEDIUM
        txtFeedbackQuestion.textAlignment = .center
        
        feedbackTextView = UITextView()
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.cornerRadius = 5
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
       // feedbackTextView.delegate = self
        
        let chkContainer = UIView()
        chkContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let rect = CGRect(x: 0, y: 0, width: 250, height: 35)
        chk = LoyagramCheckBox(frame: rect)
        chk.showTextLabel = true
        //chk.translatesAutoresizingMaskIntoConstraints = false
        chk.setText(stringValue: "Submit E-mail")
        chk.addTarget(self, action: #selector(followUpCheckBoxAction(sender:)), for: .touchUpInside)
        chkContainer.addSubview(chk)
        feedbackTextField = UITextField()
        feedbackTextField.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextField.isHidden = true
        //feedbackTextField.delegate = self
        
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
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtFeedbackQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        
        //TextField Constraints
        let textViewTop = NSLayoutConstraint(item: feedbackTextView, attribute: .top, relatedBy: .equal, toItem: txtFeedbackQuestion, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        
        let textViewLeading = NSLayoutConstraint(item: feedbackTextView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textViewTrailing = NSLayoutConstraint(item: feedbackTextView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textViewHeight = NSLayoutConstraint(item: feedbackTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([textViewTop,textViewLeading, textViewTrailing, textViewHeight])
        
        
        
        //CheckBox Constraints
        let chkTop = NSLayoutConstraint(item: chkContainer, attribute: .top, relatedBy: .equal, toItem: feedbackTextView, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        
        let chkLeading = NSLayoutConstraint(item: chkContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let chkWidth = NSLayoutConstraint(item: chkContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        let chkHeight = NSLayoutConstraint(item: chkContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        NSLayoutConstraint.activate([chkTop,chkLeading, chkWidth, chkHeight])
        
        //TextField Constraints
        
        let textFieldTop = NSLayoutConstraint(item: feedbackTextField, attribute: .top, relatedBy: .equal, toItem: chkContainer, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        
        let textFieldBottom = NSLayoutConstraint(item: feedbackTextField, attribute: .bottom, relatedBy: .equal, toItem: csatcesScrollView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        
        let textFieldLeading = NSLayoutConstraint(item: feedbackTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textFieldTrailing = NSLayoutConstraint(item: feedbackTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textFieldHeight = NSLayoutConstraint(item: feedbackTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        
        NSLayoutConstraint.activate([textFieldTop, textFieldBottom, textFieldLeading, textFieldTrailing, textFieldHeight])
        
        setBorderForTextField()
        setFeedBackQuestion()
    }
    
    @objc func followUpCheckBoxAction (sender: LoyagramCheckBox) {
        
        feedbackTextField.isHidden = !feedbackTextField.isHidden
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewHeight = self.frame.height
        let requiredHeight = CGFloat(noOfRows) * 35
        if(requiredHeight <= viewHeight - 50) {
            tblHeight.constant = requiredHeight
        } else {
            tblHeight.constant = viewHeight - 60
        }
            //let scrollViewHeight:CGFloat = 150.0
            if(viewHeight <= 150) {
                scrollViewHeight.constant = viewHeight
            } else {
                scrollViewHeight.constant = 150.0
            }
            setBorderForTextField()
        }
    
    @objc func setBorderForTextField() {
        let borderLayer:CALayer = CALayer()
        let width = CGFloat(2.0)
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
        if(delegate != nil) {
            delegate.setOptions()
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
            noOfRows = currentQuestion.labels.count
            csatcesTableView.reloadData()
            break
        case 2:
            csatcesScrollView.isHidden = true
            isFollowUp = true
            noOfRows = followUpQuestion.labels.count
            txtFollowUpQuestion.isHidden = false
            csatcesTableView.isHidden = false
            csatcesTableView.reloadData()
            break
        default:
            break
        }
    }
    
    func nextButtonPressed(iterator: Int) {
        switch iterator {
        case 0:
            isFollowUp = true
            noOfRows = followUpQuestion.labels.count
            txtFollowUpQuestion.isHidden = false
            txtQuestion.isHidden = true
            csatcesTableView.reloadData()
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
    
    
    @objc func getSingleSelectCell(radioButtonContainer: UIView, row:Int) {
        
        let label = currentQuestion.labels[row]
        let rect = CGRect(x: 0, y: 10, width: 20, height: 20)
        let radioButton = LoyagramRadioButton(frame: rect, primaryColor: primaryColor)
        radioButtonContainer.addSubview(radioButton)
        let radioLabel = UILabel()
        radioButtonContainer.addSubview(radioLabel)
        //radioButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        radioButton.addTarget(self, action: #selector(radioButtonAction(sender:)), for: .touchUpInside)
        radioGroup.append(radioButton)
        
        let labelTranslations = label.label_translations
        let langCode = currentLanguage.language_code
        
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code == langCode) {
                radioLabel.text = labelTranslation.text
                break
            }
        }
        
    }
    @objc func getMultiSelectCell(checkBoxContainer: UIView, row:Int) {
        let label = followUpQuestion.labels[row]
        let rect = CGRect(x: 0, y: 0, width: 220, height: 35)
        let chk = LoyagramCheckBox(frame: rect)
        chk.showTextLabel = true
        checkBoxContainer.addSubview(chk)
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
    @objc func checkBoxAction (sender: LoyagramRadioButton) {
        
        
    }
}
