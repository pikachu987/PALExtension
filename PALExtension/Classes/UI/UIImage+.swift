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

public extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: .zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: newSize.width/2, y: newSize.height/2)
        context?.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func resize(_ size: CGSize, scale: CGFloat = 1, hasAlpha: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func rePercentage(_ percentage: CGFloat) -> UIImage {
        guard let data = self.jpegData(compressionQuality: percentage) else { return UIImage() }
        return UIImage(data: data) ?? UIImage()
    }
    
    func resized(size: CGFloat = 1000, percent: CGFloat = 0.15, handler: @escaping ((UIImage) -> Void)) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        if self.size.width > self.size.height {
            width = size
            height = width*self.size.height/self.size.width
        } else {
            height = size
            width = height*self.size.width/self.size.height
        }
        DispatchQueue.global().async {
            if let image = self.resize(CGSize(width: width, height: height))?.rePercentage(percent) {
                DispatchQueue.main.async { handler(image) }
            }
        }
    }
    
    func rendering(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.setBlendMode(CGBlendMode.normal)
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            if let cgImage = self.cgImage {
                context.draw(cgImage, in: rect)
                context.clip(to: rect, mask: cgImage)
            }
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorizedImage?.withRenderingMode(.alwaysOriginal)
    }
}
