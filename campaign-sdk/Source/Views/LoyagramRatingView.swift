//
//  LoyagramRatingView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 20/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramRatingView: UIView, LoyagramRatingViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func ratingChangedValue(ratingBar: LoyagramRatingBar) {
        
    }
    
    var mainView: UIView!
    var mainViewContent : UIView!
    var txtQuestion: UITextView!
    var currentQuestion : Question!
    var currentLanguage : Language!
    var primaryLanguage : Language!
    var primaryColor : UIColor!
    var tableView : UITableView!
    var scrollViewContent: UIView!
    var currentRating : Int!
    var tblHeight : NSLayoutConstraint!
    
    public init(frame: CGRect, question: Question, currentLang: Language, primaryLang: Language, color: UIColor) {
        super.init(frame: frame)
        currentQuestion = question
        currentLanguage = currentLang
        primaryLanguage = primaryLang
        primaryColor = color
        
        initRatingView()
        setQuestion()
       // self.layoutIfNeeded()
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
        tableView = UITableView()
        tableView.backgroundColor = UIColor.red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        self.addSubview(txtQuestion)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    
        tableView.isScrollEnabled = true
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = true;
        tableView.isUserInteractionEnabled = true
        
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)

        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)

        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)

        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let centerX = NSLayoutConstraint(item: txtQuestion, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
//        let centerY = NSLayoutConstraint(item: txtQuestion, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight, centerX])
    
        txtQuestion.backgroundColor = UIColor.red
        //Table View constrinats
        
        
        let tblLeading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)

        let tblTrailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let tblTop = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: txtQuestion, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let tblBottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        
        NSLayoutConstraint.activate([tblLeading, tblTrailing, tblTop, tblBottom])
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let label = currentQuestion.labels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.translatesAutoresizingMaskIntoConstraints = false
        
       
        let ratingLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 80, height: 30))
        let ratingBar = LoyagramRatingBar(starSize: CGSize(width: 30, height:30), numberOfStars: 5, rating: 1.0, fillColor: primaryColor, unfilledColor: UIColor.clear, strokeColor: primaryColor)
        cell?.contentView.addSubview(ratingBar)
        cell?.contentView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBar.isEditable = true
        ratingBar.delegate = self
        
        let labelLeading = NSLayoutConstraint(item: ratingLabel, attribute: .leading, relatedBy: .equal, toItem: cell?.contentView, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let labelTop = NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: cell?.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let labelWidth = NSLayoutConstraint(item: ratingLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        let labelHeight = NSLayoutConstraint(item: ratingLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        
//        let labelCenterVertically = NSLayoutConstraint(item: ratingLabel, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([labelLeading, labelWidth, labelHeight, labelTop])

        let ratingLeading = NSLayoutConstraint(item: ratingBar, attribute: .leading, relatedBy: .equal, toItem: ratingLabel, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        
        let ratingTop = NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: cell?.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        
        NSLayoutConstraint.activate([ ratingLeading, ratingTop])
        let labelTranslations = label.label_translations
        let langCode = currentLanguage.language_code
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code == langCode) {
                ratingLabel.text = labelTranslation.text
                break
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion.labels.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        //if(self.frame.size.height)
//        return 40.0
//
//    }
    
    @objc func showRatingView() {


        
    }
}
