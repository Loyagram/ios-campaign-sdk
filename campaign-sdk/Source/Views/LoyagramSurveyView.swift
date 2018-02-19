//
//  LoyagramSingleSelectView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 13/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

var surveyContainer: UIView!
var txtQuestion: UITextView!
var currentQuestion : Question!
var currentLanguage : Language!
var primaryLanguage : Language!
var primaryColor : UIColor!
var scrollView : UIScrollView!
var radioGroup = [LoyagramRadioButton] ()

class LoyagramSurveyView: UIView {
    
    public init(frame: CGRect, question: Question, currentLang: Language, primaryLang: Language, color: UIColor){
        super.init(frame: frame)
        currentQuestion = question
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        initSurveyView()
        setQuestion()
        //showSingleSelect()
        showMultiSelect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func initSurveyView() {
        txtQuestion = UITextView()
        scrollView = UIScrollView()
        self.addSubview(txtQuestion)
        self.addSubview(scrollView)
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false   
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        //TextView Question constraints
        let scrollViewTop = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let scrollViewLeading = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let scrollViewTrailing = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let scrollViewBottom = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scrollViewTop,scrollViewLeading, scrollViewTrailing, scrollViewBottom])
        
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
    
    @objc func showSingleSelect() {
        let labels = currentQuestion.labels
        var topConstant = 0.0
        let scrollViewContent = UIView()
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollViewContent)
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        //scrollViewContent.backgroundColor = UIColor.darkGray
        //Scrollview content constraints
        let contentTop = NSLayoutConstraint(item: scrollViewContent, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .top, multiplier: 1.0, constant: 40.0)
        let contentLeading = NSLayoutConstraint(item: scrollViewContent, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let contentTrailing = NSLayoutConstraint(item: scrollViewContent, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let contentBottom = NSLayoutConstraint(item: scrollViewContent, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
   
        NSLayoutConstraint.activate([contentTop,contentLeading, contentTrailing, contentBottom])
        
        for label in labels! {
            let radioButtonContainer = UIView()
            scrollViewContent.addSubview(radioButtonContainer)
            let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
            let radioButton = LoyagramRadioButton(frame: rect, primaryColor: primaryColor)
            radioButtonContainer.addSubview(radioButton)
            let radioLabel = UILabel()
            radioButtonContainer.addSubview(radioLabel)
            radioButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            radioButton.translatesAutoresizingMaskIntoConstraints = false
            radioLabel.translatesAutoresizingMaskIntoConstraints = false
            //radioButtonContainer.backgroundColor = UIColor.blue


            //Radio Button Container constrains
            let containerTop = NSLayoutConstraint(item: radioButtonContainer, attribute: .top, relatedBy: .equal, toItem: scrollViewContent, attribute: .top, multiplier: 1.0, constant: CGFloat(topConstant+10.0))
            let containerLeading = NSLayoutConstraint(item: radioButtonContainer, attribute: .leading, relatedBy: .equal, toItem: scrollViewContent, attribute: .leading, multiplier: 1.0, constant: 10.0)
            let containerTrailing = NSLayoutConstraint(item: radioButtonContainer, attribute: .trailing, relatedBy: .equal, toItem: scrollViewContent, attribute: .trailing, multiplier: 1.0, constant: -10.0)
            let containerHeight = NSLayoutConstraint(item: radioButtonContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            NSLayoutConstraint.activate([containerTop,containerLeading, containerTrailing, containerHeight])

            //Radio button cosntraints
            let radioTop = NSLayoutConstraint(item: radioButton, attribute: .top, relatedBy: .equal, toItem: radioButtonContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
            let radioLeading = NSLayoutConstraint(item: radioButton, attribute: .leading, relatedBy: .equal, toItem: radioButtonContainer, attribute: .leading, multiplier: 1.0, constant: 10.0)
            let radioWidth = NSLayoutConstraint(item: radioButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
            let radioHeight = NSLayoutConstraint(item: radioButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0)
            let radioCenterVertically = NSLayoutConstraint(item: radioButton, attribute: .centerY, relatedBy: .equal, toItem: radioButtonContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)


            NSLayoutConstraint.activate([radioTop,radioLeading, radioWidth, radioHeight, radioCenterVertically])

            //Radio label Constraints
            let labelTop = NSLayoutConstraint(item: radioLabel, attribute: .top, relatedBy: .equal, toItem: radioButtonContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
            let labelLeading = NSLayoutConstraint(item: radioLabel, attribute: .leading, relatedBy: .equal, toItem: radioButton, attribute: .trailing, multiplier: 1.0, constant: 10.0)
            let labelTrailing = NSLayoutConstraint(item: radioLabel, attribute: .trailing, relatedBy: .equal, toItem: radioButtonContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let labelHeight = NSLayoutConstraint(item: radioLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)

            let labelCenterVertically = NSLayoutConstraint(item: radioLabel, attribute: .centerY, relatedBy: .equal, toItem: radioButtonContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)

            NSLayoutConstraint.activate([labelTop,labelLeading, labelTrailing, labelHeight, labelCenterVertically])
            radioButton.addTarget(self, action: #selector(radioButtonAction(sender:)), for: .touchUpInside)
            radioGroup.append(radioButton)
            topConstant += 30.0
            
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
    }
    
    @objc func checkBoxAction (sender: LoyagramRadioButton) {
        
        
    }
    
    @objc func showMultiSelect() {
        let labels = currentQuestion.labels
        var topConstant = 0.0
        let scrollViewContent = UIView()
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollViewContent)
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        let contentTop = NSLayoutConstraint(item: scrollViewContent, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .top, multiplier: 1.0, constant: 40.0)
        let contentLeading = NSLayoutConstraint(item: scrollViewContent, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let contentTrailing = NSLayoutConstraint(item: scrollViewContent, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let contentBottom = NSLayoutConstraint(item: scrollViewContent, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([contentTop,contentLeading, contentTrailing, contentBottom])
        for label in labels! {
            let chkContainer = UIView()
            scrollViewContent.addSubview(chkContainer)
            let rect = CGRect(x: 0, y: 0, width: 250, height: 30)
//            let chk = LoyagramCheckBox(frame: rect)
//            chk.showTextLabel = true
//            chkContainer.addSubview(chk)
            chkContainer.translatesAutoresizingMaskIntoConstraints = false
  
            //Radio Button Container constrains
            let containerTop = NSLayoutConstraint(item: chkContainer, attribute: .top, relatedBy: .equal, toItem: scrollViewContent, attribute: .top, multiplier: 1.0, constant: CGFloat(topConstant+10.0))
            let contentWidth = NSLayoutConstraint(item: chkContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
            let containerHeight = NSLayoutConstraint(item: chkContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            
            let contentCenterVertically = NSLayoutConstraint(item: chkContainer, attribute: .centerX, relatedBy: .equal, toItem: scrollViewContent, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([containerTop, contentWidth, containerHeight, contentCenterVertically])
            
            
        
//            chk.addTarget(self, action: #selector(checkBoxAction(sender:)), for: .touchUpInside)
//            topConstant += 40.0
//
//            let labelTranslations = label.label_translations
//            let langCode = currentLanguage.language_code
//            for labelTranslation in labelTranslations! {
//                if(labelTranslation.language_code == langCode) {
//                    chk.text = labelTranslation.text
//                    break
//                }
//            }
            
            let rating = LoyagramRatingBar(starSize: CGSize(width: 40, height:40), numberOfStars: 2, rating: 0, fillColor: UIColor.red, unfilledColor: UIColor.red, strokeColor: UIColor.red)
            chkContainer.addSubview(rating)
            
        }
    }
    
}
