//
//  RatingTableViewCell.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 27/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {

    var lblRating: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = 110
        
        lblRating = UILabel()
        lblRating.frame = CGRect(x: 10, y: 5, width: labelWidth, height:labelHeight)
        lblRating.font = GlobalConstants.FONT_MEDIUM
        
        contentView.addSubview(lblRating)
        
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
