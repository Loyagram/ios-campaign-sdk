
import Foundation
import UIKit

class PathManager {
    // MARK: Paths
    var size: CGFloat = 0
    var lineWidth: CGFloat = 0
    func pathForBox() -> UIBezierPath? {
        var path: UIBezierPath?
        let radius: CGFloat = (size / 2.0) - (lineWidth / 2.0)
        path = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: radius, startAngle: CGFloat((-Float.pi / 4)), endAngle: CGFloat((2 * Float.pi - .pi / 4)), clockwise: true)
        
        return path
    }
    
    func pathForCheckMark() -> UIBezierPath? {
        let checkMarkPath = UIBezierPath()
        checkMarkPath.move(to: CGPoint(x: size / 3.1578, y: size / 2))
        checkMarkPath.addLine(to: CGPoint(x: size / 2.0618, y: size / 1.57894))
        checkMarkPath.addLine(to: CGPoint(x: size / 1.3953, y: size / 2.7272))
        return checkMarkPath
    }
    
    func pathForLongCheckMark() -> UIBezierPath? {
        let checkMarkPath = UIBezierPath()
        checkMarkPath.move(to: CGPoint(x: size / 3.1578, y: size / 2))
        checkMarkPath.addLine(to: CGPoint(x: size / 2.0618, y: size / 1.57894))
        checkMarkPath.addLine(to: CGPoint(x: size / 1.1553, y: size / 5.9272))
        return checkMarkPath
    }
    
    func pathForFlatCheckMark() -> UIBezierPath? {
        let flatCheckMarkPath = UIBezierPath()
        flatCheckMarkPath.move(to: CGPoint(x: size / 4, y: size / 2))
        flatCheckMarkPath.addLine(to: CGPoint(x: size / 2, y: size / 2))
        flatCheckMarkPath.addLine(to: CGPoint(x: size / 1.2, y: size / 2))
        return flatCheckMarkPath
    }
}

