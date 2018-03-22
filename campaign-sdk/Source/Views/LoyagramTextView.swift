//
//  LoyagramTextView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 20/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramTextView: UIView, UIScrollViewDelegate, LoyagramLanguageDelegate, UITextViewDelegate, UITextFieldDelegate {
    func languageChanged(lang: Language) {
        currentLanguage = lang
        setQuestion()
        setPlaceHolderText()
    }
    
    
    var txtQuestion: UITextView!
    var currentQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var textField: UITextField!
    var textView: UITextView!
    var fieldType: String!
    var scrollViewCenterY: NSLayoutConstraint!
    var textScrollView: UIScrollView!
    var scrollViewHeight: NSLayoutConstraint!
    var staticTexts: StaticTextTranslation!
    var response:Response!
    var questionLabelId: CUnsignedLong!
    var campaignView: LoyagramCampaignView!
    
    public init(frame: CGRect, question: Question, currentLang: Language, primaryLang: Language, color: UIColor, staticTexts:StaticTextTranslation, response:Response, campaignView:LoyagramCampaignView) {
        super.init(frame: frame)
        currentQuestion = question
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        self.staticTexts = staticTexts
        self.response = response
        campaignView.languageDelegate = self
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
        
        textScrollView = UIScrollView()
        textScrollView.bounces = false
        textScrollView.translatesAutoresizingMaskIntoConstraints = false
        textScrollView.isScrollEnabled = true
        textScrollView.isUserInteractionEnabled = true
        textScrollView.showsVerticalScrollIndicator = true;
        textScrollView.delegate = self
        textScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textScrollView)
        txtQuestion = UITextView()
        textScrollView.addSubview(txtQuestion)
        
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = GlobalConstants.FONT_MEDIUM
        txtQuestion.isEditable = false
        txtQuestion.isUserInteractionEnabled = false
        //TextView Question constraints
        let txtTop = NSLayoutConstraint(item: txtQuestion, attribute: .top, relatedBy: .equal, toItem: textScrollView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        NSLayoutConstraint.activate([txtTop, txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        //Scroll View Constraints
        NSLayoutConstraint(item: textScrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textScrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textScrollView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        scrollViewCenterY = NSLayoutConstraint(item: textScrollView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        scrollViewHeight = NSLayoutConstraint(item: textScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([scrollViewHeight, scrollViewCenterY])
        
    }
    
    @objc func showTextView() {
        
        //let rect = CGRect(x: 0, y: 30, width: 280, height: 20)
        
        let questionCount = currentQuestion.labels?.count ?? 0
        if (questionCount > 0) {
            let label = currentQuestion.labels![0]
            questionLabelId = label.id
            fieldType = label.field_type
            var textFieldHeight:CGFloat = 40
            var type = "textView"
            switch(fieldType) {
            case "SHORT_ANSWER":
                textView = UITextView()
                textScrollView.addSubview(textView)
                textView.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 40
                textView.layer.borderWidth = 1
                textView.layer.borderColor = UIColor.lightGray.cgColor
                textView.autocorrectionType = .no
                textView.layer.cornerRadius = 5
                textView.delegate = self
            case "PARAGRAPH":
                textView = UITextView()
                textScrollView.addSubview(textView)
                textView.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 80
                textView.layer.borderWidth = 1
                textView.layer.borderColor = UIColor.lightGray.cgColor
                textView.autocorrectionType = .no
                textView.layer.cornerRadius = 5
                textView.delegate = self
            case "EMAIL":
                textField = UITextField()
                textScrollView.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 20
                textField.keyboardType = .emailAddress
                textField.autocorrectionType = .no
                textField.placeholder = staticTexts.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"]
                textField.delegate = self
                type = "textField"
            case "NUMBER":
                textField = UITextField()
                textScrollView.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                textFieldHeight = 20
                textField.keyboardType = .phonePad
                textField.autocorrectionType = .no
                textField.placeholder = staticTexts.translation["INPUT_PLACEHOLDER_TEXT"]
                textField.delegate = self
                type = "textField"
            default:
                textView = UITextView()
                textView.addSubview(textField)
                textView.translatesAutoresizingMaskIntoConstraints = false
                type = "textView"
                textView.layer.borderWidth = 1
                textView.layer.borderColor = UIColor.lightGray.cgColor
                textView.autocorrectionType = .no
                textView.layer.cornerRadius = 5
                textView.delegate = self
                textFieldHeight = 80
            }
            //Text Field Cosntraints
            if(type == "textField") {
                
                let txtTop = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                
                let txtLeading = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
                
                let txtTrailing = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
                
                let txtHeight = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(textFieldHeight))
                
                let txtBottom = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: textScrollView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
                
                NSLayoutConstraint.activate([txtTop, txtLeading, txtTrailing, txtHeight, txtBottom])
            }
            else {
                
                let txtTop = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                
                let txtLeading = NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
                
                let txtTrailing = NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
                
                let txtHeight = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(textFieldHeight))
                
                let txtBottom = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: textScrollView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
                
                
                NSLayoutConstraint.activate([txtTop, txtLeading, txtTrailing, txtHeight, txtBottom])
            }
            //txtQuestionCenterY.constant = -1 * (textFieldHeight - 15)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewHeight = self.frame.height
        var contentHeight:CGFloat = 0
        if(viewHeight <= 175) {
            scrollViewHeight.constant = viewHeight
            if(fieldType == "EMAIL" || fieldType == "NUMBER") {
                contentHeight = 70
            } else if(fieldType == "SHORT_ANSWER"){
                contentHeight = 90
            }
            else {
                contentHeight = 130
            }
            if(viewHeight > contentHeight) {
            let constant = (viewHeight - contentHeight)/2
            scrollViewCenterY.constant = constant
            } else {
                scrollViewCenterY.constant = 0
            }
            
        } else {
            scrollViewHeight.constant = 150
            scrollViewCenterY.constant = 25
            
        }
        
        
        setBorderForTextField()
    }
    
    @objc func setBorderForTextField() {
        if(fieldType == "EMAIL" || fieldType == "NUMBER") {
            let borderLayer:CALayer = CALayer()
            let width = CGFloat(1.0)
            borderLayer.borderColor = UIColor.lightGray.cgColor
            borderLayer.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
            borderLayer.borderWidth = width
            textField.layer.addSublayer(borderLayer)
            textField.layer.masksToBounds = true
        }
    }
    
    @objc func setPlaceHolderText(){
        switch (fieldType) {
        case "SHORT_ANSWER":
            break
        case "PARAGRAPH":
            break
        case "NUMBER":
            textField.placeholder = staticTexts.translation["INPUT_PLACEHOLDER_TEXT"]
            break;
        case "EMAIL":
            textField.placeholder = staticTexts.translation["EMAIL_ADDRESS_PLACEHOLDER_TEXT"]
            break;
        default:
            break;
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textViewText = textView.text + text
        let response = setTextResposne(id: currentQuestion.id!, rating: 1)
        if (response.response_answer_text != nil) {
            response.response_answer_text?.text = textViewText
        }
        saveResponseToDB()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = textField.text! + string
        let response = setTextResposne(id: currentQuestion.id!, rating: 1)
        if (response.response_answer_text != nil) {
            response.response_answer_text?.text = textFieldText
        }
        saveResponseToDB()
        return true
    }
    func setTextResposne(id: CUnsignedLong, rating:Int) -> ResponseAnswer {
        let answer = getResponseAnswer(id: id)
        if(answer != nil) {
            answer?.answer = Int(rating)
            return answer!
        } else {
            let ra = getNewResponseAnswer()
            ra.question_label_id = id
            ra.answer = Int(rating)
            let responseAnswerText = ResponseAnswerText()
            responseAnswerText.response_answer_id = ra.id
            ra.response_answer_text = responseAnswerText
            response.response_answers.append(ra)
            return ra
        }
    }
    
    func getResponseAnswer(id:CUnsignedLong) ->ResponseAnswer! {
        if(response.response_answers.count > 0) {
            for ra in response.response_answers {
                if(ra.question_id == id) {
                    return ra
                }
            }
        }
        return nil
    }
    
    func getNewResponseAnswer() -> ResponseAnswer {
        let responseAnswer = ResponseAnswer()
        responseAnswer.biz_id = response.biz_id
        responseAnswer.biz_loc_id  = response.location_id
        responseAnswer.biz_user_id = response.user_id
        responseAnswer.campaign_id = response.campaign_id
        responseAnswer.response_id = response.id
        responseAnswer.question_id = currentQuestion.id
        responseAnswer.at = CUnsignedLong(Date().timeIntervalSince1970 * 1000)
        responseAnswer.id = UUID().uuidString
        return responseAnswer
    }
    @objc func saveResponseToDB() {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(response)
        let stringResponse = String(data: data, encoding: .utf8)!
        DBManager.instance.createTableResponse()
        DBManager.instance.insertResponseIntoDB(response: stringResponse)
    }
    
}
