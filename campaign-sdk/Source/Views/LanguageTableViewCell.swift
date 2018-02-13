//
//  LanguageTableViewCell.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 12/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    var lblLanguage: UILabel!
    
     override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = 100
        
        lblLanguage = UILabel()
        lblLanguage.frame = CGRect(x: 10, y: 5, width: labelWidth, height:labelHeight)
        contentView.addSubview(lblLanguage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
