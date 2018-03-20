//
//  LoyagramRatingBar.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 19/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

protocol LoyagramRatingViewDelegate: class {
    
    func ratingChangedValue(ratingBar: LoyagramRatingBar)
}

class LoyagramRatingBar: UIView {
    
    
    var  starSize : CGSize!
    var  numberOfStars : NSInteger!
    var  rating : Float!
    var  fillColor : UIColor!
    var  unfilledColor : UIColor!
    var  strokeColor : UIColor!
    var  lineWidth : CGFloat!
    
    var  padding : CGFloat!
    var  isEditable : Bool!
    var  allowsTapWhenEditable : Bool!
    var  allowsSwipeWhenEditable : Bool!
    var  allowsHalfIntegralRatings : Bool!
    var  delegate: LoyagramRatingViewDelegate!
    var  labelId = Int()
    
    init(starSize: CGSize, numberOfStars: NSInteger, rating: Float, fillColor: UIColor, unfilledColor: UIColor, strokeColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.starSize = starSize;
        self.numberOfStars = numberOfStars;
        self.rating = rating;
        self.fillColor = fillColor;
        self.unfilledColor = unfilledColor;
        self.strokeColor = strokeColor;
        self.padding = self.starSize.width / 5.0
        self.lineWidth = 1.0
        self.allowsSwipeWhenEditable = true;
        self.allowsTapWhenEditable = true;
        self.allowsHalfIntegralRatings = false;
        self.isEditable = true
        self.backgroundColor = UIColor.clear
        self.frame = CGRect(x:0, y:0, width:self.intrinsicContentSize.width, height:self.intrinsicContentSize.height);
        
        
        
        self.initializeGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(processGestureRecogniser(gesture:)))
        self.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(processGestureRecogniser(gesture:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func processGestureRecogniser(gesture: UIGestureRecognizer) {
        if !isEditable {
            return
        }
        if (gesture is UITapGestureRecognizer) && !allowsTapWhenEditable {
            return
        }
        if (gesture is UIPanGestureRecognizer) && !allowsSwipeWhenEditable {
            return
        }
        let point: CGPoint = gesture.location(in: self)
        self.rating = ratingAtPoint(point: point)
        self.setNeedsDisplay()
        if (delegate != nil)  {
            delegate.ratingChangedValue(ratingBar:self)
        }
    }
    
    @objc func ratingAtPoint(point: CGPoint) -> Float{
        let x: CGFloat = point.x;
        let starWidthWithPadding: CGFloat = starSize.width + self.padding;
        var currentRating:CGFloat = (x / starWidthWithPadding) + 1;
        var fractional:CGFloat = CGFloat(fmodf(Float(currentRating), 1))
        fractional = CGFloat(roundf(Float(fractional) * 2.0) / 2.0);
        
        if (!self.allowsHalfIntegralRatings) {
            fractional = 0.5;
        }
        let newRating = Int(currentRating)
        currentRating = CGFloat(newRating) + fractional - 0.5;
        currentRating = max(1, min(currentRating, CGFloat(numberOfStars)))
        return Float(currentRating);
        
    }
    
    override func draw(_ rect: CGRect) {
        
        var drawPoint = CGPoint(x: self.padding, y: 0)
        for i in 0..<numberOfStars {
            let starRect = CGRect(x:drawPoint.x, y:drawPoint.y, width:self.starSize.width, height:self.starSize.height);
            self.drawStarAtPoint(frame: starRect, starNumber: i)
            drawPoint.x = drawPoint.x + (self.starSize.width + self.padding);
            
        }
        self.setNeedsDisplay()
        
    }
    
    @objc func drawStarAtPoint(frame: CGRect, starNumber: Int) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        // Star Drawing
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.00000 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.60940 * frame.width, y: frame.minY + 0.34942 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.97553 * frame.width, y: frame.minY + 0.34549 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.67702 * frame.width, y: frame.minY + 0.55752 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.79389 * frame.width, y: frame.minY + 0.90451 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.68613 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.20611 * frame.width, y: frame.minY + 0.90451 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.32298 * frame.width, y: frame.minY + 0.55752 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.02447 * frame.width, y: frame.minY + 0.34549 * frame.height))
        starPath.addLine(to: CGPoint(x: frame.minX + 0.39060 * frame.width, y: frame.minY + 0.34942 * frame.height))
        starPath.close()
        context.saveGState()
        starPath.addClip()
        gradientFillForStar(starBounds: starPath.cgPath.boundingBox, starNumber:starNumber);
        context.restoreGState()
        strokeColor.setStroke()
        starPath.lineWidth = lineWidth
        starPath.stroke()
        
    }
    @objc func gradientFillForStar(starBounds : CGRect, starNumber: Int) {
        let fillPercentage: CGFloat = self.fillPercentage(forStarNumber: starNumber)
        let startColor: UIColor? = fillColor
        let endColor: UIColor? = unfilledColor
        let context: CGContext? = UIGraphicsGetCurrentContext()
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let gradientColors = [startColor?.cgColor, endColor?.cgColor, endColor?.cgColor]
        let gradientLocations = [fillPercentage, fillPercentage, fillPercentage]
        let gradient: CGGradient = CGGradient(colorsSpace: colorSpace, colors: (gradientColors as? CFArray)!, locations: gradientLocations)!
        context?.drawLinearGradient(gradient, start: CGPoint(x: starBounds.minX, y: starBounds.midY), end: CGPoint(x: starBounds.maxX, y: starBounds.midY), options: [])
    }
    
    func fillPercentage(forStarNumber starNumber: Int) -> CGFloat {
        let star = Float(starNumber) + 1
        if star <= rating {
            return 1.0
        }
        else if Float(star - 0.5) <= rating {
            return 0.5
        }
        else {
            return 0
        }
    }
    
    
    override var intrinsicContentSize: CGSize {
        var starSize: CGSize = self.starSize
        starSize = CGSize(width: starSize.width + 1, height: starSize.width + 1)
        let width = (starSize.width * CGFloat(numberOfStars)) + (padding * CGFloat(numberOfStars))
        
        return CGSize(width: width, height: starSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
}
