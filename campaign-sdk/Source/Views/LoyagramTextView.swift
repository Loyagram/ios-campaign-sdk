//
//  LoyagramTextView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 20/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramTextView: UIView {
    
    var txtQuestion: UITextView!
    var currentQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var textField: UITextField!
    var textView: UITextView!
    var fieldType: String!
    public init(frame: CGRect, question: Question, currentLang: Language, primaryLang: Language, color: UIColor) {
        super.init(frame: frame)
        currentQuestion = question
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        initTextView()
        setQuestion()
        showTextView()
        
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
    
    @objc func initTextView() {
        txtQuestion = UITextView()
        self.addSubview(txtQuestion)
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
    }
    
    @objc func showTextView() {
        
        //let rect = CGRect(x: 0, y: 30, width: 280, height: 20)
        
        if (currentQuestion.labels.count > 0) {
            let label = currentQuestion.labels[0]
            fieldType = label.field_type
            var textFieldHeight = 40
            var type = "textView"
            switch(fieldType) {
            case "SHORT_ANSWER":
                textView = UITextView()
                self.addSubview(textView)
                textView.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 40
                textView.layer.borderWidth = 1
                textView.layer.borderColor = UIColor.lightGray.cgColor
            case "PARAGRAPH":
                textView = UITextView()
                self.addSubview(textView)
                textView.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 80
                textView.layer.borderWidth = 1
                textView.layer.borderColor = UIColor.lightGray.cgColor
            case "EMAIL":
                textField = UITextField()
                self.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 20
                textField.keyboardType = .emailAddress
                type = "textField"
            case "NUMBER":
                textField = UITextField()
                self.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 20
                textField.keyboardType = .phonePad
                type = "textField"
            default:
                type = "textView"
                textFieldHeight = 80
            }
            //Text Field Cosntraints
            if(type == "textField") {
            let txtTop = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 10.0)
            
            let txtLeading = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
            
            let txtTrailing = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
            
            let txtHeight = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(textFieldHeight))
            NSLayoutConstraint.activate([txtTop, txtLeading, txtTrailing, txtHeight])
            }
            else {
                let txtTop = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 10.0)
                
                let txtLeading = NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
                
                let txtTrailing = NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
                
                let txtHeight = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(textFieldHeight))
                NSLayoutConstraint.activate([txtTop, txtLeading, txtTrailing, txtHeight])
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBorderForTextField()
    }
    
    @objc func setBorderForTextField() {
        if(fieldType == "EMAIL" || fieldType == "NUMBER") {
            let borderLayer:CALayer = CALayer()
            let width = CGFloat(2.0)
            borderLayer.borderColor = UIColor.lightGray.cgColor
            borderLayer.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
            borderLayer.borderWidth = width
            textField.layer.addSublayer(borderLayer)
            textField.layer.masksToBounds = true
        }
    }
    
}
