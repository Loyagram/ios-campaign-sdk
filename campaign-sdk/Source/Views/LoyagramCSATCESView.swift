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

class LoyagramCSATCESView: UIView, LoyagramCampaignButtonDelegate {
    

    var txtQuestion: UITextView!
    var currentQuestion : Question!
    var followUpQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var isCSAT: Bool = true
    var scrollView: UIScrollView!
    var followUpScrollView : UIScrollView!
    var feedbackContainer : UIView!
    var chk: LoyagramCheckBox!
    var feedbackTextField: UITextField!
    var feedbackTextView:UITextView!
    var campaignView: LoyagramCampaignView!
    var delegate: LoyagramCSATCESDelegate!
    
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
        initCSATCESView()
        initFollowUpView()
        setQuestion()
        initFeedbackView()
        showCSATCESOptions()
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
    
    @objc func initCSATCESView() {
        txtQuestion = UITextView()
        scrollView = UIScrollView()
        self.addSubview(txtQuestion)
        self.addSubview(scrollView)
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        //ScrollView Question constraints
        let scrollViewTop = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        
        let scrollViewLeading = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let scrollViewTrailing = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let scrollViewBottom = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scrollViewTop,scrollViewLeading, scrollViewTrailing, scrollViewBottom])
        
    }
    
    @objc func initFollowUpView() {
        followUpScrollView = UIScrollView()
        followUpScrollView.isHidden = true
        followUpScrollView.isUserInteractionEnabled = true
        followUpScrollView.isExclusiveTouch = true
        followUpScrollView.isHidden = true
        self.addSubview(followUpScrollView)
        followUpScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollViewTop = NSLayoutConstraint(item: followUpScrollView, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        
        let scrollViewLeading = NSLayoutConstraint(item: followUpScrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let scrollViewTrailing = NSLayoutConstraint(item: followUpScrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let scrollViewBottom = NSLayoutConstraint(item: followUpScrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scrollViewTop,scrollViewLeading, scrollViewTrailing, scrollViewBottom])
        showFollowUp()
    }
    
    @objc func initFeedbackView() {
        
        feedbackContainer = UIView()
        self.addSubview(feedbackContainer)
        feedbackContainer.isHidden = false
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
    
    
    @objc func showCSATCESOptions() {
        
        let labels = currentQuestion.labels
        var topConstant = 0.0
        let scrollViewContent = UIView()
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollViewContent)
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        //scrollViewContent.backgroundColor = UIColor.darkGray
        
        //Scrollview content constraints
        let contentTop = NSLayoutConstraint(item: scrollViewContent, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let contentLeading = NSLayoutConstraint(item: scrollViewContent, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let contentTrailing = NSLayoutConstraint(item: scrollViewContent, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let contentBottom = NSLayoutConstraint(item: scrollViewContent, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([contentTop,contentLeading, contentTrailing, contentBottom])
        
        for label in labels! {
            let radioButtonContainer = UIView()
            scrollViewContent.addSubview(radioButtonContainer)
            let rect = CGRect(x: 0, y: 0, width: 25, height: 25)
            let radioButton = LoyagramRadioButton(frame: rect, primaryColor: primaryColor)
            radioButtonContainer.addSubview(radioButton)
            let radioLabel = UILabel()
            radioButtonContainer.addSubview(radioLabel)
            radioButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            radioButton.translatesAutoresizingMaskIntoConstraints = false
            radioLabel.translatesAutoresizingMaskIntoConstraints = false
            
            
            //Radio Button Container constrains
            let containerTop = NSLayoutConstraint(item: radioButtonContainer, attribute: .top, relatedBy: .equal, toItem: scrollViewContent, attribute: .top, multiplier: 1.0, constant: CGFloat(topConstant+10.0))
            let containerLeading = NSLayoutConstraint(item: radioButtonContainer, attribute: .leading, relatedBy: .equal, toItem: scrollViewContent, attribute: .leading, multiplier: 1.0, constant: 10.0)
            let containerTrailing = NSLayoutConstraint(item: radioButtonContainer, attribute: .trailing, relatedBy: .equal, toItem: scrollViewContent, attribute: .trailing, multiplier: 1.0, constant: -10.0)
            let containerHeight = NSLayoutConstraint(item: radioButtonContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            NSLayoutConstraint.activate([containerTop,containerLeading, containerTrailing, containerHeight])
            
            //Radio button cosntraints
            let radioLeading = NSLayoutConstraint(item: radioButton, attribute: .leading, relatedBy: .equal, toItem: radioButtonContainer, attribute: .leading, multiplier: 1.0, constant: 10.0)
            let radioWidth = NSLayoutConstraint(item: radioButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
            let radioHeight = NSLayoutConstraint(item: radioButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
            let radioCenterVertically = NSLayoutConstraint(item: radioButton, attribute: .centerY, relatedBy: .equal, toItem: radioButtonContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            
            
            NSLayoutConstraint.activate([radioLeading, radioWidth, radioHeight, radioCenterVertically])
            
            //Radio label Constraints
            let labelTop = NSLayoutConstraint(item: radioLabel, attribute: .top, relatedBy: .equal, toItem: radioButtonContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
            let labelLeading = NSLayoutConstraint(item: radioLabel, attribute: .leading, relatedBy: .equal, toItem: radioButton, attribute: .trailing, multiplier: 1.0, constant: 10.0)
            let labelTrailing = NSLayoutConstraint(item: radioLabel, attribute: .trailing, relatedBy: .equal, toItem: radioButtonContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let labelHeight = NSLayoutConstraint(item: radioLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            
//            let labelCenterVertically = NSLayoutConstraint(item: radioLabel, attribute: .centerY, relatedBy: .equal, toItem: radioButtonContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([labelTop,labelLeading, labelTrailing, labelHeight])
            radioButton.addTarget(self, action: #selector(radioButtonAction(sender:)), for: .touchUpInside)
            radioGroup.append(radioButton)
            topConstant += 35.0
            
            let labelTranslations = label.label_translations
            let langCode = currentLanguage.language_code
            for labelTranslation in labelTranslations! {
                if(labelTranslation.language_code == langCode) {
                    radioLabel.text = labelTranslation.text
                    break
                }
            }
            
        }
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
            followUpScrollView.isHidden = true
            scrollView.isHidden = false
            break
        case 2:
            feedbackContainer.isHidden = true
            followUpScrollView.isHidden = false
            break
        default:
            break
        }
    }
    
    func nextButtonPressed(iterator: Int) {
        switch iterator {
        case 0:
            scrollView.isHidden = true
            followUpScrollView.isHidden = false
            break
        case 1:
            followUpScrollView.isHidden = true
            feedbackContainer.isHidden = false
            break
        case 2:
            break
        default:
            break
        }
    }
    
    @objc func showFollowUp() {
        let labels = followUpQuestion.labels
        var topConstant = 0.0
        let scrollViewContent = UIView()
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        followUpScrollView.addSubview(scrollViewContent)
        followUpScrollView.isUserInteractionEnabled = true
        followUpScrollView.isExclusiveTouch = true
        let contentTop = NSLayoutConstraint(item: scrollViewContent, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 0.0)
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
    
    
}
