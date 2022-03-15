//
//  tabBarVC.swift
//  Yumn
//
//  Created by Modhi Abdulaziz on 18/07/1443 AH.
//

import UIKit
//@IBDesignable
class TabBarVC: UITabBar {

//private var shapeLayer: CALayer?
    private var shapeLayer: CALayer?

    @IBInspectable var height: CGFloat = 0.0


        override func draw(_ rect: CGRect) {
            self.addShape()
//            self.layer.shadowOffset = CGSize(width: 0, height: 10)
//            self.layer.shadowRadius = 10
//            self.layer.shadowColor = #colorLiteral(red: 0.504814744, green: 0.5049032569, blue: 0.5048031211, alpha: 1)
//            self.layer.shadowOpacity = 0.8
        }

        private func addShape() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = createPath()
            shapeLayer.strokeColor = #colorLiteral(red: 0.8700879812, green: 0.8649161458, blue: 0.8740638494, alpha: 1)
            shapeLayer.fillColor = #colorLiteral(red: 0.9782002568, green: 0.9782230258, blue: 0.9782107472, alpha: 1)
            shapeLayer.lineWidth = 0.1
            shapeLayer.shadowOffset = CGSize(width: 0, height: 10)
            shapeLayer.shadowRadius = 10
            shapeLayer.shadowColor = #colorLiteral(red: 0.504814744, green: 0.5049032569, blue: 0.5048031211, alpha: 1)
            shapeLayer.shadowOpacity = 0.5

            if let oldShapeLayer = self.shapeLayer {
                self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
            } else {
                self.layer.insertSublayer(shapeLayer, at: 0)
            }
            self.shapeLayer = shapeLayer
        }

        func createPath() -> CGPath {
            let height: CGFloat = 86.0
            let path = UIBezierPath()
            let centerWidth = self.frame.width / 2
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
            path.addCurve(to: CGPoint(x: centerWidth, y: height - 43),
                          controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
            path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                          controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
            path.addLine(to: CGPoint(x: self.frame.width, y: 0))
            path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            path.addLine(to: CGPoint(x: 0, y: self.frame.height))
            path.close()
            return path.cgPath
        }

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
            for member in subviews.reversed() {
                let subPoint = member.convert(point, from: self)
                guard let result = member.hitTest(subPoint, with: event) else { continue }
                return result
            }
            return nil
        }
    }

    extension UITabBar {
        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 90 // 74 - 90 
            return sizeThatFits
        }
    }
