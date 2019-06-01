//
//  CommonExtentions.swift
//  PsychScribe
//
//  Created by Ashish Kakkad on 7/28/16.
//  Copyright © 2016 MoveoApps. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView

class CommonExtentions: NSObject {

}

extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }
}

extension URL {    
    var allQueryItems: [URLQueryItem] {
        get {
            let components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
            let allQueryItems = components.queryItems!
            return allQueryItems as [URLQueryItem]
        }
    }
    func queryItemForKey(_ key: String) -> URLQueryItem? {
        let predicate = NSPredicate(format: "name=%@", key)
        return (allQueryItems as NSArray).filtered(using: predicate).first as? URLQueryItem
    }
}

extension UIViewController
{
    var appDelegate:AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension UIView {
    func showIndicator() {
        
        let nvActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.white)
        self.frame = CGRect(x: 0, y: 0, width: Constants.kScreenWidth, height: Constants.kScreenHeight)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.38)
        nvActivityIndicator.center = self.center
        self.addSubview(nvActivityIndicator)
        let window = UIApplication.shared.keyWindow!.rootViewController
        window!.view.addSubview(self)
        nvActivityIndicator.startAnimating()
        
    }
    
    func hideIndicator() {
        self.removeFromSuperview()
    }
    
    func addDashedBorder(_ color : UIColor) {
        let color = color.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.sublayers?.removeAll()
        self.layer.addSublayer(shapeLayer)
        
    }
}

extension String {
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension CALayer
{
    func setBorderUIColor(_ color: UIColor)
    {
        self.borderColor = color.cgColor
    }
    
    func BorderUIColor() -> UIColor
    {
        return UIColor(cgColor: self.borderColor!)
    }
    
    func setShadowUIColor(_ color: UIColor)
    {
        self.shadowColor = color.cgColor
    }
    
    func ShadowUIColor() -> UIColor
    {
        return UIColor(cgColor: self.shadowColor!)
    }
}

//
//  NSDate+Extension.swift
//  Tasty
//
//  Created by Vitaliy Kuzmenko on 17/10/14.
//  http://github.com/vitkuzmenko
//  Copyright (c) 2014 Vitaliy Kuz'menko. All rights reserved.
//

extension Date {
    // shows 1 or two letter abbreviation for units.
    // does not include 'ago' text ... just {value}{unit-abbreviation}
    // does not include interim summary options such as 'Just now'
    public var timeAgoSimple: String {
        let components = self.dateComponents()
        
        if components.year! > 0 {
            return stringFromFormat("%%d%@yr", withValue: components.year!)
        }
        
        if components.month! > 0 {
            return stringFromFormat("%%d%@mo", withValue: components.month!)
        }
        
        // TODO: localize for other calanders
        if components.day! >= 7 {
            let value = components.day!/7
            return stringFromFormat("%%d%@w", withValue: value)
        }
        
        if components.day! > 0 {
            return stringFromFormat("%%d%@d", withValue: components.day!)
        }
        
        if components.hour! > 0 {
            return stringFromFormat("%%d%@h", withValue: components.hour!)
        }
        
        if components.minute! > 0 {
            return stringFromFormat("%%d%@m", withValue: components.minute!)
        }
        
        if components.second! > 0 {
            return stringFromFormat("%%d%@s", withValue: components.second! )
        }
        
        return ""
    }
    
    public var timeAgo: String {
        let components = self.dateComponents()
        
        if components.year! > 0 {
            if components.year! < 2 {
                return "Last year"
            } else {
                return stringFromFormat("%%d %@years ago", withValue: components.year!)
            }
        }
        
        if components.month! > 0 {
            if components.month! < 2 {
                return "Last month"
            } else {
                return stringFromFormat("%%d %@months ago", withValue: components.month!)
            }
        }
        
        // TODO: localize for other calanders
        if components.day! >= 7 {
            let week = components.day!/7
            if week < 2 {
                return "Last week"
            } else {
                return stringFromFormat("%%d %@weeks ago", withValue: week)
            }
        }
        
        if components.day! > 0 {
            if components.day! < 2 {
                return "Yesterday"
            } else  {
                return stringFromFormat("%%d %@days ago", withValue: components.day!)
            }
        }
        
        if components.hour! > 0 {
            if components.hour! < 2 {
                return "An hour ago"
            } else  {
                return stringFromFormat("%%d %@hours ago", withValue: components.hour!)
            }
        }
        
        if components.minute! > 0 {
            if components.minute! < 2 {
                return "A minute ago"
            } else {
                return stringFromFormat("%%d %@minutes ago", withValue: components.minute!)
            }
        }
        
        if components.second! > 0 {
            if components.second! < 5 {
                return "Just now"
            } else {
                return stringFromFormat("%%d %@seconds ago", withValue: components.second!)
            }
        }
        
        return "Just now"
    }
    
    fileprivate func dateComponents() -> DateComponents {
        let calander = Calendar.current
        return (calander as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: self, to: Date(), options: [])
    }
    
    fileprivate func stringFromFormat(_ format: String, withValue value: Int) -> String {
        let localeFormat = String(format: format, getLocaleFormatUnderscoresWithValue(Double(value)))
        return String(format: localeFormat, value)
    }
    
    fileprivate func getLocaleFormatUnderscoresWithValue(_ value: Double) -> String {
        guard let localeCode = Locale.preferredLanguages.first else {
            return ""
        }
        
        // Russian (ru) and Ukrainian (uk)
        if localeCode.hasPrefix("ru") || localeCode.hasPrefix("uk") {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
    
}

extension UITextField{
    
    func phoneFormater(range: NSRange,string: String) -> String{
        
        print(self.text as Any, "\n" ,range.location ,":",range.length ,"\n",string)
        
        let newString = (self.text! as NSString).replacingCharacters(in: range, with: string)
        
        let components = newString.components(separatedBy:CharacterSet.decimalDigits.inverted)
        
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        //if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
        //{
        //let newLength = (self.text! as NSString).length + (string as NSString).length - range.length as Int
        //return (newLength > 10) ? false : true
        //}
        var index = 0 as Int
        let formattedString = NSMutableString()
        if hasLeadingOne
        {
            formattedString.append("1 ")
            index += 1
        }
        if (length - index) > 3
        {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 3
        }
        if length - index > 3
        {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        
        return formattedString as String
    }
}
