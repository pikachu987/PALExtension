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

open class EmptyImageTextButtonView: EmptyView {
    public let textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public let button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
}

open class EmptyImageButtonView: EmptyView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public let button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
}

open class EmptyTextButtonView: EmptyView {
    public let textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public let button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
}

open class EmptyImageTextView: EmptyView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    public let textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
}

open class EmptyImageView: EmptyView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

}

open class EmptyTextView: EmptyView {
    public let textLabel: UILabel = {
        let label = UILabel()
        return label
    }()

}

open class EmptyView: UIView {
    public init() {
        super.init(frame: .zero)
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 50/255, alpha: 1)
        self.addSubview(view)
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100),
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITableView {
    open class Base: UITableView {
        open var isEmptyView: Bool = false
        open var isEmptyViewInset: Bool = true

        open var emptyView: EmptyView? {
            didSet {
                oldValue?.removeFromSuperview()
                if let view = self.emptyView {
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.addSubview(view)
                    let topContraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
                    topContraint.identifier(.top)
                    let bottomContraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                    bottomContraint.identifier(.bottom)
                    self.addConstraints([
                        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                        topContraint,
                        bottomContraint
                    ])
                    self.emptyView?.backgroundColor = UIColor(red: 33/255, green: 1/255, blue: 125/255, alpha: 1)
                    self.backgroundColor = UIColor(red: 180/255, green: 1/255, blue: 15/255, alpha: 1)
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
                } else {
                    if (0..<self.numberOfSections).compactMap({ self.numberOfRows(inSection: $0) }).reduce(0, +) == 0 {
                        self.emptyView?.isHidden = false
                    } else {
                        self.emptyView?.isHidden = true
                    }
                }
//                if self.isEmptyViewInset {
//                    self.constraints(identifierType: .top).first?.constant = self.contentInset.top
//                    self.constraints(identifierType: .bottom).first?.constant = self.contentInset.bottom
//                } else {
//                    self.constraints(identifierType: .top).first?.constant = 0
//                    self.constraints(identifierType: .bottom).first?.constant = 0
//                }
            } else {
                self.emptyView?.isHidden = true
//                self.constraints(identifierType: .top).first?.constant = 0
//                self.constraints(identifierType: .bottom).first?.constant = 0
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
            self.superview?.touchesBegan(touches, with: event)
        }
    }
}
