//
//  LoyagramCheckBox.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 19/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class LoyagramCheckBox: UIControl {

    var checkColor: UIColor!
    var boxFillColor: UIColor!
    var boxBorderColor: UIColor!
    var labelFont: UIFont!
    var labelTextColor: UIColor!
    var label: UITextView!
    var textIsSet: Bool!
    var primaryColor: UIColor!
    
    
    var isEnable: Bool!
    var isChecked: Bool!
    var showTextLabel: Bool!
    var text : String!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        primaryColor = UIColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        self.initInternals()
        
    }
    
    init(frame:CGRect, colorPrimary:UIColor) {
        super.init(frame: frame)
        primaryColor = colorPrimary
        self.initInternals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //self.initInternals()
    }
    
    @objc func initInternals() {
        
        boxFillColor = primaryColor
        boxBorderColor = primaryColor
        checkColor = UIColor.white
        isChecked = false
        isEnabled = true
        showTextLabel = false
        textIsSet = false
        self.backgroundColor = UIColor.clear
        
    }
    
    override var intrinsicContentSize: CGSize{
        if(showTextLabel) {
            return CGSize(width: 160, height: 40)
        } else {
            return CGSize(width: 40, height: 40)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        boxBorderColor.setStroke()
        
        if(showTextLabel) {
            if(!textIsSet) {
                label = UITextView(frame: CGRect(x: self.frame.minX + 30, y: 0, width: self.frame.size.width - 30, height: self.frame.size.height))
                label.backgroundColor = UIColor.clear
                self.addSubview(label)
                label.isEditable = false
                label.font = GlobalConstants.FONT_MEDIUM
                textIsSet  = true
            }
            
            label.textColor = labelTextColor;
            label.text = text
            let boxPath = UIBezierPath(roundedRect: CGRect(x: 2, y: 7, width: 20, height: 20), cornerRadius: 2)
            boxPath.lineWidth = 2
            boxPath.stroke()
            
            if(isChecked) {
                boxFillColor.setFill()
                boxPath.fill()
                let checkPath = UIBezierPath()
                checkPath.lineWidth = 3
                checkPath.move(to: CGPoint(x: 5, y: 15))
                checkPath.addLine(to: CGPoint(x: 12, y: 20))
                checkPath.addLine(to: CGPoint(x: 20, y: 10))
                checkColor.setStroke()
                checkPath.stroke()
                
            }
        }
        else {
            let boxPath = UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: 25, height: 25), cornerRadius: 2)
            boxPath.lineWidth = 4
            boxPath.fill()
            boxPath.stroke()
            if(isChecked) {
                let checkPath = UIBezierPath()
                checkPath.lineWidth = 3
                checkPath.move(to: CGPoint(x: 5, y: 15))
                checkPath.addLine(to: CGPoint(x: 15, y: 20))
                checkPath.addLine(to: CGPoint(x: 20, y: 5))
                checkColor.setStroke()
                checkPath.stroke()
            }
        }
        
        //check if control is enabled...lower alpha if not and disable interaction
        if (isEnabled) {
            self.alpha = 1.0;
            self.isUserInteractionEnabled = true;
        }
            
        else{
            self.alpha = 0.6;
            self.isUserInteractionEnabled = false;
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func setChecked(isChecked: Bool) {
        self.isChecked = isChecked
        self.setNeedsDisplay()
    }
    
    @objc func setEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.setNeedsDisplay()
    }
    
    @objc func setText(stringValue: String) {
        self.text = stringValue
        self.setNeedsDisplay()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.setChecked(isChecked: !isChecked)
        return true
    }
}
