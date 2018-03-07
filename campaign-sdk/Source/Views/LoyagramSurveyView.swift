//
//  LoyagramSingleSelectView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 13/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramSurveyView: UIView, LoyagramRatingViewDelegate, UITableViewDelegate, UITableViewDataSource, LoyagramLanguageDelegate {
    var surveyContainer: UIView!
    var txtQuestion: UITextView!
    var currentQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var surveyTableView : UITableView!
    var tblHeight : NSLayoutConstraint!
    var radioGroup = [LoyagramRadioButton] ()
    var campaignView: LoyagramCampaignView!
    func languageChanged(lang: Language) {
        currentLanguage = lang
        setQuestion()
        changeLabelLanguage()
        
    }
    
    
    func ratingChangedValue(ratingBar: LoyagramRatingBar) {
        print(ratingBar.rating)
    }
    
    
    public init(frame: CGRect, question: Question, currentLang: Language, primaryLang: Language, color: UIColor, campaignView: LoyagramCampaignView){
        super.init(frame: frame)
        self.currentQuestion = question
        self.currentLanguage = currentLang
        self.primaryLanguage = primaryLang
        self.primaryColor = color
        self.campaignView = campaignView
        self.campaignView.languageDelegate = self
        self.autoresizesSubviews = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initSurveyView()
        setQuestion()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func initSurveyView() {
        txtQuestion = UITextView()
        txtQuestion.isEditable = false
        surveyTableView = UITableView()
        surveyTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(surveyTableView)
        self.addSubview(txtQuestion)
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
        surveyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        surveyTableView.isScrollEnabled = true
        surveyTableView.bounces = false
        surveyTableView.separatorStyle = .none
        surveyTableView.allowsSelection = true;
        surveyTableView.isUserInteractionEnabled = true
        surveyTableView.showsVerticalScrollIndicator = false
        surveyTableView.showsHorizontalScrollIndicator = false
        
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)
        
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .bottom, relatedBy: .equal, toItem: surveyTableView, attribute: .top, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        //Table View constrinats
        
        //let tableViewWidth =  NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        
        let tblLeading = NSLayoutConstraint(item: surveyTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let tblTrailing = NSLayoutConstraint(item: surveyTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let centerX = NSLayoutConstraint(item: surveyTableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: surveyTableView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 30.0)
        
        tblHeight = NSLayoutConstraint(item: surveyTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([tblLeading, tblTrailing, tblHeight, centerX, centerY])
        
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
        
        
        
        if(currentQuestion.type == "SINGLE_SELECT") {
            getSingleSelectCell(radioButtonContainer: cellContent, row: indexPath.row)
        } else {
            getMultiSelectCell(checkBoxContainer: cellContent, row: indexPath.row)
        }
        
        
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
        radioLabel.tag = label.id
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
        let label = currentQuestion.labels[row]
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
    
    
    @objc func radioButtonAction (sender: LoyagramRadioButton) {
        radioGroup.forEach {
            $0.isSelected = false
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    @objc func checkBoxAction (sender: LoyagramRadioButton) {
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //surveyTableView.reloadData()
        let viewHeight = self.frame.height
        let requiredHeight = CGFloat(currentQuestion.labels.count) * 35
        
        if(requiredHeight <= viewHeight - 60) {
            tblHeight.constant = requiredHeight
        } else {
            tblHeight.constant = viewHeight - 60
        }
    }
    
    @objc func changeLabelLanguage() {
        let questionLabels = currentQuestion.labels!
        for ql in questionLabels {
            let labelTranslations = ql.label_translations!
            for labelTranslation in labelTranslations {
                if (labelTranslation.language_code == currentLanguage.language_code) {
                    if(currentQuestion.type == "SINGLE_SELECT") {
                        if(self.viewWithTag(ql.id) != nil) {
                            let radioLabel:UILabel = self.viewWithTag(ql.id) as! UILabel
                            radioLabel.text = labelTranslation.text
                        }
                    } else {
                        if(self.viewWithTag(ql.id) != nil) {
                            let checkBox:LoyagramCheckBox = viewWithTag(ql.id) as! LoyagramCheckBox
                            checkBox.text = labelTranslation.text
                        }
                    }
                    break
                }
            }  
        }
    }
    
}
