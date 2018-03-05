//
//  LoyagramRatingView.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 20/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//


class LoyagramRatingView: UIView, LoyagramRatingViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func ratingChangedValue(ratingBar: LoyagramRatingBar) {
        
        print("current rating\(ratingBar.rating)")
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
        self.autoresizesSubviews = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //self.layoutIfNeeded()
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
        txtQuestion.isEditable = false
        tableView = UITableView()
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
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        txtQuestion.translatesAutoresizingMaskIntoConstraints = false
        txtQuestion.text = " "
        txtQuestion.textColor = UIColor.black
        txtQuestion.textAlignment = .center
        txtQuestion.font = txtQuestion.font?.withSize(16)
        
        
        //TextView Question constraints
        let txtQuestionTop = NSLayoutConstraint(item: txtQuestion, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionLeading = NSLayoutConstraint(item: txtQuestion, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let txtQuestionTrailing = NSLayoutConstraint(item: txtQuestion, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let txtQuestionHeight = NSLayoutConstraint(item: txtQuestion, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        NSLayoutConstraint.activate([txtQuestionTop,txtQuestionLeading, txtQuestionTrailing, txtQuestionHeight])
        
        
        //Table View constrinats
        
        //let tableViewWidth =  NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        
        let tblLeading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10.0)
        
        let tblTrailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        
        let centerX = NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: tableView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 30.0)
        
        tblHeight = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([tblLeading, tblTrailing, tblHeight, centerX, centerY])
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let label = currentQuestion.labels[indexPath.row]
        
        let cell = LanguageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        cell.selectionStyle = .none
        let ratingLabel = UITextView(frame:CGRect(x: 0, y: 0, width: 80, height: 30))
        ratingLabel.isEditable = false
        ratingLabel.showsVerticalScrollIndicator = false
        let ratingBar = LoyagramRatingBar(starSize: CGSize(width: 30, height:30), numberOfStars: 5, rating: 1.0, fillColor: primaryColor, unfilledColor: UIColor.clear, strokeColor: primaryColor)
        ratingLabel.font = GlobalConstants.FONT_MEDIUM
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBar.isEditable = true
        ratingBar.delegate = self
        
        //ContentView constrinats
        
        let cellContent = UIView()
        
        cell.contentView.addSubview(cellContent)
        
        cellContent.addSubview(ratingBar)
        cellContent.addSubview(ratingLabel)
        
        cellContent.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: cellContent, attribute: .centerX, relatedBy: .equal, toItem: cell.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let centerY = NSLayoutConstraint(item: cellContent, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let cellContentWidth = NSLayoutConstraint(item: cellContent, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280.0)
        
        let cellContentHeight = NSLayoutConstraint(item: cellContent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
        
        
        NSLayoutConstraint.activate([cellContentWidth, cellContentHeight, centerX, centerY])
        
        
        let labelLeading = NSLayoutConstraint(item: ratingLabel, attribute: .leading, relatedBy: .equal, toItem: cellContent, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let labelTop = NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: cellContent, attribute: .top, multiplier: 1.0, constant: 0.0)
        let labelWidth = NSLayoutConstraint(item: ratingLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0)
        let labelHeight = NSLayoutConstraint(item: ratingLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        
        NSLayoutConstraint.activate([labelLeading, labelWidth, labelHeight, labelTop])
        
        let ratingLeading = NSLayoutConstraint(item: ratingBar, attribute: .leading, relatedBy: .equal, toItem: ratingLabel, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        
        let ratingTop = NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: cellContent, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([ ratingLeading, ratingTop])
        let labelTranslations = label.label_translations
        let langCode = currentLanguage.language_code
        for labelTranslation in labelTranslations! {
            if(labelTranslation.language_code == langCode) {
                ratingLabel.text = labelTranslation.text
                break
            }
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //self.tableView.reloadData()
        let viewHeight = self.frame.height
        let requiredHeight = CGFloat(currentQuestion.labels.count) * 35
        
        if(requiredHeight <= viewHeight - 60) {
            tblHeight.constant = requiredHeight
        } else {
            tblHeight.constant = viewHeight - 60
        }
        //self.layoutIfNeeded()
    }
    
}
