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

extension UIView {
    open class PopupView: UIView {
        public let gestureButton: GestureButton = {
            let button = GestureButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

        public let popupView: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            view.backgroundColor = .clear
            return view
        }()

        public let navigationBar: UINavigationBar = {
            let navigationBar = UINavigationBar(frame: .zero)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            navigationBar.isTranslucent = false
            navigationBar.pushItem(UINavigationItem(), animated: false)
            return navigationBar
        }()

        public let view: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(light: UIColor(white: 255/255, alpha: 1), dark: UIColor(white: 0/255, alpha: 1))
            return view
        }()

        open var gestureButtonColor: UIColor {
            set {
                self.gestureButton.gestureColor = newValue
            }
            get {
                return self.gestureButton.gestureColor
            }
        }

        open var gestureButtonWidth: CGFloat {
            set {
                self.gestureButton.gestureWidth = newValue
            }
            get {
                return self.gestureButton.gestureWidth
            }
        }
        
        open var gestureButtonHeight: CGFloat {
            set {
                self.gestureButton.gestureHeight = newValue
            }
            get {
                return self.gestureButton.gestureHeight
            }
        }

        open var gesturePadding: CGFloat {
            set {
                self.gestureButton.gesturePadding = newValue
            }
            get {
                return self.gestureButton.gesturePadding
            }
        }

        open var corners: UIRectCorner = [.topLeft, .topRight] {
            didSet {
                self.updateCorner()
            }
        }

        open var cornerRadius: CGFloat = 16 {
            didSet {
                self.updateCorner()
            }
        }
        
        open var isNavigationBar: Bool = true {
            didSet {
                self.navigationBar.constraints.filter({ $0.firstAttribute == .height }).first?.constant = self.isNavigationBar ? self.navigationHeight : 0
            }
        }

        open var navigationBarTintColor: UIColor = UIColor(light: UIColor(white: 248/255, alpha: 1), dark: UIColor(white: 24/255, alpha: 1)) {
            didSet {
                self.navigationBar.barTintColor = self.navigationBarTintColor
            }
        }
        
        open var isShow: Bool {
            set {
                self.constraints.filter({ $0.firstAttribute == .height }).first?.constant = newValue ? self.height : 0
            }
            get {
                return (self.constraints.filter({ $0.firstAttribute == .height }).first?.constant ?? 0) != 0
            }
        }
        
        open var height: CGFloat = (UIScreen.main.bounds.height / 4 * 3)
        open var isDynamicGesture = false

        private var navigationHeight: CGFloat {
            return UIApplication.shared.currentWindow?.safe.top ?? 0
        }

        public init() {
            super.init(frame: .zero)
            
            self.clipsToBounds = true
            self.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundColor = .clear

            self.addSubview(self.popupView)
            self.addSubview(self.gestureButton)
            self.popupView.addSubview(self.navigationBar)
            self.popupView.addSubview(self.view)

            self.addConstraints([
                NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
            ])

            self.addConstraints([
                NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.gestureButton, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.gestureButton, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.gestureButton, attribute: .trailing, multiplier: 1, constant: 0)
            ])
            
            self.addConstraints([
                NSLayoutConstraint(item: self.gestureButton, attribute: .bottom, relatedBy: .equal, toItem: self.popupView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.popupView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.popupView, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.popupView, attribute: .bottom, multiplier: 1, constant: 0).priority(900)
            ])
            
            self.popupView.addConstraints([
                NSLayoutConstraint(item: self.popupView, attribute: .leading, relatedBy: .equal, toItem: self.navigationBar, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.popupView, attribute: .trailing, relatedBy: .equal, toItem: self.navigationBar, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.popupView, attribute: .top, relatedBy: .equal, toItem: self.navigationBar, attribute: .top, multiplier: 1, constant: 0)
            ])

            self.navigationBar.addConstraints([
                NSLayoutConstraint(item: self.navigationBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.navigationHeight)
            ])

            self.popupView.addConstraints([
                NSLayoutConstraint(item: self.navigationBar, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.popupView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.popupView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.popupView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
            ])
            
            self.navigationBar.barTintColor = self.navigationBarTintColor
            
            self.gestureButton.addTarget(self, action: #selector(self.touchDrag(_:forEvent:)), for: .touchDragInside)
            self.gestureButton.addTarget(self, action: #selector(self.touchUp(_:forEvent:)), for: .touchUpInside)
        }
        
        open func updateCorner() {
            if self.popupView.bounds.height > self.navigationHeight {
                self.popupView.roundCorners(self.corners, radius: self.cornerRadius)
            }
        }
        
        open override func layoutSubviews() {
            self.updateCorner()
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open func show(_ duration: TimeInterval = 0.3, animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
            self.constraints.filter({ $0.firstAttribute == .height }).first?.constant = self.height
            UIView.animate(withDuration: duration, animations: {
                self.superview?.layoutIfNeeded()
                self.updateCorner()
                animations?()
            }, completion: { (_) in
                self.updateCorner()
                completion?()
            })
        }
        
        open func hide(_ duration: TimeInterval = 0.3, animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
            self.constraints.filter({ $0.firstAttribute == .height }).first?.constant = 0
            UIView.animate(withDuration: duration, animations: {
                self.superview?.layoutIfNeeded()
                self.updateCorner()
                animations?()
            }, completion: { (_) in
                self.updateCorner()
                completion?()
            })
        }
        
        @objc private func touchDrag(_ sender: UIButton, forEvent event: UIEvent) {
            guard let touch = event.touches(for: sender)?.first else { return }
            let previousLocation = touch.previousLocation(in: self)
            let location = touch.location(in: self)
            let pointY = location.y - previousLocation.y
            self.constraints.filter({ $0.firstAttribute == .height }).first?.constant -= pointY
        }

        @objc private func touchUp(_ sender: UIButton, forEvent event: UIEvent) {
            if !self.isDynamicGesture {
                guard let touch = event.touches(for: sender)?.first else { return }
                guard let height = self.constraints.filter({ $0.firstAttribute == .height }).first?.constant else { return }
                let previousLocation = touch.previousLocation(in: self)
                let location = touch.location(in: self)
                let pointY = location.y - previousLocation.y
                let isTop = pointY <= 0
                if isTop {
                    if height > self.height / 3 {
                        self.show()
                    } else {
                        self.hide()
                    }
                } else {
                    if height > self.height / 6 * 5 {
                        self.show()
                    } else {
                        self.hide()
                    }
                }
            }
        }
    }
}

extension UIView {
    open class GestureButton: UIButton {
        public let gestureView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isUserInteractionEnabled = false
            return view
        }()

        open var gestureColor: UIColor = UIColor(light: UIColor(white: 240/255, alpha: 1), dark: UIColor(white: 40/255, alpha: 1)) {
            didSet {
                self.gestureView.backgroundColor = self.gestureColor
            }
        }

        open var gestureWidth: CGFloat = 60 {
            didSet {
                self.gestureView.constraints.filter({ $0.firstAttribute == .width }).first?.constant = self.gestureWidth
            }
        }

        open var gestureHeight: CGFloat = 8 {
            didSet {
                self.gestureView.constraints.filter({ $0.firstAttribute == .height }).first?.constant = self.gestureHeight
                self.gestureView.layer.cornerRadius = self.gestureHeight / 2
            }
        }

        open var gesturePadding: CGFloat = 8 {
            didSet {
                self.constraints.filter({ $0.firstAttribute == .top && $0.secondAttribute == .top }).first?.constant = -self.gesturePadding
                self.constraints.filter({ $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }).first?.constant = self.gesturePadding
            }
        }

        open override var isHighlighted: Bool {
            didSet {
                if self.isHighlighted {
                    self.gestureView.backgroundColor = UIColor(light: UIColor(white: 218/255, alpha: 1), dark: UIColor(white: 70/255, alpha: 1))
                } else {
                    self.gestureView.backgroundColor = UIColor(light: UIColor(white: 240/255, alpha: 1), dark: UIColor(white: 40/255, alpha: 1))
                }
            }
        }

        public convenience init() {
            self.init(type: .system)
            
            self.clipsToBounds = true

            self.addSubview(self.gestureView)
            
            self.addConstraints([
                NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.gestureView, attribute: .top, multiplier: 1, constant: -self.gesturePadding),
                NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.gestureView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.gestureView, attribute: .bottom, multiplier: 1, constant: self.gesturePadding)
            ])
            
            self.gestureView.addConstraints([
                NSLayoutConstraint(item: self.gestureView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.gestureWidth),
                NSLayoutConstraint(item: self.gestureView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.gestureHeight)
            ])
            
            self.gestureView.backgroundColor = self.gestureColor
            self.gestureView.layer.cornerRadius = self.gestureHeight / 2
        }
    }
}
