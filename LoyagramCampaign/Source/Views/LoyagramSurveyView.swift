//
//  LoyagramSingleSelectView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 13/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

protocol LoyagramSurveyDelegate: class {
    func setSingleSelect()
}

class LoyagramSurveyView: UIView, UITableViewDelegate, UITableViewDataSource, LoyagramLanguageDelegate {
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
    var delegate: LoyagramSurveyDelegate!
    var response: Response!
    func languageChanged(lang: Language) {
        currentLanguage = lang
        setQuestion()
        changeLabelLanguage()
        
    }
    
    
    public init(frame: CGRect, question: Question, currentLang: Language, primaryLang: Language, color: UIColor, campaignView: LoyagramCampaignView, resposne: Response){
        super.init(frame: frame)
        self.currentQuestion = question
        self.currentLanguage = currentLang
        self.primaryLanguage = primaryLang
        self.primaryColor = color
        self.campaignView = campaignView
        self.campaignView.languageDelegate = self
        self.response = resposne
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
        txtQuestion.text = ""
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = GlobalConstants.FONT_MEDIUM
        
        
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
            if(langCode != nil && questionTranslation.language_code != nil && questionTranslation.language_code == langCode) {
                txtQuestion.text = questionTranslation.text ?? ""
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
        cell.contentView.isUserInteractionEnabled = false
        
        let centerX = NSLayoutConstraint(item: cellContent, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: cellContent, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let cellContentWidth = NSLayoutConstraint(item: cellContent, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 220.0)
        
        let cellContentHeight = NSLayoutConstraint(item: cellContent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([cellContentWidth, cellContentHeight, centerX, centerY])
        
        if(currentQuestion.type ?? "" == "SINGLE_SELECT") {
            getSingleSelectCell(radioButtonContainer: cellContent, row: indexPath.row)
        } else if(currentQuestion.type ?? "" == "MULTI_SELECT") {
            getMultiSelectCell(checkBoxContainer: cellContent, row: indexPath.row)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentQuestion.labels!.count
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
            if(currentQuestion.type == "SINGLE_SELECT") {
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
        
        let label = currentQuestion.labels![row]
        let rect = CGRect(x: 0, y: 10, width: 20, height: 20)
        let radioButton = LoyagramRadioButton(frame: rect, primaryColor: primaryColor)
        radioButtonContainer.addSubview(radioButton)
        let radioLabel = UILabel()
        radioButtonContainer.addSubview(radioLabel)
        radioLabel.font = GlobalConstants.FONT_MEDIUM
        //radioButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioLabel.translatesAutoresizingMaskIntoConstraints = false
        radioLabel.tag = Int(label.id ?? 0)
        radioButton.labelId = Int(label.id ?? 0)
        let ra = getResponseAnswer(id: label.id!)
        if(ra != nil && ra?.question_label_id ?? 0 == label.id ?? 0) {
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
        //let radioLabelGesture = UITapGestureRecognizer(target: self, action:  Selector("radioButtonAction(sender:radioButton)"))
//        radioLabelGesture.numberOfTapsRequired = 1
//        radioLabel.isUserInteractionEnabled = true
//        radioLabel.addGestureRecognizer(radioLabelGesture)
        
        radioGroup.append(radioButton)
        
        let labelTranslations = label.label_translations
        let langCode = currentLanguage.language_code
        
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code != nil && langCode != nil && labelTranslation.language_code == langCode) {
                radioLabel.text = labelTranslation.text ?? ""
                break
            }
        }
        
    }
    
    @objc func getMultiSelectCell(checkBoxContainer: UIView, row:Int) {
        let label = currentQuestion.labels![row]
        let rect = CGRect(x: 0, y: 0, width: 220, height: 35)
        let chk = LoyagramCheckBox(frame: rect, colorPrimary:primaryColor)
        chk.showTextLabel = true
        checkBoxContainer.addSubview(chk)
        chk.tag = Int(label.id ?? 0)
        //chk.isUserInteractionEnabled = false
        chk.addTarget(self, action: #selector(checkBoxAction(sender:)), for: .touchUpInside)
        let responseAnswer = getResponseAnswer(id: label.id!)
        if(responseAnswer != nil) {
           chk.isChecked = true
        }
        let labelTranslations = label.label_translations
        let langCode = currentLanguage.language_code
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code != nil && langCode != nil && labelTranslation.language_code == langCode) {
                chk.text = labelTranslation.text ?? ""
                break
            }
        }
        
    }
    
    
    @objc func radioButtonAction (sender: LoyagramRadioButton) {
        radioGroup.forEach {
            $0.isSelected = false
        }
        sender.isSelected = !sender.isSelected
        setSingleSelectResposne(id: CUnsignedLong(sender.labelId))
        saveResponseToDB()
        if(delegate != nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.delegate.setSingleSelect()
            }
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //surveyTableView.reloadData()
        let viewHeight = self.frame.height
        let requiredHeight = CGFloat((currentQuestion.labels?.count)!) * 35
        
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
                if (labelTranslation.language_code != nil && currentLanguage.language_code != nil && labelTranslation.language_code == currentLanguage.language_code) {
                    if(currentQuestion.type ?? "" == "SINGLE_SELECT") {
                        if(self.viewWithTag(Int(ql.id ?? 0)) != nil) {
                            let radioLabel:UILabel = self.viewWithTag(Int(ql.id ?? 0)) as! UILabel
                            radioLabel.text = labelTranslation.text ?? ""
                        }
                    } else {
                        if(self.viewWithTag(Int(ql.id ?? 0)) != nil) {
                            let checkBox:LoyagramCheckBox = viewWithTag(Int(ql.id ?? 0)) as! LoyagramCheckBox
                            checkBox.text = labelTranslation.text ?? ""
                            checkBox.setNeedsDisplay()
                        }
                    }
                    break
                }
            }  
        }
    }
    
    
    
    func setMultiSelectResponse(id: CUnsignedLong, val:Int) {
        let answer = getResponseAnswer(id: id)
        if(answer != nil) {
            if(val == 1) {
                answer?.answer = Int(id)
            } else {
                let index = response.response_answers.index(where:{$0 === answer!})
                response.response_answers.remove(at: index!)
            }
        } else {
            let ra = getNewResponseAnswer()
            ra.question_label_id = id
            ra.answer = Int(id)
            response.response_answers.append(ra)
        }
    }
    
    
    func getResponseAnswerByQuestionId(id: CUnsignedLong) -> [ResponseAnswer] {
        
        var answers = [ResponseAnswer]()
        if(response.response_answers.count > 0) {
            for ra in response.response_answers {
                if(ra.question_id != nil && ra.question_id == id) {
                    answers.append(ra)
                }
            }
        }
        return answers
    }
    
    func setSingleSelectResposne(id: CUnsignedLong){
        let answers = getResponseAnswerByQuestionId(id: currentQuestion.id!)
        if(answers.count > 0) {
            let ra = answers[0]
            ra.answer = Int(id)
            ra.question_label_id = id
            //return ra
        } else {
            let ra = getNewResponseAnswer()
            ra.question_label_id = id
            ra.answer = Int(id)
            response.response_answers.append(ra)
            //return ra
        }
    }
    
    func getResponseAnswer(id:CUnsignedLong) -> ResponseAnswer! {
        if(response.response_answers.count > 0) {
            for ra in response.response_answers {
                if(ra.question_label_id != nil && ra.question_label_id == id) {
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
