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

// RGB
public struct RGB {
    public let r: CGFloat
    public let g: CGFloat
    public let b: CGFloat
    
    public var hsv: HSV {
        return RGB.hsv(self)
    }
    
    public static func hsv(r: CGFloat, g: CGFloat, b: CGFloat) -> HSV {
        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
        
        let v = max
        let delta = max - min
        
        guard delta > 0.00001 else { return HSV(h: 0, s: 0, v: max) }
        guard max > 0 else { return HSV(h: -1, s: 0, v: v) }
        let s = delta / max
        
        let hue: (CGFloat, CGFloat) -> CGFloat = { max, delta -> CGFloat in
            if r == max { return (g-b)/delta } // between yellow & magenta
            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
            else { return 4 + (r-g)/delta } // between magenta & cyan
        }
        let h = hue(max, delta) * 60 // degrees
        return HSV(h: (h < 0 ? h+360 : h) , s: s, v: v)
    }

    public static func hsv(_ rgb: RGB) -> HSV {
        return hsv(r: rgb.r, g: rgb.g, b: rgb.b)
    }
}

// RGBA
public struct RGBA {
    let a: CGFloat
    let rgb: RGB

    public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.a = a
        self.rgb = RGB(r: r, g: g, b: b)
    }
}

public struct HSV {
    public let h: CGFloat
    public let s: CGFloat
    public let v: CGFloat

    public var rgb: RGB {
        return HSV.rgb(self)
    }
    
    public var point: CGPoint {
        return CGPoint(x: CGFloat(h/360), y: CGFloat(v))
    }
    
    public static func rgb(_ h: CGFloat, s: CGFloat, v: CGFloat) -> RGB {
        if s == 0 { return RGB(r: v, g: v, b: v) }
        
        let angle = (h >= 360 ? 0 : h)
        let sector = angle / 60
        let i = floor(sector)
        let f = sector - i
        
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))
        
        switch(i) {
        case 0:
            return RGB(r: v, g: t, b: p)
        case 1:
            return RGB(r: q, g: v, b: p)
        case 2:
            return RGB(r: p, g: v, b: t)
        case 3:
            return RGB(r: p, g: q, b: v)
        case 4:
            return RGB(r: t, g: p, b: v)
        default:
            return RGB(r: v, g: p, b: q)
        }
    }
    
    public static func rgb(_ hsv: HSV) -> RGB {
        return rgb(hsv.h, s: hsv.s, v: hsv.v)
    }
}

public extension UIColor {
    
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            self.init(dynamicProvider: { (collection) -> UIColor in
                return collection.userInterfaceStyle == .light ? light : dark
            })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }

    private convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    convenience init(hexString: String) {
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    var red: CGFloat { return CIColor(color: self).red }
    var green: CGFloat { return CIColor(color: self).green }
    var blue: CGFloat { return CIColor(color: self).blue }
    var alpha: CGFloat { return CIColor(color: self).alpha }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }

    func equal(color: UIColor) -> Bool {
        var lhs: UIColor = self
        var rhs: UIColor = color
        if #available(iOS 13.0, *) {
            lhs = self.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            rhs = color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        }
        var leftRed: CGFloat = 0
        var leftGreen: CGFloat = 0
        var leftBlue: CGFloat = 0
        var leftAlpha: CGFloat = 0

        var rightRed: CGFloat = 0
        var rightGreen: CGFloat = 0
        var rightBlue: CGFloat = 0
        var rightAlpha: CGFloat = 0

        lhs.getRed(&leftRed, green: &leftGreen, blue: &leftBlue, alpha: &leftAlpha)
        rhs.getRed(&rightRed, green: &rightGreen, blue: &rightBlue, alpha: &rightAlpha)

        if leftRed == rightRed && leftGreen == rightGreen && leftBlue == rightBlue && leftAlpha == rightAlpha {
            return true
        } else {
            return false
        }
    }

    func image(_ size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.setFill()
        UIRectFill(rect)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil  }
        UIGraphicsEndImageContext()
        return image
    }
}
