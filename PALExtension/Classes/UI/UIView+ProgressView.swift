//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

// 뷰 + 인디게이터 뷰
public extension UIView {

    class CircleProgressView: UIView {
        var progressLayer: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeEnd = 0.0
            return layer
        }()

        var trackLayer: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeEnd = 1.0
            return layer
        }()

        var progressColor: UIColor? {
            get {
                if let color = self.progressLayer.strokeColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                self.progressLayer.strokeColor = newValue?.cgColor
            }
        }

        var trackColor: UIColor? {
            get {
                if let color = self.trackLayer.strokeColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                self.trackLayer.strokeColor = newValue?.cgColor
            }
        }

        var progressLineWidth: CGFloat {
            get {
                return self.progressLayer.lineWidth
            }
            set {
                self.progressLayer.lineWidth = newValue
            }
        }

        var trackLineWidth: CGFloat {
            get {
                return self.trackLayer.lineWidth
            }
            set {
                self.trackLayer.lineWidth = newValue
            }
        }

        var progress: CGFloat {
            get {
                return self.progressLayer.strokeEnd
            }
            set {
                self.progressLayer.strokeEnd = newValue
            }
        }

        var isProgress: Bool {
            guard let sublayers = self.layer.sublayers else { return false }
            if sublayers.contains(self.trackLayer) && sublayers.contains(self.progressLayer) {
                return true
            }
            return false
        }

        func addProgressIndicator(_ color: UIColor? = nil) {
            self.removeProgressIndicator()
            if let color = color {
                self.backgroundColor = color
            }
            self.layoutIfNeeded()
            self.layer.cornerRadius = self.frame.size.width/2
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: self.frame.size.width/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)

            self.layer.addSublayer(self.trackLayer)
            self.layer.addSublayer(self.progressLayer)

            self.trackLayer.path = circlePath.cgPath
            self.trackLayer.strokeColor = self.trackColor?.cgColor
            self.trackLayer.lineWidth = self.trackLineWidth

            self.progressLayer.path = circlePath.cgPath
            self.progressLayer.strokeColor = self.progressColor?.cgColor
            self.progressLayer.lineWidth = self.trackLineWidth
            self.progressLayer.strokeEnd = 0
        }

        func removeProgressIndicator() {
            guard let sublayers = self.layer.sublayers else { return }
            if sublayers.contains(self.trackLayer) {
                self.trackLayer.removeFromSuperlayer()
            }

            if sublayers.contains(self.progressLayer) {
                self.progressLayer.removeFromSuperlayer()
                self.progressLayer.strokeEnd = 0
            }
        }

        func setProgressWithAnimation(duration: TimeInterval, value: Float) {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = self.progressLayer.strokeEnd
            animation.toValue = value
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            self.progressLayer.strokeEnd = CGFloat(value)
            self.progressLayer.add(animation, forKey: "animateprogress")
        }
    }
}
