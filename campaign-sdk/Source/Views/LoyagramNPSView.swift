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

class LoyagramNPSView: UIView, UITableViewDelegate, UITableViewDataSource, LoyagramCampaignButtonDelegate {
    
    
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
    var feedbackContainer : UIView!
    var chk: LoyagramCheckBox!
    var feedbackTextField: UITextField!
    var feedbackTextView:UITextView!
    var delegate: LoyagramNPSDelegate!
    var campaignView: LoyagramCampaignView!
    
    public init(frame: CGRect, question: Question, followUpQuestion: Question, currentLang: Language, primaryLang: Language, color: UIColor, campaignView: LoyagramCampaignView) {
        super.init(frame: frame)
        currentQuestion = question
        self.followUpQuestion = followUpQuestion
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        self.campaignView = campaignView
        campaignView.buttonCampaignButtonDelegate = self
        
        self.autoresizesSubviews = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        initNPSView()
        addNPSButtons()
        initFeedbackView()
        
        initFollowUpView()
        setQuestion()
        
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
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .bottom, relatedBy: .equal, toItem: npsContainer, attribute: .top, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
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
        let txtQuestionTop = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .bottom, relatedBy: .equal, toItem: followUpTableView, attribute: .top, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtFollowUpQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        //Table View constrinats
        
        //let tableViewWidth =  NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        
        let tblLeading = NSLayoutConstraint(item: followUpTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let tblTrailing = NSLayoutConstraint(item: followUpTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let centerX = NSLayoutConstraint(item: followUpTableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: followUpTableView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 30.0)
        
        tblHeight = NSLayoutConstraint(item: followUpTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([tblLeading, tblTrailing, tblHeight, centerX, centerY])
        
        //showFollowUp()
    }
    
    @objc func addNPSButtons() {
    
        let buttonWidth:CGFloat = 25.0
        //NPS Container Constraints
        let containerTop = NSLayoutConstraint(item: npsContainer, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        let containerWidth = NSLayoutConstraint(item: npsContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 295)
        
        let containerHeight = NSLayoutConstraint(item: npsContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonWidth)
        
        let centerHorizontal = NSLayoutConstraint(item: npsContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        let centerVertical = NSLayoutConstraint(item: npsContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 30)
        
        NSLayoutConstraint.activate([containerTop, containerWidth, containerHeight, centerHorizontal, centerVertical])
        
        
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
            break
        case 2:
            feedbackContainer.isHidden = true
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
            followUpTableView.isHidden = false
            txtFollowUpQuestion.isHidden = false
            break
        case 1:
            followUpTableView.isHidden = true
            txtFollowUpQuestion.isHidden = true
            feedbackContainer.isHidden = false
            break
        case 2:
            break
        default:
            break
        }
    }
    
    @objc func initFeedbackView() {
        
        feedbackContainer = UIView()
        txtFeedBackQuestion = UITextView()
        self.addSubview(feedbackContainer)
        feedbackContainer.translatesAutoresizingMaskIntoConstraints = false
        feedbackContainer.isHidden = true
        //feedbackContainer.backgroundColor = UIColor.red
        feedbackTextView = UITextView()
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        let chkContainer = UIView()
        chkContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let rect = CGRect(x: 0, y: 0, width: 250, height: 30)
        chk = LoyagramCheckBox(frame: rect)
        chk.showTextLabel = true
        //chk.translatesAutoresizingMaskIntoConstraints = false
        chk.setText(stringValue: "Submit E-mail")
        chk.addTarget(self, action: #selector(followUpCheckBoxAction(sender:)), for: .touchUpInside)
        chkContainer.addSubview(chk)
        feedbackTextField = UITextField()
        feedbackTextField.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextField.isHidden = true
        feedbackContainer.addSubview(feedbackTextField)
        feedbackContainer.addSubview(feedbackTextView)
        feedbackContainer.addSubview(chkContainer)
        
        
        //Feedback container constraints
        let containerTop = NSLayoutConstraint(item: feedbackContainer, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let containerLeading = NSLayoutConstraint(item: feedbackContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let containerTrailing = NSLayoutConstraint(item: feedbackContainer, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let containerBottom = NSLayoutConstraint(item: feedbackContainer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([containerTop,containerLeading, containerTrailing, containerBottom])
        
        //TextField Constraints
        let textViewTop = NSLayoutConstraint(item: feedbackTextView, attribute: .top, relatedBy: .equal, toItem: feedbackContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let textViewLeading = NSLayoutConstraint(item: feedbackTextView, attribute: .leading, relatedBy: .equal, toItem: feedbackContainer, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textViewTrailing = NSLayoutConstraint(item: feedbackTextView, attribute: .trailing, relatedBy: .equal, toItem: feedbackContainer, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textViewHeight = NSLayoutConstraint(item: feedbackTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60.0)
        
        NSLayoutConstraint.activate([textViewTop,textViewLeading, textViewTrailing, textViewHeight])
        
        
        //CheckBox Constraints
        let chkTop = NSLayoutConstraint(item: chkContainer, attribute: .top, relatedBy: .equal, toItem: feedbackTextView, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        
        let chkLeading = NSLayoutConstraint(item: chkContainer, attribute: .leading, relatedBy: .equal, toItem: feedbackTextView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let chkWidth = NSLayoutConstraint(item: chkContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        let chkHeight = NSLayoutConstraint(item: chkContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        NSLayoutConstraint.activate([chkTop,chkLeading, chkWidth, chkHeight])
        
        //TextField Constraints
        let textFieldTop = NSLayoutConstraint(item: feedbackTextField, attribute: .top, relatedBy: .equal, toItem: chkContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let textFieldLeading = NSLayoutConstraint(item: feedbackTextField, attribute: .leading, relatedBy: .equal, toItem: feedbackContainer, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let textFieldTrailing = NSLayoutConstraint(item: feedbackTextField, attribute: .trailing, relatedBy: .equal, toItem: feedbackContainer, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let textFieldHeight = NSLayoutConstraint(item: feedbackTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        NSLayoutConstraint.activate([textFieldTop,textFieldLeading, textFieldTrailing, textFieldHeight])
        feedbackContainer.layoutIfNeeded()
    }
    
    @objc func followUpCheckBoxAction (sender: LoyagramRadioButton) {
        
        feedbackTextField.isHidden = !feedbackTextField.isHidden
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // setBorderForTextField()
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
    
    @objc func showFollowUp() {
        let labels = followUpQuestion.labels
        var topConstant = 0.0
        let scrollViewContent = UIView()
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        
        //followUpScrollView.addSubview(scrollViewContent)
        //followUpScrollView.isUserInteractionEnabled = true
        //followUpScrollView.isExclusiveTouch = true
        
        let contentTop = NSLayoutConstraint(item: scrollViewContent, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        let contentLeading = NSLayoutConstraint(item: scrollViewContent, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let contentTrailing = NSLayoutConstraint(item: scrollViewContent, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let contentBottom = NSLayoutConstraint(item: scrollViewContent, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([contentTop,contentLeading, contentTrailing, contentBottom])
        for label in labels! {
            let chkContainer = UIView()
            scrollViewContent.addSubview(chkContainer)
            let rect = CGRect(x: 0, y: 0, width: 250, height: 30)
            let chk = LoyagramCheckBox(frame: rect)
            chk.showTextLabel = true
            chkContainer.addSubview(chk)
            chkContainer.translatesAutoresizingMaskIntoConstraints = false
            
            //Radio Button Container constrains
            let containerTop = NSLayoutConstraint(item: chkContainer, attribute: .top, relatedBy: .equal, toItem: scrollViewContent, attribute: .top, multiplier: 1.0, constant: CGFloat(topConstant+10.0))
            let contentWidth = NSLayoutConstraint(item: chkContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
            let containerHeight = NSLayoutConstraint(item: chkContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            
            let contentCenterVertically = NSLayoutConstraint(item: chkContainer, attribute: .centerX, relatedBy: .equal, toItem: scrollViewContent, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([containerTop, contentWidth, containerHeight, contentCenterVertically])
            chk.addTarget(self, action: #selector(checkBoxAction(sender:)), for: .touchUpInside)
            topConstant += 40.0
            
            let labelTranslations = label.label_translations
            let langCode = currentLanguage.language_code
            for labelTranslation in labelTranslations! {
                if(labelTranslation.language_code == langCode) {
                    chk.text = labelTranslation.text
                    break
                }
            }
        }
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
        
        let cellContentHeight = NSLayoutConstraint(item: cellContent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([cellContentWidth, cellContentHeight, centerX, centerY])
        
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentQuestion.labels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
}
