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

    var isIndicator: Bool {
        return !self.subviews.compactMap({ $0 as? IndicatorActivityView }).isEmpty
    }
    
    var isIndicatorDim: Bool {
        return !self.subviews.compactMap({ $0 as? IndicatorDimView }).isEmpty
    }
    

    var indicators: [UIView] {
        return self.subviews.filter({ $0 as? IndicatorActivityView != nil })
    }
    
    var indicatorDims: [UIView] {
        return self.subviews.filter({ $0 as? IndicatorDimView != nil })
    }

    // 추가
    @discardableResult
    func addIndicator(_ color: UIColor, size: CGFloat = 44, dimColor: UIColor? = nil) -> UIView {
        var dimView: UIView?
        if let dimColor = dimColor {
            dimView = IndicatorDimView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            dimView?.backgroundColor = dimColor
            dimView?.translatesAutoresizingMaskIntoConstraints = false
        }

        let indicatorView = IndicatorActivityView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        indicatorView.updateSize(size)
        DispatchQueue.main.async {
            if let dimView = dimView {
                self.addSubview(dimView)
                self.addConstraints([
                    NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: dimView, attribute: .leading, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: dimView, attribute: .trailing, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: dimView, attribute: .top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: dimView, attribute: .bottom, multiplier: 1, constant: 0),
                ])
            }
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(indicatorView)
            self.addConstraints([
                NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: indicatorView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: indicatorView, attribute: .centerY, multiplier: 1, constant: 0)
            ])
            indicatorView.addConstraints([
                NSLayoutConstraint(item: indicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: size),
                NSLayoutConstraint(item: indicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: size)
            ])
            indicatorView.startAndShowAnimating(color, size: CGSize(width: size, height: size))
        }
        return indicatorView
    }

    // 프로그래스
    func progressIndicator(_ progress: Double, decimalPlaces: Int = 1, textColor: UIColor = .white) {
        DispatchQueue.main.async {
            self.subviews.compactMap({ $0 as? IndicatorActivityView }).forEach({
                $0.progress(progress, decimalPlaces: decimalPlaces, textColor: textColor)
            })
        }
    }

    // 지우기
    func removeIndicators() {
        self.subviews.compactMap({ $0 as? IndicatorActivityView }).forEach({
            $0.stopAndHideAnimating()
            $0.removeFromSuperview()
        })
        self.subviews.compactMap({ $0 as? IndicatorDimView }).forEach({
            $0.removeFromSuperview()
        })
    }
    
    private class IndicatorDimView: UIView {
        
    }

    // 인디게이트 뷰
    private class IndicatorActivityView: UIView {
        private lazy var label: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.text = ""
            label.font = .systemFont(ofSize: 9)
            self.backgroundColor = UIColor(white: 255/255, alpha: 0.01)
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            self.addConstraints([
                NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 0),
            ])
            return label
        }()

        private var size: CGFloat = 44

        fileprivate func updateSize(_ size: CGFloat) {
            self.layer.cornerRadius = size/2
            self.size = size
        }

        // 프로그래스
        fileprivate func progress(_ progress: Double, decimalPlaces: Int, textColor: UIColor) {
            self.label.text = String(format: "%.\(decimalPlaces)f", progress).appending("%")
            self.label.textColor = textColor
        }

        // 애니메이션 시작
        fileprivate func startAndShowAnimating(_ color: UIColor = .black, size: CGSize) {
            self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            let size = CGSize(width: self.size, height: self.size)
            let beginTime: Double = 0.5
            let strokeStartDuration: Double = 1.2
            let strokeEndDuration: Double = 0.7

            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.byValue = Float.pi * 2
            #if swift(>=4.2)
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
            #else
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            #endif

            let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeEndAnimation.duration = strokeEndDuration
            strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
            strokeEndAnimation.fromValue = 0
            strokeEndAnimation.toValue = 1

            let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.duration = strokeStartDuration
            strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
            strokeStartAnimation.fromValue = 0
            strokeStartAnimation.toValue = 1
            strokeStartAnimation.beginTime = beginTime

            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
            groupAnimation.duration = strokeStartDuration + beginTime
            groupAnimation.repeatCount = .infinity
            groupAnimation.isRemovedOnCompletion = false
            #if swift(>=4.2)
            groupAnimation.fillMode = .forwards
            #else
            groupAnimation.fillMode = kCAFillModeForwards
            #endif

            let shapeLayer: CAShapeLayer = CAShapeLayer()
            let path: UIBezierPath = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: -(.pi / 2),
                        endAngle: .pi + .pi / 2,
                        clockwise: true)
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.backgroundColor = nil
            shapeLayer.path = path.cgPath
            shapeLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            let frame = CGRect(
                x: (self.layer.bounds.width - size.width) / 2,
                y: (self.layer.bounds.height - size.height) / 2,
                width: size.width,
                height: size.height
            )

            shapeLayer.frame = frame
            shapeLayer.add(groupAnimation, forKey: "animation")
            self.layer.addSublayer(shapeLayer)
        }

        // 애니메이션 중지
        fileprivate func stopAndHideAnimating() {
            self.layer.sublayers?.forEach({ $0.removeAllAnimations() })
            self.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
            self.layer.sublayers = nil
        }
    }
    
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
