//
//  LoyagramDialog.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 16/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramDialog: UIView {

    var backgroundView = UIView()
    var dialogView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initDialogView() {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)
    }
}
