
import Foundation
import UIKit

class CheckBox: UIControl, CAAnimationDelegate {
    enum AnimationType : Int {
        case stroke
        case bounce
        case flat
        case oneStroke
        case fade
    }
    var on:  Bool!
    var lineWidth:  CGFloat!
    var animationDuration:  CGFloat!
    var hideBox:  Bool!
    var onTintColor:  UIColor!
    var onFillColor:  UIColor!
    var offFillColor:  UIColor!
    var onCheckColor:  UIColor!
    //var tintColor:  UIColor?
    //var group: BEMCheckBoxGroup?
    //var boxType: BoxType?
    var onAnimationType: String!
    var offAnimationType: String!
    var minimumTouchSize:  CGSize!
    var pathManager : PathManager!
    var animationManager : AnimationManager!
    var offBoxLayer = CAShapeLayer()
    var onBoxLayer = CAShapeLayer()
    var checkMarkLayer = CAShapeLayer()
    var isTickShown = false
    var colorPrimary = UIColor.lightGray
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func commonInit() {
        // Default values
        on = false
        hideBox = false
        onTintColor = UIColor.clear
        onFillColor = UIColor.clear
        offFillColor = UIColor.clear
        onCheckColor = UIColor.clear
        tintColor = UIColor.clear
        lineWidth = 3.0
        animationDuration = 0.5
        minimumTouchSize = CGSize(width:44, height:44)
        onAnimationType = "stroke"
        offAnimationType = "stroke"
        self.backgroundColor = UIColor.clear
        self.initPathManager()
        self.initAnimationManager()
    }
    
    func setColorPrimary(color:UIColor) {
        colorPrimary = color
    }
    
    func initPathManager() {
        pathManager = PathManager()
        pathManager.lineWidth = lineWidth
    }
    
    func initAnimationManager() {
        animationManager = AnimationManager(animationDuration: animationDuration)
    }
    
    override func layoutSubviews() {
        self.pathManager.size = frame.height
        super.layoutSubviews()
    }
    
    func intrinsicContentSize() -> CGSize {
        return self.frame.size
    }
    
    func reload() {
        self.offBoxLayer.removeFromSuperlayer()
        self.offBoxLayer = CAShapeLayer()
        self.onBoxLayer.removeFromSuperlayer()
        self.onBoxLayer =  CAShapeLayer()
        self.checkMarkLayer.removeFromSuperlayer()
        self.checkMarkLayer =  CAShapeLayer()
        self.setNeedsDisplay()
        self.layoutIfNeeded()
    }
    
    // MARK: Setters
    func _set(on: Bool, animated: Bool, notifyGroup: Bool) {
        self.on = on
        drawEntireCheckBox()
        if on {
            if animated {
                addOnAnimation()
            }
        }
        else {
            onBoxLayer.removeFromSuperlayer()
            checkMarkLayer.removeFromSuperlayer()
        }
       
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        _set(on: on, animated: animated, notifyGroup: true)
    }
    
    func setOn(_ on: Bool) {
        setOn(on, animated: false)
    }

    @objc func showCheckMarkAnimation() {
        self.perform(#selector(showStrokeAnimation), with: self, afterDelay: 0)
        self.perform(#selector(showFillAnimation), with: self, afterDelay: 0.5)
        //sendActions(for: .valueChanged)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var found: Bool = super.point(inside: point, with: event)
        if found {
            return found
        }
        let minimumSize: CGSize = minimumTouchSize
        let width: CGFloat = bounds.width
        let height: CGFloat = bounds.height
        if found == false && (width < minimumSize.width || height < minimumSize.height) {
            let increaseWidth: CGFloat = minimumSize.width - width
            let increaseHeight: CGFloat = minimumSize.height - height
            let rect: CGRect = bounds.insetBy(dx: -increaseWidth / 2, dy: -increaseHeight / 2)
            found = rect.contains(point)
        }
        return found
    }
    
    // MARK: Drawings
    override func draw(_ rect: CGRect) {
        setOn(on, animated: false)
    }
    
    /** Draws the entire checkbox, depending on the current state of the on property.
     */
    func drawEntireCheckBox() {
        if !hideBox {
            if !(offBoxLayer.path?.boundingBox.height == 0.0) {
                drawOffBox()
            }
            if on {
                drawOnBox()
            }
        }
        if on {
            drawCheckMark()
        }
    }
    
    func drawOffBox() {
        offBoxLayer.removeFromSuperlayer()
        offBoxLayer = CAShapeLayer()
        offBoxLayer.frame = bounds
        offBoxLayer.path = pathManager.pathForBox()?.cgPath
        offBoxLayer.fillColor = offFillColor.cgColor
        offBoxLayer.strokeColor = tintColor?.cgColor
        offBoxLayer.lineWidth = lineWidth
        offBoxLayer.rasterizationScale = 2.0 * UIScreen.main.scale
        offBoxLayer.shouldRasterize = true
        layer.addSublayer(offBoxLayer)
    }
    
    /** Draws the box when the checkbox is set to On.
     */
    func drawOnBox() {
        onBoxLayer.removeFromSuperlayer()
        onBoxLayer = CAShapeLayer()
        onBoxLayer.frame = bounds
        onBoxLayer.path = pathManager.pathForBox()?.cgPath
        onBoxLayer.lineWidth = lineWidth
        onBoxLayer.fillColor = onFillColor.cgColor
        onBoxLayer.strokeColor = onTintColor?.cgColor
        onBoxLayer.rasterizationScale = 2.0 * UIScreen.main.scale
        onBoxLayer.shouldRasterize = true
        layer.addSublayer(onBoxLayer)
    }
    
    /** Draws the check mark when the checkbox is set to On.
     */
    func drawCheckMark() {
        checkMarkLayer.removeFromSuperlayer()
        checkMarkLayer = CAShapeLayer()
        checkMarkLayer.frame = bounds
        checkMarkLayer.path = pathManager.pathForCheckMark()?.cgPath
        checkMarkLayer.strokeColor = onCheckColor.cgColor
        checkMarkLayer.lineWidth = lineWidth
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.lineCap = kCALineCapRound
        checkMarkLayer.lineJoin = kCALineJoinRound
        checkMarkLayer.rasterizationScale = 2.0 * UIScreen.main.scale
        checkMarkLayer.shouldRasterize = true
        layer.addSublayer(checkMarkLayer)
    }
    func addOnAnimation() {
        self.animationDuration = 0.5
        switch self.onAnimationType {
        case "stroke":
            let animation: CABasicAnimation = self.animationManager.strokeAnimationReverse(false)!
            self.onBoxLayer.add(animation, forKey: "strokeEnd")
            animation.delegate = self
            self.checkMarkLayer.add(animation, forKey: "strokeEnd")
            return
        case "fill":
            let wiggle: CAKeyframeAnimation = self.animationManager.fillAnimation(withBounces: 1, amplitude: 0.18, reverse: false)!
            let opacityAnimation: CABasicAnimation = self.animationManager.opacityAnimationReverse(false)!
            opacityAnimation.delegate = self
            self.onBoxLayer.add(wiggle, forKey: "transform")
            self.checkMarkLayer.add(opacityAnimation, forKey: "opacity")
            return
            
        default:
            
            return
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            if on == false {
                onBoxLayer.removeFromSuperlayer()
                checkMarkLayer.removeFromSuperlayer()
            }
            
        }
    }
    
    deinit {
        //delegate = nil
    }
    
    @objc func showStrokeAnimation() {
        onTintColor = colorPrimary
        setOn(!on, animated: true)
    }
    @objc func showFillAnimation() {
        if(!isTickShown) {
            isTickShown = true
            onFillColor = colorPrimary
            offFillColor = UIColor.clear
            onCheckColor = UIColor.white
            onAnimationType = "fill"
            offAnimationType = "fill"
            setOn(on, animated: true)
            //sendActions(for: .valueChanged)
        }
    }
}

