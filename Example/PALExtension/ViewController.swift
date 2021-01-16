//
//  ViewController.swift
//  PALExtension
//
//  Created by pikachu987 on 01/15/2021.
//  Copyright (c) 2021 pikachu987. All rights reserved.
//

import UIKit
import PALExtension

class ViewController: UIViewController {
    private let viewIndicatorButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 100, width: 200, height: 40))
        button.setTitle("view indicator", for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    private let viewIndicatorDimButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 150, width: 200, height: 40))
        button.setTitle("view indicator dim", for: .normal)
        button.backgroundColor = .gray
        return button
    }()

    private let viewProgressIndicatorButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 200, width: 200, height: 40))
        button.setTitle("view progress indicator", for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    private let viewProgressIndicatorDimButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 250, width: 200, height: 40))
        button.setTitle("view progress indicator dim", for: .normal)
        button.backgroundColor = .gray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(self.viewIndicatorButton)
        self.view.addSubview(self.viewIndicatorDimButton)
        self.view.addSubview(self.viewProgressIndicatorButton)
        self.view.addSubview(self.viewProgressIndicatorDimButton)
        
        self.viewIndicatorButton.addTarget(self, action: #selector(self.viewIndicatorTap(_:)), for: .touchUpInside)
        self.viewIndicatorDimButton.addTarget(self, action: #selector(self.viewIndicatorDimTap(_:)), for: .touchUpInside)
        self.viewProgressIndicatorButton.addTarget(self, action: #selector(self.viewProgressIndicatorTap(_:)), for: .touchUpInside)
        self.viewProgressIndicatorDimButton.addTarget(self, action: #selector(self.viewProgressIndicatorDimTap(_:)), for: .touchUpInside)
        
        self.test()
    }
    
    @objc private func viewIndicatorTap(_ sender: UIButton) {
        let view = self.view.indicatorAdd(.blue)
        
        view.progress(0, textColor: .red)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            view.progress(50.3, textColor: .red)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                view.progress(80.5, textColor: .red)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.view.indicatorsRemove()
                }
            }
        }
    }
    
    @objc private func viewIndicatorDimTap(_ sender: UIButton) {
        let view = UIView.indicatorAdd(.red, dimColor: UIColor(white: 0, alpha: 0.7))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.indicatorsProgress(30.12, textColor: .red)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.remove()
        }
    }

    @objc private func viewProgressIndicatorTap(_ sender: UIButton) {
        let view = self.view.progressIndicatorAdd()
        view.trackLineWidth = 2
        view.trackColor = UIColor(white: 248/255, alpha: 1)
        view.progressLineWidth = 2
        view.progressColor = .black
        view.layer.cornerRadius = 32
        view.backgroundColor = .clear
        
        view.progress = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            view.progress = 50.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                view.progress = 85.234
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    view.remove()
                }
            }
        }
    }

    @objc private func viewProgressIndicatorDimTap(_ sender: UIButton) {
        let view = UIView.progressIndicatorAdd(56, dimColor: UIColor(white: 0, alpha: 0.8))
        view.trackLineWidth = 4
        view.progressLineWidth = 4
        view.trackColor = .blue
        view.progressColor = .green
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            view.progress(30.12, decimalPlaces: 2, textColor: .red)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.remove()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func start(_ filename: String, _ fnName: String) {
        print("--------------------------------------------------")
        print("[\(filename)] - \(fnName)")
        print("")
    }
    
    private func end() {
        print("--------------------------------------------------")
        print("")
    }

    private func test() {
        self.start("Array+", "jsonStringify")
        print([1, 2, 3, 4].jsonStringify())
        print("")
        var array = [[String: String]]()
        array.append(["a": "test", "b": "test2"])
        array.append(["a": "test", "b": "test2"])
        array.append(["a": "test", "b": "test2"])
        print(array.jsonStringify(true))
        self.end()
        
        self.start("CGFloat+", "CGFloat.minimum")
        print("\(CGFloat.minimum)")
        self.end()
        
        self.start("CGFloat+", "CGFloat(180).degreesToRadians")
        print(CGFloat(180).degreesToRadians)
        self.end()
        
        self.start("CGFloat+", "CGFloat(180).radiansToDegrees")
        print(CGFloat(180).radiansToDegrees)
        self.end()
        
        self.start("CGFloat+", "CGFloat(-50).abs")
        print(CGFloat(-50).abs)
        self.end()
        
        self.start("CGFloat+", "CGFloat(32134443231).priceComma")
        print(CGFloat(32134443231).priceComma)
        self.end()
        
        self.start("CGFloat+", "CGFloat(3213444323331).storage")
        print(CGFloat(3213444323331).storage)
        self.end()
        
        self.start("CGFloat+", "CGFloat(3213444323331).storage(decimal: 2)")
        print(CGFloat(3213444323331).storage(decimal: 4))
        self.end()
        
        self.start("Date+", "Date(milliseconds: 1478307201053)")
        print("\(Date(milliseconds: 1478307201053))")
        self.end()
        
        self.start("Date+", "Date(milliseconds: 0)")
        print("\(Date(milliseconds: 0))")
        self.end()
        
        self.start("Date+", "Date().dateTuple")
        print("\(Date().dateTuple)")
        self.end()
        
        self.start("Date+", "Date().dateTupleInt")
        print("\(Date().dateTupleInt)")
        self.end()
        
        self.start("Date+", "Date().timeZoneDate")
        print("\(Date().timeZoneDate)")
        self.end()
        
        self.start("Date+", "Date().timeZoneRevertDate")
        print("\(Date().timeZoneRevertDate)")
        self.end()
        
        self.start("Date+", "Date().getDate()")
        print("\(Date().getDate())")
        self.end()
        
        self.start("Date+", "Date().getTime()")
        print("\(Date().getTime())")
        self.end()
        
        self.start("Date+", "Date().betweenDays(Date(timeIntervalSince1970: 1478307201053))")
        print("\(Date().betweenDays(Date(timeIntervalSince1970: 1478307201053)))")
        self.end()
        
        self.start("Date+", "Date().equalYear(Date(timeIntervalSince1970: 1478307201053))")
        print("\(Date().equalYear(Date(timeIntervalSince1970: 1478307201053)))")
        self.end()
        
        self.start("Date+", "Date().equalMonth(Date(timeIntervalSince1970: 1478307201053))")
        print("\(Date().equalMonth(Date(timeIntervalSince1970: 1478307201053)))")
        self.end()
        
        self.start("Date+", "Date().equalDay(Date(timeIntervalSince1970: 1478307201053))")
        print("\(Date().equalDay(Date(timeIntervalSince1970: 1478307201053)))")
        self.end()
        
        self.start("Date+", "Date.format(\"2020-02-01 09:30:21\", format: \"yyyy-MM-dd HH:mm:SS\")")
        if let date = Date.format("2020-02-01 09:30:21", format: "yyyy-MM-dd HH:mm:SS") {
            print("\(date)")
        } else {
            print("nil")
        }
        self.end()
        
        self.start("Dictionary+", "jsonStringify")
        print(["a": "test", "b": "test2"].jsonStringify())
        print(["a": "test", "b": "test2"].jsonStringify(true))
        self.end()
        
        self.start("Double+", "Double(90).degreesToRadians")
        print(Double(90).degreesToRadians)
        self.end()
        
        self.start("Double+", "Double(90).radiansToDegrees")
        print(Double(90).radiansToDegrees)
        self.end()
        
        self.start("Double+", "Double(-90).abs")
        print(Double(-90).abs)
        self.end()
        
        self.start("Double+", "Double(2333333000000).priceComma")
        print(Double(2333333000000).priceComma)
        self.end()
        
        self.start("Double+", "Double(2333333000000).storage")
        print(Double(2333333000000).storage)
        self.end()
        
        self.start("Double+", "Double(2333333000000).storage(decimal: 7)")
        print(Double(2333333000000).storage(decimal: 7))
        self.end()
        
        self.start("Float+", "Float(90).degreesToRadians")
        print(Float(90).degreesToRadians)
        self.end()
        
        self.start("Float+", "Float(90).radiansToDegrees")
        print(Float(90).radiansToDegrees)
        self.end()
        
        self.start("Float+", "Float(-90).abs")
        print(Float(-90).abs)
        self.end()
        
        self.start("Float+", "Float(2333333000000).priceComma")
        print(Float(2333333000000).priceComma)
        self.end()
        
        self.start("Float+", "Float(2333333000000).storage")
        print(Float(2333333000000).storage)
        self.end()
        
        self.start("Float+", "Float(2333333000000).storage(decimal: 7)")
        print(Float(2333333000000).storage(decimal: 7))
        self.end()
        
        self.start("Int+", "Int(90).degreesToRadians")
        print(Int(90).degreesToRadians)
        self.end()
        
        self.start("Int+", "Int(90).radiansToDegrees")
        print(Int(90).radiansToDegrees)
        self.end()
        
        self.start("Int+", "Int(-90).abs")
        print(Int(-90).abs)
        self.end()
        
        self.start("Int+", "Int(2333333000000).priceComma")
        print(Int(2333333000000).priceComma)
        self.end()
        
        self.start("Int+", "Int(2333333000000).storage")
        print(Int(2333333000000).storage)
        self.end()
        
        self.start("Int+", "Int(2333333000000).storage(decimal: 7)")
        print(Int(2333333000000).storage(decimal: 7))
        self.end()
        
        self.start("NSObject+", "self.classNameToString")
        print(self.classNameToString)
        self.end()
        
        self.start("NSObject+", "UINavigationController.classNameToString")
        print(UINavigationController.classNameToString)
        self.end()
        
        self.start("String+", "\"가나다라test\".euckrEncoding")
        print("가나다라test".euckrEncoding)
        self.end()
        
        self.start("String+", "\"test\".localized")
        print("test".localized)
        self.end()
        
        self.start("String+", "\"test\".range")
        print("test".range)
        self.end()
        
        self.start("String+", "\"[1,2,3,4]\".parseJSON")
        print("[1,2,3,4]".parseJSON)
        self.end()
        
        self.start("String+", "\"{\"a\":\"test\",\"b\":\"test2\"}\".parseJSON")
        print("{\"a\":\"test\",\"b\":\"test2\"}".parseJSON)
        self.end()
        
        self.start("String+", "\"test\".base64Decoding")
        print("test".base64Decoding)
        self.end()
        
        self.start("String+", "\"pikachu77769@gmail.com\".isValidEmail")
        print("pikachu77769@gmail.com".isValidEmail)
        self.end()
        
        self.start("String+", "\"http://www.naver.com\".isValidUrl")
        print("http://www.naver.com".isValidUrl)
        self.end()
        
        self.start("String+", "\"가나다\".isValidKo")
        print("가나다".isValidKo)
        self.end()
        
        self.start("String+", "\"가나다test\".isValidKo")
        print("가나다test".isValidKo)
        self.end()
        
        self.start("String+", "\"test\".localizedWithComment(\"comment\")")
        print("test".localizedWithComment("comment"))
        self.end()
        
        self.start("String+", "\"test example\".substring(from: 2)")
        print("test example".substring(from: 2))
        self.end()
        
        self.start("String+", "\"test example\".substring(from: 2, to: 4)")
        print("test example".substring(from: 2, to: 4))
        self.end()
        
        self.start("String+", "\"test example\".substring(from: 2, length: 4)")
        print("test example".substring(from: 2, length: 4))
        self.end()
        
        self.start("String+", "\"test example\".nsRange(\"amp\")")
        if let range = "test example".nsRange("amp") {
            print(range)
        } else {
            print("nil")
        }
        self.end()
        
        self.start("String+", "\"12.3123123123333\".decimalFormat")
        print("12.3123123123333".decimalFormat())
        self.end()
        
        self.start("String+", "\"12.3123123123333\".decimalFormat(2)")
        print("12.3123123123333".decimalFormat(2))
        self.end()
        
        self.start("String+", "\"2020-01-01 18:30:25\".toDateString(inputFormat: \"yyyy-MM-dd HH:mm:ss\", outputFormat: \"yyyy.MM.dd HH/mm/ss\"")
        print("2020-01-01 18:30:25".toDateString(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "yyyy.MM.dd HH/mm/ss"))
        self.end()
        
        self.start("String+", "\"39213.213.4355.349494\".matches(\"[0-9]+\")")
        print("39213.213.4355.349494".matches("[0-9]+"))
        self.end()
        
        self.start("String+", "\"http://www.naver.com ~~!@!@#!#@!#@!#!@dsafifdsaoifd http://www.google.com adifsafajisdf\".urlLink")
        "http://www.naver.com ~~!@!@#!#@!#@!#!@dsafifdsaoifd http://www.google.com adifsafajisdf http://www.naver.com".urlLink { (url) in
            print(url)
        }
        self.end()
        
        self.start("String+", "\"01012341234\".format([3, 4, 4], separator: \"-\")")
        print("01012341234".format([3, 4, 4], separator: "-"))
        self.end()
        
        self.start("String+", "\"3215498765\".format([3, 2, 5], separator: \"-\")")
        print("3215498765".format([3, 2, 5], separator: "-"))
        self.end()
        
        self.start("String+", "\"20200621\".format([4, 2, 2], separator: \".\")")
        print("20200621".format([4, 2, 2], separator: "."))
        self.end()
        
        self.start("UIApplication+", "UIApplication.shared.currentViewController")
        if let viewContoller = UIApplication.shared.currentViewController {
            print(viewContoller)
        } else {
            print("nil")
        }
        self.end()
        
        self.start("UIColor+", "UIColor(light: .black, dark: .white))")
        print(UIColor(light: .black, dark: .white))
        self.end()
        
        self.start("UIColor+", "UIColor(hex: 0xffffff)")
        print(UIColor(hex: 0xffffff))
        self.end()
        
        self.start("UIColor+", "UIColor(hexString: \"ffffff\")")
        print(UIColor(hexString: "ffffff"))
        self.end()
        
        self.start("UIColor+", "UIColor.blue.red")
        print(UIColor.blue.red)
        self.end()
        
        self.start("UIColor+", "UIColor.blue.green")
        print(UIColor.blue.green)
        self.end()
        
        self.start("UIColor+", "UIColor.blue.blue")
        print(UIColor.blue.blue)
        self.end()
        
        self.start("UIColor+", "UIColor.blue.alpha")
        print(UIColor.blue.alpha)
        self.end()
        
        self.start("UIColor+", "UIColor.blue.toHexString")
        print(UIColor.blue.toHexString)
        self.end()
        
        self.start("UIColor+", "UIColor.blue.equal(color: .blue)")
        print(UIColor.blue.equal(color: .blue))
        self.end()
        
        self.start("UIDevice+", "UIDevice.deviceModelType")
        print(UIDevice.deviceModelType)
        self.end()
        
        self.start("UIDevice+", "UIDevice.deviceType")
        print(UIDevice.deviceType)
        self.end()
        
        self.start("UIDevice+", "UIDevice.deviceSimulatorModelType")
        print(UIDevice.deviceSimulatorModelType)
        self.end()
        
        self.start("UIDevice+", "UIDevice.deviceSimulatorType")
        print(UIDevice.deviceSimulatorType)
        self.end()
        
        self.start("UIDevice+", "UIDevice.machineString")
        print(UIDevice.machineString)
        self.end()
        
        self.start("UIFont+", "UIFont.fontNames")
        print(UIFont.fontNames)
        self.end()
        
        self.start("UIFont+", "UIFont.semiBoldSystemFont(ofSize: 17)")
        print(UIFont.semiBoldSystemFont(ofSize: 17))
        self.end()
        
        self.start("UIView+", "self.view.safe")
        print(self.view.safe)
        self.end()
        
        self.start("UIViewController+", "self.safe")
        print(self.safe)
        self.end()
    }
}

