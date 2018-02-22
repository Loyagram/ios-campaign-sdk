//
//  LoyagramRatingView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 20/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramRatingView: UIView, LoyagramRatingViewDelegate {
    func ratingChangedValue(ratingBar: LoyagramRatingBar) {
        
    }
    
    var txtQuestion: UITextView!
    var currentQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var scrollView : UIScrollView!
    var currentRating : Int!
    
    public init(frame: CGRect, question: Question, currentLang: Language, primaryLang: Language, color: UIColor) {
        super.init(frame: frame)
        currentQuestion = question
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        initRatingView()
        setQuestion()
        showRatingView()
        
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
    
    @objc func initRatingView() {
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
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        //TextView Question constraints
        let scrollViewTop = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let scrollViewLeading = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let scrollViewTrailing = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let scrollViewBottom = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scrollViewTop,scrollViewLeading, scrollViewTrailing, scrollViewBottom])
    }
    
    @objc func showRatingView() {
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
            let ratingContainer = UIView()
            scrollViewContent.addSubview(ratingContainer)
            ratingContainer.translatesAutoresizingMaskIntoConstraints = false
            let ratingLabel = UILabel()
            ratingContainer.addSubview(ratingLabel)
            let ratingBar = LoyagramRatingBar(starSize: CGSize(width: 30, height:30), numberOfStars: 5, rating: 1.0, fillColor: primaryColor, unfilledColor: UIColor.clear, strokeColor: primaryColor)
            ratingContainer.addSubview(ratingBar)
            ratingBar.translatesAutoresizingMaskIntoConstraints = false
            ratingLabel.translatesAutoresizingMaskIntoConstraints = false
            ratingBar.isEditable = true
            ratingBar.delegate = self
            
            //ratingContainer.backgroundColor = UIColor.red
            //Rating Container constraints
            let containerTop = NSLayoutConstraint(item: ratingContainer, attribute: .top, relatedBy: .equal, toItem: scrollViewContent, attribute: .top, multiplier: 1.0, constant: CGFloat(topConstant+10.0))
            let contentWidth = NSLayoutConstraint(item: ratingContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
            let containerHeight = NSLayoutConstraint(item: ratingContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            
            let contentCenterVertically = NSLayoutConstraint(item: ratingContainer, attribute: .centerX, relatedBy: .equal, toItem: scrollViewContent, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([containerTop, contentWidth, containerHeight, contentCenterVertically])
            
        
            //Rating Label Constraints
            let labelTop = NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: ratingContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
            let labelLeading = NSLayoutConstraint(item: ratingLabel, attribute: .leading, relatedBy: .equal, toItem: ratingContainer, attribute: .leading, multiplier: 1.0, constant: 10.0)
            let labelWidth = NSLayoutConstraint(item: ratingLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
            let labelHeight = NSLayoutConstraint(item: ratingLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
            
            let labelCenterVertically = NSLayoutConstraint(item: ratingLabel, attribute: .centerY, relatedBy: .equal, toItem: ratingContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([labelTop,labelLeading, labelWidth, labelHeight, labelCenterVertically])
            let ratingLeading = NSLayoutConstraint(item: ratingBar, attribute: .leading, relatedBy: .equal, toItem: ratingLabel, attribute: .trailing, multiplier: 1.0, constant: 10.0)
            let ratingCenterVertically = NSLayoutConstraint(item: ratingBar, attribute: .centerY, relatedBy: .equal, toItem: ratingContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0)
          
             NSLayoutConstraint.activate([ ratingLeading, ratingCenterVertically])
            let labelTranslations = label.label_translations
            let langCode = currentLanguage.language_code
            for labelTranslation in labelTranslations! {
                if(labelTranslation.language_code == langCode) {
                    ratingLabel.text = labelTranslation.text
                    break
                }
            }
            topConstant += 40.0
        }
        
    }
}
