
import Foundation
import UIKit
class AnimationManager: NSObject {
    
    var animationDuration: CGFloat!
    init(animationDuration: CGFloat) {
        super.init()
        self.animationDuration = animationDuration
        
    }
    
    func strokeAnimationReverse(_ reverse: Bool) -> CABasicAnimation? {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        if reverse {
            animation.fromValue = 1.0
            animation.toValue = 0.0
        }
        else {
            animation.fromValue = 0.0
            animation.toValue = 1.0
        }
        animation.duration = CFTimeInterval(animationDuration)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    func opacityAnimationReverse(_ reverse: Bool) -> CABasicAnimation? {
        let animation = CABasicAnimation(keyPath: "opacity")
        if reverse {
            animation.fromValue = 1.0
            animation.toValue = 0.0
        }
        else {
            animation.fromValue = 0.0
            animation.toValue = 1.0
        }
        animation.duration = CFTimeInterval(animationDuration)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    
    func fillAnimation(withBounces bounces: Int, amplitude: CGFloat, reverse: Bool) -> CAKeyframeAnimation? {
        var values = [AnyHashable]()
        var keyTimes = [AnyHashable]()
        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))
        }
        else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 0)))
        }
        keyTimes.append(0.0)
        for i in 1...bounces {
            var scale:CGFloat
            if( i % 2 == 1) {
               scale = 1 + amplitude / CGFloat(i)
            } else {
                scale = 1 - amplitude / CGFloat(i)
            }
            let time:CGFloat = ((CGFloat(i) * 1.0 / (CGFloat(bounces) + 1)))
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, scale)))
            keyTimes.append(time)
        }
        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)))
        }
        else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))
        }
        keyTimes.append(1.0)
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = values
        animation.keyTimes = keyTimes as? [NSNumber]
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = CFTimeInterval(animationDuration)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
}
