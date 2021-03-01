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

extension UITableView {
    open class Base: UITableView {
        open var isEmptyView: Bool = false
        open var isEmptyViewInset: Bool = true
        open var touchesBeganSuperview: Bool = false

        open var emptyView: EmptyView? {
            didSet {
                oldValue?.removeFromSuperview()
                self.reloadEmptyView()
            }
        }
        
        private func ifExistAddEmptyView(animationDuration: TimeInterval) {
            if let view = self.emptyView {
                if !self.subviews.contains(view) {
                    self.addSubview(view)
                    self.addConstraints([
                        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).identifier(.top),
                        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0).identifier(.height)
                    ])
                }

                if self.isEmptyViewInset {
                    self.constraints(identifierType: .top).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = -self.contentInset.top
                    self.constraints(identifierType: .height).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = self.contentInset.bottom
                }
                
                if animationDuration == 0 {
                    self.layoutIfNeeded()
                } else {
                    UIView.animate(withDuration: animationDuration) {
                        self.layoutIfNeeded()
                    }
                }
            }
        }
        
        open func reloadEmptyView(animationDuration: TimeInterval = 0.0) {
            if self.isEmptyView {
                if self.numberOfSections == 0 {
                    self.emptyView?.isHidden = false
                    self.emptyView?.isUserInteractionEnabled = true
                    self.ifExistAddEmptyView(animationDuration: animationDuration)
                } else {
                    if (0..<self.numberOfSections).compactMap({ self.numberOfRows(inSection: $0) }).reduce(0, +) == 0 {
                        self.emptyView?.isHidden = false
                        self.emptyView?.isUserInteractionEnabled = true
                        self.ifExistAddEmptyView(animationDuration: animationDuration)
                    } else {
                        self.emptyView?.isHidden = true
                        self.emptyView?.isUserInteractionEnabled = false
                    }
                }
            } else {
                self.emptyView?.isHidden = true
                self.emptyView?.isUserInteractionEnabled = false
            }
        }
        
        open func updateContentInset(_ inset: UIEdgeInsets, notification: Notification) {
            self.contentInset = inset
            self.reloadEmptyView(animationDuration: notification.duration)
        }
        
        open override func reloadData() {
            super.reloadData()
            self.reloadEmptyView()
        }
        
        open override func endUpdates() {
            super.endUpdates()
            self.reloadEmptyView()
        }
        
        open override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
            super.reloadSections(sections, with: animation)
            self.reloadEmptyView()
        }
        
        open override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
            super.reloadRows(at: indexPaths, with: animation)
            self.reloadEmptyView()
        }
        
        open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if self.touchesBeganSuperview {
                self.superview?.touchesBegan(touches, with: event)
            } else {
                super.touchesBegan(touches, with: event)
            }
        }
    }
}
