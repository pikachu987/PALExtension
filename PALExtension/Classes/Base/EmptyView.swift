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

open class EmptyView: UIView {
    public init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.backgroundColor = UIColor(light: 236/255, dark: 45/255)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class EmptyTextView: EmptyView {
    public let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(light: 150/255, dark: 200/255)
        label.clipsToBounds = true
        return label
    }()
    
    public var textPadding: CGFloat = 20 {
        didSet {
            self.constraints(identifierType: .leading).first?.constant = -self.textPadding
            self.constraints(identifierType: .trailing).first?.constant = self.textPadding
        }
    }
    
    @discardableResult
    open func updateText(_ attributedText: NSAttributedString, padding: CGFloat = 20) -> EmptyTextView {
        self.textLabel.attributedText = attributedText
        self.textPadding = padding
        return self
    }
    
    @discardableResult
    open func updateText(_ text: String, font: UIFont = .systemFont(ofSize: 17), textColor: UIColor = UIColor(light: 150/255, dark: 200/255), padding: CGFloat = 20) -> EmptyTextView {
        self.textLabel.text = text
        self.textLabel.font = font
        self.textLabel.textColor = textColor
        self.textPadding = padding
        return self
    }

    public override init() {
        super.init()

        self.addSubview(self.textLabel)
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.textLabel, attribute: .leading, multiplier: 1, constant: -self.textPadding).priority(950).identifier(.leading),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.textLabel, attribute: .trailing, multiplier: 1, constant: self.textPadding).priority(951).identifier(.trailing),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.textLabel, attribute: .centerY, multiplier: 1, constant: 0)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class EmptyImageView: EmptyView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(light: 150/255, dark: 200/255)
        return imageView
    }()
    
    public var imageSize: CGFloat = 120 {
        didSet {
            self.imageView.constraints(identifierType: .width).first?.constant = self.imageSize
            self.imageView.constraints(identifierType: .height).first?.constant = self.imageSize
        }
    }

    @discardableResult
    open func updateImage(_ image: UIImage?, tintColor: UIColor = UIColor(light: 150/255, dark: 200/255), imageSize: CGFloat = 120) -> EmptyImageView {
        self.imageView.image = image
        self.imageView.tintColor = tintColor
        self.imageSize = imageSize
        return self
    }

    public override init() {
        super.init()

        self.addSubview(self.imageView)
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.imageView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.imageView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        self.imageView.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.imageSize).identifier(.width),
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.imageSize).identifier(.height)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class EmptyImageTextView: EmptyView {
    public let centerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(light: 150/255, dark: 200/255)
        return imageView
    }()

    public let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(light: 150/255, dark: 200/255)
        label.clipsToBounds = true
        return label
    }()
    
    public var textPadding: CGFloat = 20 {
        didSet {
            self.centerView.constraints(identifierType: .leading).first?.constant = -self.textPadding
            self.centerView.constraints(identifierType: .trailing).first?.constant = self.textPadding
        }
    }
    
    public var imageSize: CGFloat = 120 {
        didSet {
            self.imageView.constraints(identifierType: .width).first?.constant = self.imageSize
            self.imageView.constraints(identifierType: .height).first?.constant = self.imageSize
        }
    }
    
    @discardableResult
    open func updateText(_ attributedText: NSAttributedString, padding: CGFloat = 20) -> EmptyImageTextView {
        self.textLabel.attributedText = attributedText
        self.textPadding = padding
        return self
    }
    
    @discardableResult
    open func updateText(_ text: String, font: UIFont = .systemFont(ofSize: 17), textColor: UIColor = UIColor(light: 150/255, dark: 200/255), padding: CGFloat = 20) -> EmptyImageTextView {
        self.textLabel.text = text
        self.textLabel.font = font
        self.textLabel.textColor = textColor
        self.textPadding = padding
        return self
    }
    
    @discardableResult
    open func updateImage(_ image: UIImage?, tintColor: UIColor = UIColor(light: 150/255, dark: 200/255), imageSize: CGFloat = 120) -> EmptyImageTextView {
        self.imageView.image = image
        self.imageView.tintColor = tintColor
        self.imageSize = imageSize
        return self
    }
    
    public override init() {
        super.init()
        
        self.addSubview(self.centerView)
        self.centerView.addSubview(self.imageView)
        self.centerView.addSubview(self.textLabel)
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.centerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.centerView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.centerView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.centerView, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.centerView, attribute: .centerX, relatedBy: .equal, toItem: self.imageView, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        
        self.imageView.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.imageSize).identifier(.width),
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.imageSize).identifier(.height)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.textLabel, attribute: .top, multiplier: 1, constant: -20)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.centerView, attribute: .leading, relatedBy: .equal, toItem: self.textLabel, attribute: .leading, multiplier: 1, constant: -self.textPadding).priority(950).identifier(.leading),
            NSLayoutConstraint(item: self.centerView, attribute: .trailing, relatedBy: .equal, toItem: self.textLabel, attribute: .trailing, multiplier: 1, constant: self.textPadding).priority(951).identifier(.trailing),
            NSLayoutConstraint(item: self.centerView, attribute: .bottom, relatedBy: .equal, toItem: self.textLabel, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class EmptyTextButtonView: EmptyView {
    public let centerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    public let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(light: 150/255, dark: 200/255)
        label.clipsToBounds = true
        return label
    }()
    
    public let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        return button
    }()
    
    public var textPadding: CGFloat = 20 {
        didSet {
            self.centerView.constraints(identifierType: .leading).filter({ ($0.secondItem as? UIView) == self.textLabel }).first?.constant = -self.textPadding
            self.centerView.constraints(identifierType: .trailing).filter({ ($0.secondItem as? UIView) == self.textLabel }).first?.constant = self.textPadding
        }
    }
    
    public var buttonPadding: CGFloat = 20 {
        didSet {
            self.centerView.constraints(identifierType: .leading).filter({ ($0.secondItem as? UIView) == self.button }).first?.constant = -self.buttonPadding
            self.centerView.constraints(identifierType: .trailing).filter({ ($0.secondItem as? UIView) == self.button }).first?.constant = self.buttonPadding
        }
    }
    
    public var buttonWidth: CGFloat? {
        didSet {
            if let buttonWidth = self.buttonWidth {
                if let constraint = self.button.constraints(identifierType: .width).first {
                    constraint.constant = buttonWidth
                } else {
                    self.button.addConstraints([
                        NSLayoutConstraint(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonWidth).identifier(.width)
                    ])
                }
            } else {
                self.button.removeConstraint(.width)
            }
        }
    }
    
    public var buttonHeight: CGFloat = 56 {
        didSet {
            self.button.constraints(identifierType: .height).first?.constant = self.buttonHeight
        }
    }
    
    public var buttonBottom: CGFloat = 34 {
        didSet {
            self.centerView.constraints(identifierType: .bottom).first?.constant = self.buttonBottom
        }
    }
    
    @discardableResult
    open func updateText(_ attributedText: NSAttributedString, padding: CGFloat = 20) -> EmptyTextButtonView {
        self.textLabel.attributedText = attributedText
        self.textPadding = padding
        return self
    }
    
    @discardableResult
    open func updateText(_ text: String, font: UIFont = .systemFont(ofSize: 17), textColor: UIColor = UIColor(light: 150/255, dark: 200/255), padding: CGFloat = 20) -> EmptyTextButtonView {
        self.textLabel.text = text
        self.textLabel.font = font
        self.textLabel.textColor = textColor
        self.textPadding = padding
        return self
    }
    
    @discardableResult
    open func updateButton(_ title: String, font: UIFont = .systemFont(ofSize: 17), textColor: UIColor = UIColor.systemBlue, backgroundColor: UIColor = .clear) -> EmptyTextButtonView {
        self.button.setTitle(title, for: .normal)
        self.button.titleLabel?.font = font
        self.button.setTitleColor(textColor, for: .normal)
        self.button.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    open func updateButton(_ attributedText: NSAttributedString) -> EmptyTextButtonView {
        self.button.setAttributedTitle(attributedText, for: .normal)
        return self
    }
    
    @discardableResult
    open func updateButtonSize(width: CGFloat? = nil, height: CGFloat = 56, padding: CGFloat = 20, bottom: CGFloat = 34) -> EmptyTextButtonView {
        self.buttonWidth = width
        self.buttonHeight = height
        self.buttonPadding = padding
        self.buttonBottom = bottom
        return self
    }

    public override init() {
        super.init()
        
        self.addSubview(self.centerView)
        self.centerView.addSubview(self.textLabel)
        self.centerView.addSubview(self.button)
        
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.centerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.centerView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.centerView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.centerView, attribute: .top, relatedBy: .equal, toItem: self.textLabel, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.centerView, attribute: .leading, relatedBy: .equal, toItem: self.textLabel, attribute: .leading, multiplier: 1, constant: -self.textPadding).priority(950).identifier(.leading),
            NSLayoutConstraint(item: self.centerView, attribute: .trailing, relatedBy: .equal, toItem: self.textLabel, attribute: .trailing, multiplier: 1, constant: self.textPadding).priority(951).identifier(.trailing)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.textLabel, attribute: .bottom, relatedBy: .equal, toItem: self.button, attribute: .top, multiplier: 1, constant: -20)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.centerView, attribute: .centerX, relatedBy: .equal, toItem: self.button, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.centerView, attribute: .leading, relatedBy: .equal, toItem: self.button, attribute: .leading, multiplier: 1, constant: -self.buttonPadding).priority(950).identifier(.leading),
            NSLayoutConstraint(item: self.centerView, attribute: .trailing, relatedBy: .equal, toItem: self.button, attribute: .trailing, multiplier: 1, constant: self.buttonPadding).priority(951).identifier(.trailing),
            NSLayoutConstraint(item: self.centerView, attribute: .bottom, relatedBy: .equal, toItem: self.button, attribute: .bottom, multiplier: 1, constant: self.buttonBottom).identifier(.bottom),
        ])
        
        self.button.addConstraints([
            NSLayoutConstraint(item: self.button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.buttonHeight)
        ])
        if let buttonWidth = self.buttonWidth {
            self.button.addConstraints([
                NSLayoutConstraint(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonWidth).identifier(.width)
            ])
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class EmptyImageTextButtonView: EmptyView {
    public let centerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    public let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(light: 150/255, dark: 200/255)
        label.clipsToBounds = true
        return label
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(light: 150/255, dark: 200/255)
        return imageView
    }()
    
    public let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        return button
    }()
    
    public var textPadding: CGFloat = 20 {
        didSet {
            self.centerView.constraints(identifierType: .leading).filter({ ($0.secondItem as? UIView) == self.textLabel }).first?.constant = -self.textPadding
            self.centerView.constraints(identifierType: .trailing).filter({ ($0.secondItem as? UIView) == self.textLabel }).first?.constant = self.textPadding
        }
    }
    
    public var imageSize: CGFloat = 120 {
        didSet {
            self.imageView.constraints(identifierType: .width).first?.constant = self.imageSize
            self.imageView.constraints(identifierType: .height).first?.constant = self.imageSize
        }
    }
    
    public var buttonPadding: CGFloat = 20 {
        didSet {
            self.centerView.constraints(identifierType: .leading).filter({ ($0.secondItem as? UIView) == self.button }).first?.constant = -self.buttonPadding
            self.centerView.constraints(identifierType: .trailing).filter({ ($0.secondItem as? UIView) == self.button }).first?.constant = self.buttonPadding
        }
    }
    
    public var buttonWidth: CGFloat? {
        didSet {
            if let buttonWidth = self.buttonWidth {
                if let constraint = self.button.constraints(identifierType: .width).first {
                    constraint.constant = buttonWidth
                } else {
                    self.button.addConstraints([
                        NSLayoutConstraint(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonWidth).identifier(.width)
                    ])
                }
            } else {
                self.button.removeConstraint(.width)
            }
        }
    }
    
    public var buttonHeight: CGFloat = 56 {
        didSet {
            self.button.constraints(identifierType: .height).first?.constant = self.buttonHeight
        }
    }
    
    public var buttonBottom: CGFloat = 34 {
        didSet {
            self.centerView.constraints(identifierType: .bottom).first?.constant = self.buttonBottom
        }
    }
    
    @discardableResult
    open func updateText(_ attributedText: NSAttributedString, padding: CGFloat = 20) -> EmptyImageTextButtonView {
        self.textLabel.attributedText = attributedText
        self.textPadding = padding
        return self
    }
    
    @discardableResult
    open func updateText(_ text: String, font: UIFont = .systemFont(ofSize: 17), textColor: UIColor = UIColor(light: 150/255, dark: 200/255), padding: CGFloat = 20) -> EmptyImageTextButtonView {
        self.textLabel.text = text
        self.textLabel.font = font
        self.textLabel.textColor = textColor
        self.textPadding = padding
        return self
    }
    
    @discardableResult
    open func updateImage(_ image: UIImage?, tintColor: UIColor = UIColor(light: 150/255, dark: 200/255), imageSize: CGFloat = 120) -> EmptyImageTextButtonView {
        self.imageView.image = image
        self.imageView.tintColor = tintColor
        self.imageSize = imageSize
        return self
    }

    @discardableResult
    open func updateButton(_ title: String, font: UIFont = .systemFont(ofSize: 17), textColor: UIColor = UIColor.systemBlue, backgroundColor: UIColor = .clear) -> EmptyImageTextButtonView {
        self.button.setTitle(title, for: .normal)
        self.button.titleLabel?.font = font
        self.button.setTitleColor(textColor, for: .normal)
        self.button.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    open func updateButton(_ attributedText: NSAttributedString) -> EmptyImageTextButtonView {
        self.button.setAttributedTitle(attributedText, for: .normal)
        return self
    }

    @discardableResult
    open func updateButtonSize(width: CGFloat? = nil, height: CGFloat = 56, padding: CGFloat = 20, bottom: CGFloat = 34) -> EmptyImageTextButtonView {
        self.buttonWidth = width
        self.buttonHeight = height
        self.buttonPadding = padding
        self.buttonBottom = bottom
        return self
    }

    public override init() {
        super.init()

        self.addSubview(self.centerView)
        self.centerView.addSubview(self.imageView)
        self.centerView.addSubview(self.textLabel)
        self.centerView.addSubview(self.button)

        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.centerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.centerView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.centerView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.centerView, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.centerView, attribute: .centerX, relatedBy: .equal, toItem: self.imageView, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        
        self.imageView.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.imageSize).identifier(.width),
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.imageSize).identifier(.height)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.textLabel, attribute: .top, multiplier: 1, constant: -20)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.centerView, attribute: .leading, relatedBy: .equal, toItem: self.textLabel, attribute: .leading, multiplier: 1, constant: -self.textPadding).priority(950).identifier(.leading),
            NSLayoutConstraint(item: self.centerView, attribute: .trailing, relatedBy: .equal, toItem: self.textLabel, attribute: .trailing, multiplier: 1, constant: self.textPadding).priority(951).identifier(.trailing)
        ])
        
        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.textLabel, attribute: .bottom, relatedBy: .equal, toItem: self.button, attribute: .top, multiplier: 1, constant: -20)
        ])

        self.centerView.addConstraints([
            NSLayoutConstraint(item: self.centerView, attribute: .centerX, relatedBy: .equal, toItem: self.button, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.centerView, attribute: .leading, relatedBy: .equal, toItem: self.button, attribute: .leading, multiplier: 1, constant: -self.buttonPadding).priority(950).identifier(.leading),
            NSLayoutConstraint(item: self.centerView, attribute: .trailing, relatedBy: .equal, toItem: self.button, attribute: .trailing, multiplier: 1, constant: self.buttonPadding).priority(951).identifier(.trailing),
            NSLayoutConstraint(item: self.centerView, attribute: .bottom, relatedBy: .equal, toItem: self.button, attribute: .bottom, multiplier: 1, constant: self.buttonBottom).identifier(.bottom),
        ])
        
        self.button.addConstraints([
            NSLayoutConstraint(item: self.button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.buttonHeight)
        ])
        if let buttonWidth = self.buttonWidth {
            self.button.addConstraints([
                NSLayoutConstraint(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonWidth).identifier(.width)
            ])
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
