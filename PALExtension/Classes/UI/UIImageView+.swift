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

public extension UIImageView {
    var imageFrame: CGRect {
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else { return CGRect.zero }
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        } else {
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
    
    enum DrawType {
        case draw, clear
    }
    
    func draw(_ type: DrawType, from: CGPoint, to: CGPoint, size: CGFloat, color: UIColor = .clear) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.image?.draw(in: self.bounds)
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: from)
        context?.addLine(to: to)
        context?.setLineCap(CGLineCap.round)
        if type == .draw {
            context?.setLineWidth(size)
            context?.setStrokeColor(red: color.red, green: color.green, blue: color.blue, alpha: 1.0)
            context?.setBlendMode(.normal)
        } else if type == .clear {
            context?.setLineWidth(size)
            context?.setStrokeColor(red: UIColor.clear.red, green: UIColor.clear.green, blue: UIColor.clear.blue, alpha: 1.0)
            context?.setBlendMode(.clear)
        }
        context?.strokePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
