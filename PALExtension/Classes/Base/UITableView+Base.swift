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
                if let view = self.emptyView {
                    self.superview?.insertSubview(view, aboveSubview: self)
                    self.superview?.addConstraints([
                        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).identifier(.top),
                        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).identifier(.bottom)
                    ])
                }
                self.reloadEmptyView()
            }
        }
        
        open override var contentInset: UIEdgeInsets {
            didSet {
                self.reloadEmptyView()
            }
        }
        
        open func reloadEmptyView() {
            if self.isEmptyView {
                if self.numberOfSections == 0 {
                    self.emptyView?.isHidden = false
                    self.emptyView?.isUserInteractionEnabled = true
                } else {
                    if (0..<self.numberOfSections).compactMap({ self.numberOfRows(inSection: $0) }).reduce(0, +) == 0 {
                        self.emptyView?.isHidden = false
                        self.emptyView?.isUserInteractionEnabled = true
                    } else {
                        self.emptyView?.isHidden = true
                        self.emptyView?.isUserInteractionEnabled = false
                    }
                }
                if self.isEmptyViewInset {
                    self.superview?.constraints(identifierType: .top).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = -self.contentInset.top
                    self.superview?.constraints(identifierType: .bottom).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = self.contentInset.bottom
                } else {
                    self.superview?.constraints(identifierType: .top).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = 0
                    self.superview?.constraints(identifierType: .bottom).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = 0
                }
            } else {
                self.emptyView?.isHidden = true
                self.emptyView?.isUserInteractionEnabled = false
                self.superview?.constraints(identifierType: .top).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = 0
                self.superview?.constraints(identifierType: .bottom).filter({ ($0.firstItem as? UIView) == self && ($0.secondItem as? UIView) == self.emptyView }).first?.constant = 0
            }
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
