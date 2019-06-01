//
//  CommonExtensions.swift
//  ShopSnapIt
//
//  Created by Moveo Apps on 12/06/17.
//  Copyright © 2017 Moveo Apps. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import SwiftyJSON
import InteractiveSideMenu
import KMPlaceholderTextView
import Photos
import SwiftyStoreKit
import MBProgressHUD

typealias AlertCompletion = (Int) -> ()
typealias ActionSheetCompletion = (Int, Bool) -> ()

//MARK: - Device Activity

extension UIDevice {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}

// MARK: - Button Methods

extension UIButton{
    
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
}

//MARK: - Textfield Methods
extension UITextField{
    
    func phoneFormater(range: NSRange,string: String){
        
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
            formattedString.appendFormat("%@-", areaCode)
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
        
        self.text = formattedString as String
    }
    
    // This funciton is user when set value in textfield at that time show it's sibling lable
    func setValueInAnimatedTextField(value : String){
        self.text = value
        
        //hide show lable
        if self.text?.length != 0{
            for view in (self.superview?.subviews)!{
                if view is UILabel{
                    let lbl = view as! UILabel
                    lbl.isHidden = false
                    self.placeholder = ""
                }
            }
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}

// MARK: - String Utility Methods

extension String {
    
    //To get the length of the String
    var length : Int{
        return characters.count
    }
    
    //To check String is empty or not
    var isEmpty: Bool {
        
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmed.length > IntValues.ZERO
        {
            return false
        }
        return true
    }
    
    //To check Email is valid or not
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //To check Phone is valid or not
    
    var isValidaPhone : Bool{
        do{
            let PHONE_REGEX = "^([0-9-() ]+)?(\\.([0-9]{1,2})?)?$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            return phoneTest.evaluate(with: self)
        }
    }
    
    //To check Email is valid or not
    var isValidUserName: Bool {
        if self.length >= 3{
            return true
        }
        return false
    }
    
    
    
    //To validate Password between 6 to 20 valid character
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.length>=4 && self.length<=20 ){
                    
                    let specialCharRegEx  = ".*[!&^%$#@*()/]+.*"
                    let predicateSpecChar = NSPredicate(format:"SELF MATCHES %@", specialCharRegEx)
                    let containsSpecialChar = predicateSpecChar.evaluate(with: self)
                    
                    let numberRegEx  = ".*[0-9]+.*"
                    let predicateNumber = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
                    let containsNumber = predicateNumber.evaluate(with: self)
                    
                    return true && containsSpecialChar && containsNumber
                }
            }
            return false
        } catch {
            return false
        }
    }
    
    //Validate Expiry date of card
    var isValidateCardExpiryDate: Bool{
        
        let date = self.getDateFromString(pStrFormate: "MM/yyyy")
        if date < Date(){
            return true
        }
        return false
    }
    
    /// To get index of given string
    ///
    /// - Parameters:
    ///   - string: string to get index
    ///   - options: string compare options
    /// - Returns: returns Index value of string
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    /// For getting date from string with given formate
    ///
    /// - Parameter pStrFormate: pStrFormate formate to set
    /// - Returns: returns date value
    func getDateFromString(pStrFormate : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pStrFormate
        let date = dateFormatter.date(from: self)
        return date!
    }
    
    /// For getting date from string with given formate
    ///
    /// - Parameter pStrFormate: pStrFormate formate to set
    /// - Returns: returns string date value
    func getDateStringFromString(pStrFormate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pStrFormate
        let date = dateFormatter.date(from: self)
        return dateFormatter.string(from: date!)
    }
    
    // (UTC TO LOCAL) String to string
    func convertUTCStringToLocalDateString() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        return date!
    }
    
    func convertUTCStringToLocalDateWithoutTimeString() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        return date!
    }
    
    func convertToBidTimeFormate() -> String{
        let localDate = self.convertUTCStringToLocalDateString()
        let formatedDate = timeAgoSinceForBid(localDate)
        let strTime = localDate.getStringFromDate(pStrFormate: "hh:mm a")
        return strTime + formatedDate
    }
    
    func getRelativeWidth(withConstrainedheight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    
    var convertToSimplePhoneString:String{
        return self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "")
    }
    
    var convertToFormatedPhoneString:String{
        
        var strUpdated = self.convertToSimplePhoneString
        strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 3))
        strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 7))
        return strUpdated
    }
    
    var converToCountryCode:String{
        if self.length > 0{
            let onlyCode = self.replacingOccurrences(of: "+", with: "")
            return "+" + onlyCode
        }else{
            return "+"
        }
    }
    
    var convertToTwoDecimalString:String{
        if self.length > 0{
            return String(format: "$%.2f", Float(self.removeUnwantedChracterFromString)!)
        }
        return "$0.00"
    }
    
    var convertToTwoDecimalStringWithOutDollar:String{
        if self.length > 0{
            return String(format: "%.2f", Float(self.removeUnwantedChracterFromString)!)
        }
        return "0.00"
    }
    
    var removeUnwantedChracterFromString:String{
        return String(self.characters.filter { !" \n\t\r$".characters.contains($0) })
    }
    
    //Validate Character allow only -> "1234567890$."
    var containsValidBidPriceCharacter: Bool {
        let characterSet = CharacterSet(charactersIn: "1234567890.")
        let range = (self as NSString).rangeOfCharacter(from: characterSet)
        return range.location != NSNotFound
    }
    
    //Add Arributted image with text
    var insertVerifiedImageinAttributedText:NSAttributedString{
        
        let fullString = NSMutableAttributedString(string: self)
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "user_verified_icon")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        return fullString
    }
    
    //Validate Decimal value like product price
    func allowOnlyDecimalValue(range: NSRange,string: String) -> Bool{
        
        if string == ""{
            return true
        }
        if self.length == 0 && Int(string) == 0{
            return false
        }
        let textFieldString = self as NSString
        let newString = textFieldString.replacingCharacters(in: range, with:string)
        let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
        let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
        return floatExPredicate.evaluate(with: newString)
    }
}


// MARK: - UserDefault Utility Methods

extension UserDefaults {
    
    /// Save data to user default according to given key
    ///
    /// - Parameters:
    ///   - object: object that needs to be stored
    ///   - key: key name to associate
    func saveCustomObject(_ object: Any, key: String) {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        USERDEFAULTS.set(encodedObject, forKey: key)
        USERDEFAULTS.synchronize()
    }
    
    /// Load or fetch data from user defaul according to key
    ///
    /// - Parameter key: key name to associate
    /// - Returns: object that is stored wth associated keys
    func loadCustomObject(_ key: String) -> Any? {
        if let userDefaultKey = USERDEFAULTS.object(forKey: key) {
            let encodedObject = userDefaultKey as! NSData
            return NSKeyedUnarchiver.unarchiveObject(with: encodedObject as Data)! as AnyObject?
        }
        else {
            return nil
        }
    }
}
// MARK: - UIView Utility Methods

extension UIView {
    //    To set the corner radius of the UIView
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            if shadow == false{
                self.clipsToBounds = newValue > 0
            }
        }
        get {
            return layer.cornerRadius
        }
    }
    
    /// To make circle
    @IBInspectable var isCircular: Bool {
        set {
            if newValue == true{
                let radiusValue = self.frame.size.width / 2
                layer.cornerRadius = radiusValue
            }
        }
        get {
            if self.cornerRadius == self.frame.size.width / 2{
                return true
            }
            return false
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var shadowValue: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            if shadow == true {
                layer.shadowRadius = newValue
            }
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 2.0),
                   shadowOpacity: Float = 0.4) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowValue
    }
    
    func showIndicater(){
        var activityIndicater = self.viewWithTag(INDICATERTAG) as? UIActivityIndicatorView
        if activityIndicater == nil{
            activityIndicater = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicater!.tag = INDICATERTAG
            activityIndicater!.hidesWhenStopped = true
            activityIndicater?.center = self.center
            self.addSubview(activityIndicater!)
        }
        activityIndicater?.startAnimating()
    }
    
    func hideIndicater(){
        let activityIndicater = self.viewWithTag(INDICATERTAG) as? UIActivityIndicatorView
        if activityIndicater != nil{
            activityIndicater?.stopAnimating()
        }
    }
    
    //FIND The parent view from UIVIEW
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
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
}

// MARK: - Date Utility Methods

extension Date {
    
    /// For getting date as string with given formate
    ///
    /// - Parameter button: refrence of button which needs to be changed
    func getStringFromDate(pStrFormate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pStrFormate
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    
    func getStringFromDateWithRelative() -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = pStrFormate
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    
    /// calculates age
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    func getDateFromString(strDate : String) -> Date{
        let dateString = strDate
        let df = DateFormatter()
        df.dateFormat = "MM dd, yyyy"
        let date = df.date(from: dateString)
        if let unwrappedDate = date {
            return unwrappedDate
        }
        return Date()
    }
    
}

extension UIImage {
    
    /// To get templeted image
    func getTempletedImage() -> UIImage{
        return self.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
    func fixImageOrientation() -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (self.imageOrientation == UIImageOrientation.up) {
            return self;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if (self.imageOrientation == UIImageOrientation.down
            || self.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if (self.imageOrientation == UIImageOrientation.left
            || self.imageOrientation == UIImageOrientation.leftMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }
        
        if (self.imageOrientation == UIImageOrientation.right
            || self.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2));
        }
        
        if (self.imageOrientation == UIImageOrientation.upMirrored
            || self.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (self.imageOrientation == UIImageOrientation.leftMirrored
            || self.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                      bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: self.cgImage!.colorSpace!,
                                      bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        
        if (self.imageOrientation == UIImageOrientation.left
            || self.imageOrientation == UIImageOrientation.leftMirrored
            || self.imageOrientation == UIImageOrientation.right
            || self.imageOrientation == UIImageOrientation.rightMirrored
            ) {
            
            
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.height,height:self.size.width))
            
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.width,height:self.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

//MARK: - UIScrollView

extension UIScrollView{
    
}

//MARK: - UINavigationView Controller
extension UINavigationController{
    
    func setCommonNavigationVC(){
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: FONT.Lato17!]
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back_icon")!
        self.navigationBar.shadowImage = UIImage()
    }
    
    func setImageInNavigationBar(bgImage : UIImage){
        //Set Image In Navigation Bar
        self.navigationBar.setBackgroundImage(bgImage, for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
    }
    
    func removeImageInNavigationBar(){
        //remove image from navigation bar
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.isTranslucent = true
    }
}

extension URL{
    
    //Generate Image from video URL
    func getVideoThumbnail() -> UIImage {
        let asset = AVAsset.init(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage.init(cgImage: imageRef)
        } catch {
            print(error)
            return UIImage(named: "some generic thumbnail")!
        }
    }
    
    //Generate Image from video URL
    func getCameraVideoThumbnail() -> UIImage {
        let asset = AVURLAsset(url: self, options: nil)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage.init(cgImage: imageRef)
        } catch {
            print(error)
            return UIImage(named: "some generic thumbnail")!
        }
    }
}

// MARK: - UIViewController Utility Methods

extension UIViewController {
    
    /// Save data to user default according to given key
    ///
    /// - Parameters:
    ///   - object: object that needs to be stored
    ///   - key: key name to associate
    var isUserLogedIn: Bool {
        return USERDEFAULTS.bool(forKey: UDKeys.ISUSERLODEDIN)
    }
    
    
    var deviceToken: String {
        guard let token = USERDEFAULTS.value(forKey: UDKeys.DEVICETOKEN) else { return "" }
        return token as! String
    }
    
    /// Shows login screen from any view controller
    func showLoginScreen(){
        let storyboard = UIStoryboard(name: StoryboardId.AUTHENTICATION, bundle: nil)
        let aVC = storyboard.instantiateViewController(withIdentifier: VCId.SIGNIN)
        aVC.modalTransitionStyle = .crossDissolve
        self.present(aVC, animated: true, completion: nil)
    }
    
    /// Shows login screen if user not loged in
    func manageInitialScreen(){
        //        APPDELEGATE.currentPresentedVC = self
        if self.isUserLogedIn == false{
            self.showLoginScreen()
        }
        else{
            DetailsRouter.token = USERDEFAULTS.value(forKey: UDKeys.USERTOKEN) as? String
        }
    }
    
    
    /// For showing alert in the application
    ///
    /// - Parameters:
    ///   - pStrMessage: Message for alert
    ///   - includeOkButton: Bool specifies whether to include ok button in alert
    ///   - includeCancelButton: Bool specifies whether to include cancel button in alert
    ///   - pParentVC: pParentVC specifies controller in which alert will be shown
    ///   - completionBlock: handles alert controller button click event
    func showAlertWithCompletion(pTitle : String? ,pStrMessage : String , includeOkButton : Bool ,includeCancelButton : Bool,completionBlock: AlertCompletion?){
        var alertTitle = APPLICATIONNAME
        if pTitle != nil{
            alertTitle = pTitle!
        }
        let alertController = UIAlertController(title: alertTitle, message: pStrMessage, preferredStyle: .alert)
        
        if includeOkButton == true{
            let OkBtnAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if (completionBlock != nil) {
                    completionBlock!(0)
                }
            })
            alertController.addAction(OkBtnAction)
        }
        if includeCancelButton == true{
            let CancelBtnAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                if (completionBlock != nil) {
                    completionBlock!(1)
                }
            })
            alertController.addAction(CancelBtnAction)
        }
        alertController.view.tintColor = #colorLiteral(red: 0.8726853728, green: 0.2410425842, blue: 0.2042397559, alpha: 1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithYesNoCompletion(pTitle : String? ,pStrMessage : String , includeOkButton : Bool ,includeCancelButton : Bool,completionBlock: AlertCompletion?){
        var alertTitle = APPLICATIONNAME
        if pTitle != nil{
            alertTitle = pTitle!
        }
        let alertController = UIAlertController(title: alertTitle, message: pStrMessage, preferredStyle: .alert)
        
        if includeOkButton == true{
            let OkBtnAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                if (completionBlock != nil) {
                    completionBlock!(0)
                }
            })
            alertController.addAction(OkBtnAction)
        }
        if includeCancelButton == true{
            let CancelBtnAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                if (completionBlock != nil) {
                    completionBlock!(1)
                }
            })
            alertController.addAction(CancelBtnAction)
        }
        alertController.view.tintColor = #colorLiteral(red: 0.8726853728, green: 0.2410425842, blue: 0.2042397559, alpha: 1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// For showing actionsheet in the application
    ///
    /// - Parameters:
    ///   - pStrMessage: Message for alert
    ///   - includeOkButton: Bool specifies whether to include ok button in alert
    ///   - arrButtonName: contains all button that needs to be included
    ///   - strDestructiveButton:  contains title for the destructive buton
    ///   - completionBlock: handles alert controller button click event
    func showActionSheetWithCompletion(pTitle : String? ,pStrMessage : String? , arrButtonName : [String] , destructiveButtonIndex : Int?, strCancelButton : String?,tintColor : UIColor?, shouldAnimate : Bool ,completionBlock: AlertCompletion?){
        
        let alertController = UIAlertController(title: pTitle, message: pStrMessage, preferredStyle: .actionSheet)
        
        for strButtonName in arrButtonName.enumerated(){
            var btnActionType = UIAlertActionStyle.default
            if destructiveButtonIndex != nil && destructiveButtonIndex == strButtonName.offset{
                btnActionType = UIAlertActionStyle.destructive
            }
            let btnAction = UIAlertAction(title: strButtonName.element, style: btnActionType, handler: { (action) in
                if (completionBlock != nil) {
                    completionBlock!(strButtonName.offset)
                }
            })
            alertController.addAction(btnAction)
        }
        if strCancelButton != nil{
            let CancelBtnAction = UIAlertAction(title: strCancelButton, style: .cancel, handler: { (action) in
                if (completionBlock != nil) {
                    completionBlock!(arrButtonName.count)
                }
            })
            alertController.addAction(CancelBtnAction)
        }
        if tintColor != nil{
            alertController.view.tintColor = tintColor
        }
        
        self.present(alertController, animated: shouldAnimate, completion: nil)
    }
    
    
    /// Adds bullets in label text
    ///
    /// - Parameters:
    ///   - arrString: list of text that needs to add bullets
    ///   - lblToSet: lbl to set attributed text
    func setBulletedString(arrString : [String] , lblToSet : UILabel)
    {
        let attributesDictionary : [String : Any] = [NSFontAttributeName : lblToSet.font]
        
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary)
        
        for string: String in arrString
        {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(string)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = self.createParagraphAttribute()
            attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            
            fullAttributedString.append(attributedString)
        }
        
        lblToSet.attributedText = fullAttributedString
        lblToSet.minimumScaleFactor = 0.9
        lblToSet.baselineAdjustment = .alignBaselines
        lblToSet.lineBreakMode = .byClipping
    }
    
    /// Creates new paragraph attribute for attributed string
    ///
    /// - Returns: return ParagraphStyle
    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 14
        return paragraphStyle
    }
    
    /// To present view controller with given name
    ///
    /// - Parameters:
    ///   - name: Name of storyboard
    ///   - viewControllerName: Name of viewController
    func presentViewController(storyboard name : String ,viewControllerName : String ){
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let aVC = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        self.present(aVC, animated: true, completion: nil)
    }
    
    
    
    /// To push view controller with given name
    ///
    /// - Parameters:
    ///   - name: Name of storyboard
    ///   - viewControllerName: Name of viewController
    func pushViewController(storyboard name : String ,viewControllerName : String ){
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let aVC = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func openWebView(url urlToLoad : WebPageURL){
        let storyboard = UIStoryboard(name: StoryboardId.AUTHENTICATION, bundle: nil)
        let aGeneralWebPageLoaderVC = storyboard.instantiateViewController(withIdentifier: VCId.GENERALWEBVIEW)
        //aGeneralWebPageLoaderVC.currentURL = urlToLoad
        self.navigationController?.pushViewController(aGeneralWebPageLoaderVC, animated: true)
    }
    
    /// To logout current user
    func performLogout() {
        USERDEFAULTS.removeObject(forKey: UDKeys.USERDATA)   // Remove login user information
        USERDEFAULTS.removeObject(forKey: UDKeys.SELLERINFO) //Remove seller Information
        USERDEFAULTS.synchronize()
        
        APPDELEGATE.isCheckLogin()
        
        /*
         if self.isKind(of: HomeVC.self) == true{
         self.showLoginScreen()
         }
         else{
         
         self.navigationController!.popToRootViewController(animated: false)
         }*/
    }
    
    func callLogoutService(){
        let userObj = USERDEFAULTS.loadCustomObject(UDKeys.USERDATA) as! User
        
        let dictParam : [String : Any] = [
            Keys.userId : userObj.internalIdentifier!
        ]
        WebserviceHelper.sharedInstance.call(urlRequest: AuthenticationRouter.LogoutUser(dictParam).urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: true, returnResult: { (success, result, message) in
            if success == true{
                //self.performLogout()
            }
            // If Getting Error from then also user should be logout
            self.performLogout()
        })
    }
    
    
    //Playvideo in AVplayer with full screen
    func playVideoWithFullScreen(urlStr : String){
        let videoURL = URL(string: "\(String(describing: urlStr))")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //Convert object to Json string
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    func getCameraPicker(sender : UIButton, withType utTypes: [String]) -> UIImagePickerController?{
        let picker = UIImagePickerController()
        
        //let UTType : [String] =  [kUTTypeImage as String,kUTTypeMovie as String]
        picker.mediaTypes = utTypes
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) != true{
            return nil
        }
        
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.showsCameraControls = true
        
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            picker.modalPresentationStyle = .popover
            if let presenter = picker.popoverPresentationController {
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
            }
        }
        return picker
    }
    
    func arrangePhoneUSFormat(strPhone : String)-> String
    {
        var strUpdated = strPhone.convertToSimplePhoneString
        strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 3))
        strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 7))
        
        return strUpdated
    }
    
    //Covert Model Object PRODUCT -> FEED DETAIL
    func productToFeedDetail(objProduct : Product) -> FeedDetails{
        
        let json: JSON = [
            "product_id" : objProduct.id!,
            "user_id" : objProduct.userId!
        ]
        let objFeedDetails = FeedDetails(json: json)
        objFeedDetails.product = objProduct
        objFeedDetails.user = objProduct.user
        return objFeedDetails
    }
    
    func showMyMenu(){
        if let menuContainerViewController = self.parent as? MenuContainerViewController {
            menuContainerViewController.showSideMenu()
        }
        else if let menuContainerViewController = self.navigationController?.parent as? MenuContainerViewController{
            menuContainerViewController.showSideMenu()
        }
    }
    
    func showOptionActionSheet(withUserId id : Int, completionBlock: @escaping ActionSheetCompletion){
        if self.getCurrentUserId() == id {
            self.showActionSheetForCurrentUser(withcompletionBlock: { (intIndex) in
                completionBlock(intIndex, true)
            })
        }
        else{
            self.showActionSheetForOtherUser(withcompletionBlock: { (intIndex) in
                completionBlock(intIndex, false)
            })
        }
    }
    
    func showActionSheetForCurrentUser(withcompletionBlock block: @escaping AlertCompletion){
        let arrStrButtonName = ["Share to Facebook", "Tweet", "Edit", "Delete"]
        self.showActionSheetWithCompletion(pTitle: nil, pStrMessage: nil, arrButtonName: arrStrButtonName, destructiveButtonIndex: (arrStrButtonName.count - IntValues.ONE),strCancelButton: "Cancel" ,tintColor : nil, shouldAnimate: true) { (intIndex) in
            block(intIndex)
        }
    }
    
    func showActionSheetForOtherUser(withcompletionBlock block: @escaping AlertCompletion){
        let arrStrButtonName = ["Share to Facebook","Tweet","Follow","Report Post"]
        self.showActionSheetWithCompletion(pTitle: nil, pStrMessage: nil, arrButtonName: arrStrButtonName, destructiveButtonIndex: (arrStrButtonName.count - IntValues.ONE),strCancelButton: "Cancel" ,tintColor : nil, shouldAnimate: true) { (intIndex) in
            block(intIndex)
        }
    }
    
    //Web Services
    // Add Media Product
    func callAddEditProductMedia(param : [String : Any], isImage : Bool ,callback:@escaping ((ProductMedia) -> Void)){
        
        let strTitle = param[Keys.mediaTitle + "1" ]
        if isImage{
            //UPLOAD IMAGE
            let dicParam : [String : Any] = [
                Keys.mediaCount : "1",
                Keys.mediaType + "1" :"image",
                Keys.mediaTitle + "1" : strTitle != nil ? strTitle! : "",
                Keys.isActive + "1" : param[Keys.isActive + "1"]!
            ]
            WebserviceHelper.sharedInstance.CallWebServiceWithImage(DetailsRouter.AddEditProductMedia().path, image: param[Keys.mediaFile + "1"] as? UIImage , strImageParam: Keys.mediaFile + "1", params: dicParam, parentViewController: self, parentView: self.view, isShowProgress: true, returnResult: { (success, result, message)  in
                
                if success == true{
                    let arrResult = result as! [JSON]
                    let mediaObj = ProductMedia(json: arrResult.first!)
                    callback(mediaObj)
                }
            })
        }else{
            //UPLOAD VIDEO
            let dicParam : [String : Any] = [
                Keys.mediaCount : "1",
                Keys.mediaType + "1" : "video",
                Keys.mediaTitle : strTitle != nil ? strTitle! : "",
                Keys.isActive + "1" : param[Keys.isActive + "1"]!
            ]
            
            var vidData : Data?
            do{
                //                self.getDataFromVideoURL(url: (param[Keys.mediaFile + "1"]! as! URL))
                vidData = try Data(contentsOf: (param[Keys.mediaFile + "1"]! as! URL))
            }
            catch{
                self.showAlertWithCompletion(pTitle: nil, pStrMessage: " \(error.localizedDescription) Failed to load video. Please try with another file", includeOkButton: true, includeCancelButton: false, completionBlock: nil)
                return
            }
            let vidThumb = URL(string: "\(param[Keys.mediaFile + "1"]!)")!.getVideoThumbnail()
            let fileParam : [[String:Any]] = [
                [
                    "mediaType" : "video",
                    "mediaKey" : Keys.mediaFile + "1",
                    "media" : vidData!
                ],
                [
                    "mediaType" : "image",
                    "mediaKey" : Keys.mediaThumb + "1",
                    "media" : vidThumb
                ]
            ]
            
            //                        mediaTypeKey = mediaType,avatarType
            //                        mediaFileKey = media,avatar
            WebserviceHelper.sharedInstance.CallWebServiceWithMultipleFile(DetailsRouter.AddEditProductMedia().path, fileParam: fileParam, params: dicParam, parentViewController: self, mediaTypeKey: "mediaType", mediaFileKey: "media",isShowProgress: true, parentView: self.view, returnResult: { (success, result, message)  in
                
                if success == true{
                    let arrResult = result as! [JSON]
                    let mediaObj = ProductMedia(json: arrResult.first!)
                    callback(mediaObj)
                }
            })
        }
    }
    
    func getTmpVideoURL(withAssetURL url : URL,shouldCropTo : Float?, returnResult : @escaping Webservicecompletion){
        let fileName = url.absoluteString.components(separatedBy: "/").last
        let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL: URL? = tempDirectoryURL.appendingPathComponent(fileName!)
        self.exportVideoToURL(withAssetURL: url, fileURL: fileURL!, shouldCropTo: shouldCropTo) { (success, result, message) in
            returnResult(success, result, message)
        }
    }
    
    func getTmpCameraVideoURL(withAssetURL url : URL,shouldCropTo : Float?, returnResult : @escaping Webservicecompletion){
        let fileName = "cam_".appending(url.absoluteString.components(separatedBy: "/").last!)
        let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL: URL? = tempDirectoryURL.appendingPathComponent(fileName)
        self.exportVideoToURL(withAssetURL: url, fileURL: fileURL!, shouldCropTo: shouldCropTo) { (success, result, message) in
            returnResult(success, result, message)
        }
    }
    
    private func exportVideoToURL(withAssetURL url : URL, fileURL : URL, shouldCropTo : Float?, returnResult : @escaping Webservicecompletion){
        let avasset = AVAsset(url: url)
        
        let exportSession = AVAssetExportSession(asset: avasset, presetName: AVAssetExportPresetHighestQuality)
        
        exportSession?.outputURL = fileURL
        // e.g .mov type
        exportSession?.outputFileType = AVFileTypeQuickTimeMovie
        if shouldCropTo != nil{
            let length = Float(avasset.duration.value) / Float(avasset.duration.timescale)
            let startTime = CMTime(seconds: Double(0), preferredTimescale: 1000)
            var endTime = CMTime(seconds: Double(shouldCropTo!), preferredTimescale: 1000)
            if length < shouldCropTo!{
                endTime = CMTime(seconds: Double(length), preferredTimescale: 1000)
            }
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            exportSession?.timeRange = timeRange
        }
        exportSession?.exportAsynchronously(completionHandler: {() -> Void in
            print("AVAsset saved to Tmp")
            return returnResult(true,fileURL,"AVAsset saved to Tmp")
        })
    }
    
    /*
     WEB SERVICE
     generate nonce from token by client side and send to service via this funtion
     nonce: String
     method : (1) card ,(2) paypal
     */
    func parametersForPurchaseProduct(fromVC : DeliveryVC,serviceSubscriptionType : SubscriptionType?) -> ([String:Any],String){
        let objDeliveryVC = fromVC
        let objAryFullDetail = objDeliveryVC.aryAllDetail
        let objProduct = objAryFullDetail[6]["productData"] as! Product
        var coin : String = "0"
        if (objAryFullDetail[8]["isHidden"] as? Bool) == false{
            if (objAryFullDetail[8]["isSelected"] as? Bool) == true && (objAryFullDetail[9]["usableCoins"] as! String).isEmpty == false{
                coin = objAryFullDetail[9]["usableCoins"] as! String
            }
        }
        
        var dictParamPurchase = [String : Any]()
        if objProduct.type?.lowercased() == OtherConstant.ProductType.product.rawValue.lowercased(){
            let objShippingAdd = objAryFullDetail[1]["shippingData"] as! Address
            let isSameShipping = objAryFullDetail[2]["isSelected"] as? Bool
            
            dictParamPurchase = [
                Keys.productId : objProduct.id!,
                Keys.deliberyAddressId : objShippingAdd.internalIdentifier!,
                Keys.purchaseType : OtherConstant.SellType.sell.rawValue,
                Keys.isSame : isSameShipping! ? 1 : 0,
                Keys.coin   : coin
            ]
            if !isSameShipping!{
                let objBillingAdd = objAryFullDetail[4]["billingData"] as! Address
                dictParamPurchase.updateValue(objBillingAdd.internalIdentifier!, forKey: Keys.billingAddressId)
            }
            
            if let bidId = objDeliveryVC.bidId{
                dictParamPurchase.updateValue(bidId, forKey: Keys.bidId)
            }
        }else{
            let objAryFullDetail = fromVC.aryAllDetail
            let objProduct = objAryFullDetail[6]["productData"] as! Product
            dictParamPurchase = [
                Keys.productId : objProduct.id!,
                Keys.subscriptionDuration : 1,
                Keys.subscriptionDurType : (serviceSubscriptionType?.rawValue)!,   //month/year/onetime
                Keys.isAuto : 0,
                Keys.coin   : coin
            ]
        }
        return (dictParamPurchase,(objProduct.type?.lowercased())!)
    }
    
    func setPaymentInfo(nonce: String, method:OtherConstant.PaymentMethod, dictVal : [String:Any], productType : String){
        let dictParam : [String:Any] = [
            Keys.nonce : nonce,
            Keys.method : method.rawValue
        ]
        WebserviceHelper.sharedInstance.call(urlRequest: DetailsRouter.SetBuyerCards(dictParam).urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: true, returnResult: { (success, result, message) in
            if success == true{
                
                //Set Product Data
                let arrResult = result as! [JSON]
                for dicResult in arrResult{
                    let objCard = CardDetail(json: dicResult)
                    
                    var aNewDictParam = dictVal
                    aNewDictParam.updateValue(objCard.internalIdentifier!, forKey: Keys.buyerCardId)
                    
                    if productType == OtherConstant.ProductType.product.rawValue.lowercased(){
                        //Final Payment Service calling
                        self.callPurchaseProductService(dictParam: aNewDictParam)
                    }else{
                        self.callPurchaseSubscriptionService(dictParam: aNewDictParam)
                    }
                }
            }
        })
    }
    
    func callPurchaseProductService(dictParam : [String:Any]){
        WebserviceHelper.sharedInstance.call(urlRequest: DetailsRouter.PurchaseProduct(dictParam).urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: true, returnResult: { (success, result, message) in
            if success == true{
                
                let objFineshVC = self.storyboard?.instantiateViewController(withIdentifier: VCId.FINESHVC) as! FineshVC
                self.navigationController?.pushViewController(objFineshVC, animated: true)
            }
        })
    }
    
    func callPurchaseSubscriptionService(dictParam : [String:Any]){
        WebserviceHelper.sharedInstance.call(urlRequest: DetailsRouter.PurchaseSubscription(dictParam).urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: true, returnResult: { (success, result, message) in
            if success == true{
                
                let objFineshVC = self.storyboard?.instantiateViewController(withIdentifier: VCId.FINESHVC) as! FineshVC
                self.navigationController?.pushViewController(objFineshVC, animated: true)
            }
        })
    }
    
    func callFollowUnfollowWS(withUser ObjUser : User, returnResult : @escaping Webservicecompletion){
        var dicData : [String : Any] = [
            Keys.userId : (ObjUser.id)!,
            Keys.isFollow : ObjUser.isFollow == 0 ? 1 : 0
        ]
        
        //for Private Account
        if ObjUser.isRequested == true && ObjUser.isFollow == 0{
            dicData[Keys.isFollow] = 2 //cancel reques
        }
        
        WebserviceHelper.sharedInstance.call(urlRequest: DetailsRouter.SetFollowuser(dicData).urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: true) { (success, result, message) in
            returnResult(success, result,message)
        }
    }
    
    func callDeletePostWS(withPostId id : Int, returnResult : @escaping Webservicecompletion){
        let dicData : [String : Any] = [
            Keys.productId: id]
        WebserviceHelper.sharedInstance.call(urlRequest: DetailsRouter.RemovePost(dicData).urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: true) { (success, result, message) in
            returnResult(false, result,message)
        }
    }
    
    func removeFeedFromArray(withId feedId : Int, arrToFilter : [FeedDetails]) -> [FeedDetails]{
        let arrFilteredData = arrToFilter.filter({ (objFeedDetails) -> Bool in
            objFeedDetails.productId != feedId
        })
        return arrFilteredData
    }
    
    
    func callWS(withUser ObjUser : User, returnResult : @escaping Webservicecompletion){
        let dicData : [String : Any] = [
            Keys.userId : (ObjUser.id)!,
            Keys.isFollow : ObjUser.isFollow == 0 ? 1 : 0
        ]
        WebserviceHelper.sharedInstance.call(urlRequest: DetailsRouter.SetFollowuser(dicData).urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: true) { (success, result, message) in
            returnResult(false, result,message)
        }
    }
    
    func removeAllTmpFiles(){
//        FileManager.default.clearTmpDirectory()
    }
    
    //check if current user is login user or not
    func isUserSameAsLoginUser(userId : Int) -> Bool{
        return self.getCurrentUserId() == userId
    }
    
    //check if current user is login user or not
    func getCurrentUserId() -> Int{
        let userData = USERDEFAULTS.loadCustomObject(UDKeys.USERDATA) as? User
        return (userData?.id)!
    }
    
    // (LOCAL TO UTC)
    func convertlocalToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATETIMEFORMATE.WEBSERVICEFORM
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = DATETIMEFORMATE.WEBSERVICEFORM
        
        return dateFormatter.string(from: dt!)
    }
    
    
    func getMediaSharingLink(withProductId id : Int) -> String{
        return "\(BaseurlString.BASE_URL)/product/share/\(id)"
    }
    
    func showHud(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideHud(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func getImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        option.deliveryMode = .highQualityFormat
        option.isNetworkAccessAllowed = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize , contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func getURLFromAsset(asset: PHAsset,completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if asset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            asset.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if asset.mediaType == .video {
            
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            options.isNetworkAccessAllowed = true
            
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                let url = ((asset as? AVURLAsset)?.url.standardizedFileURL)
                print("url = \((url?.absoluteString)!)")
                print("url = \((url?.relativePath)!)")
                completionHandler(url)
            })
        }
    }
    
    func loadVideoToPlayerContoller(videoUrl : String){
        
        let streamingURL = URL(string: videoUrl)!
        let player = AVPlayer(url: streamingURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
//        self.addChildViewController(playerController)
//        self.addSubview(playerController.view)
        self.present(playerController, animated: true, completion: nil)
//        playerController.view.frame = self.videoContainerView.bounds
        player.play()
    }
    
    
    /// Export MPMediaItem to temporary file.
    ///
    /// - Parameters:
    ///   - assetURL: The `assetURL` of the `MPMediaItem`.
    ///   - completionHandler: Closure to be called when the export is done. The parameters are a boolean `success`, the `URL` of the temporary file, and an optional `Error` if there was any problem. The parameters of the closure are:
    ///
    ///   - fileURL: The `URL` of the temporary file created for the exported results.
    ///   - error: The `Error`, if any, of the asynchronous export process.
    
    func exportMusicFile(withAsset url: URL, completionHandler: @escaping (_ fileURL: URL?, _ error: Error?) -> ()) {
        let asset = AVURLAsset(url: url)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completionHandler(nil, ExportError.unableToCreateExporter)
            return
        }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(NSUUID().uuidString)
            .appendingPathExtension("m4a")
        
        exporter.outputURL = fileURL
        exporter.outputFileType = "com.apple.m4a-audio"
        
        exporter.exportAsynchronously {
            if exporter.status == .completed {
                completionHandler(fileURL, nil)
            } else {
                completionHandler(nil, exporter.error)
            }
        }
    }
}

enum ExportError: Error {
    case unableToCreateExporter
}

// MARK: - FileManager Utility Methods
extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - CAShapeLayer Utility Methods
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0;

// MARK: - UIBarButtonItem Utility Methods
extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        /*var badgeWidth = 8
         var numberOffset = 4
         
         if number > 9 {
         badgeWidth = 12
         numberOffset = 6
         }
         else if number > 99 {
         badgeWidth = 12
         numberOffset = 6
         }*/
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(5)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        /* let label = CATextLayer()
         label.string = "\(number)"
         label.alignmentMode = kCAAlignmentCenter
         label.fontSize = 11
         label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
         label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
         label.backgroundColor = UIColor.clear.cgColor
         label.contentsScale = UIScreen.main.scale
         badge.addSublayer(label)
         label.truncationMode = "end"
         label.bre*/
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}

// MARK: - UILabel Utility Methods
extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength()
        let mutableString: String = self.text!
        
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.characters.count)! - lengthForVisibleString)), with: "")
        
        let readMoreLength: Int = (readMoreText.characters.count)
        
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.characters.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSFontAttributeName: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSFontAttributeName: moreTextFont, NSForegroundColorAttributeName: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    
    func getTrimmedString() -> String{
        let lengthForVisibleString: Int = self.vissibleTextLength()
        let mutableString: String = self.text!
        
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.characters.count)! - lengthForVisibleString)), with: "")
        
        return trimmedString!
        /*
         let readMoreLength: Int = (readMoreText.characters.count)
         
         let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.characters.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
         let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSFontAttributeName: self.font])
         let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSFontAttributeName: moreTextFont, NSForegroundColorAttributeName: moreTextColor])
         answerAttributed.append(readMoreAttributed)
         self.attributedText = answerAttributed*/
    }
    
    func vissibleTextLength() -> Int {
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [AnyHashable: Any] = [NSFontAttributeName: font]
        if self.getTextRelatedHeight() > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.characters.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.characters.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [String : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.characters.count
    }
    
    func getTextRelatedHeight() -> CGFloat{
        let font: UIFont = self.font
        let labelWidth: CGFloat = self.frame.size.width
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSFontAttributeName: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [String : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        return boundingRect.height
    }
}

// MARK: - AVPlayer Utility Methods
extension AVPlayer {
    
    /**
     * Description: Currently video is play or not
     * Parameters: nil
     * Returns: Returns video current status
     */
    
    var isPlaying: Bool {
        return ((rate != 0) && (error == nil))
    }
}

// MARK: - UITableView Utility Methods
extension UITableView {
    
    /// Check if UITableViewCell at the specific section and row is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UITableView section
    /// - row: and Int representing a UITableView row
    /// - Returns: True if cell at section and row is visible, False otherwise
    func isCellVisible(section:Int, row: Int) -> Bool {
        let indexes = self.indexPathsForVisibleRows!
        return indexes.contains {$0.section == section && $0.row == row }
    }
}

// MARK: - UICollectionView Utility Methods
extension UICollectionView {
    
    /// Check if UICollectionViewCell at the specific section and item is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UICollectionView section
    /// - item: and Int representing a UICollectionView row
    /// - Returns: True if cell at section and item is visible, False otherwise
    func isItemVisible(section:Int, item: Int) -> Bool {
        let indexes = self.indexPathsForVisibleItems
        return indexes.contains {$0.section == section && $0.item == item }
    }
}

// MARK: - UICollectionViewCell Utility Methods
extension UICollectionViewCell {
    
    /// Check if UICollectionViewCell at the specific section and item is visible
    /// - Parameters:
    /// - strText: text to set
    func  setLabelTextNotNil(strText : String, inLabel lblToSet: UILabel?) {
        if lblToSet != nil{
            lblToSet?.text = strText
        }
    }
    
    
}

// MARK: - UITableViewCell Utility Methods
extension UITableViewCell {
    
    /// Check if UICollectionViewCell at the specific section and item is visible
    /// - Parameters:
    /// - strText: text to set
    func  setLabelTextNotNil(strText : String, inLabel lblToSet: UILabel?) {
        if lblToSet != nil{
            lblToSet?.text = strText
        }
        
    }
    
    //check if current user is login user or not
    func getCurrentUserId() -> Int{
        if (USERDEFAULTS.loadCustomObject(UDKeys.USERDATA) != nil){
            let userData = USERDEFAULTS.loadCustomObject(UDKeys.USERDATA) as? User
            return (userData?.id)!
        }
        return 0
    }
}


// MARK: - UIApplication Utility Methods
//Top VIEW Controller
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let menuVC = controller as? MenuHostVC{
            return menuVC.childViewControllers.first!.childViewControllers.last
        }
        return controller
    }
}

extension KMPlaceholderTextView{
    
    func setValueInKMTextView(value : String){
        self.text = value
        
        //hide show lable
        if self.text?.length != 0{
            for view in (self.superview?.subviews)!{
                if view is UILabel{
                    let lbl = view as! UILabel
                    lbl.isHidden = false
                    self.placeholder = ""
                }
            }
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UILabel {
    func setAttributedString(_ text: String) {
        let mutAttrString = NSMutableAttributedString(string: text)
        mutAttrString.addAttributes([NSFontAttributeName : self.font!], range: NSRange(location: 0, length: text.characters.count))
        mutAttrString.addAttributes([NSForegroundColorAttributeName : self.textColor!], range: NSRange(location: 0, length: text.characters.count))
        self.attributedText = mutAttrString
    }
    
    func setFontOfString(_ text: String, font: String) {
        let mutAttrString = NSMutableAttributedString(attributedString: self.attributedText!)
        mutAttrString.setFontOfString(text, font: UIFont(name:font, size: self.font!.pointSize)!)
        self.attributedText = mutAttrString
    }
    
    func setFontOfString(_ text: String, font: String, withSize: CGFloat) {
        let mutAttrString = NSMutableAttributedString(attributedString: self.attributedText!)
        mutAttrString.setFontOfString(text, font: UIFont(name:font, size: withSize)!)
        self.attributedText = mutAttrString
    }
    
    func setLinkOfString(_ text: String, link: String) {
        let mutAttrString = NSMutableAttributedString(attributedString: self.attributedText!)
        mutAttrString.setAsLink(textToFind: text, linkURL: link)
        self.attributedText = mutAttrString
    }
    
    func setColorForString(_ text: String, color: UIColor) {
        let mutAttrString = NSMutableAttributedString(attributedString: self.attributedText!)
        mutAttrString.setColorForString(text, color: color)
        self.attributedText = mutAttrString
    }
    
    //    func alignTextVerticalInTextView() {
    //        let size = self.sizeThatFits(CGSize(width: self.bounds.width, height: CGFloat(MAXFLOAT)))
    //        var topoffset = (self.bounds.size.height - size.height * self.zoomScale) / 2.0
    //        topoffset = topoffset < 0.0 ? 0.0 : topoffset
    //        self.contentOffset = CGPoint(x: 0, y: -topoffset)
    //    }
}

extension NSMutableAttributedString {
    func setFontOfString(_ text: String, font: UIFont) {
        let ranges: [NSRange]
        do {
            let regex = try NSRegularExpression(pattern: text, options: [])
            ranges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.characters.count)).map {$0.range}
        }
        catch {
            ranges = []
        }
        for range in ranges{
            self.addAttributes([NSFontAttributeName : font], range: range)
        }
    }
    
    func setUnderlineForString(_ text: String) {
        let ranges: [NSRange]
        do {
            let regex = try NSRegularExpression(pattern: text, options: [])
            ranges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.characters.count)).map {$0.range}
        }
        catch {
            ranges = []
        }
        for range in ranges{
            self.addAttributes([NSUnderlineStyleAttributeName : 1], range: range)
        }
    }
    
    func setColorForString(_ text: String, color : UIColor) {
        let ranges: [NSRange]
        do {
            let regex = try NSRegularExpression(pattern: text, options: [])
            ranges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.characters.count)).map {$0.range}
        }
        catch {
            ranges = []
        }
        for range in ranges{
            self.addAttributes([NSForegroundColorAttributeName : color], range: range)
        }
    }
    
    func setAsLink(textToFind:String, linkURL:String) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
        }
    }
}


extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf16.rawValue], documentAttributes: nil)
        } catch {
            print(error)
        }
        return nil
    }
}

extension String {
    var data: Data {
        return self.data(using: String.Encoding.utf16, allowLossyConversion: false)!
    }
    
    func convertEmbededLinkDicToText() -> String{
        let arrStr = self.components(separatedBy: "<a href=")
        print(arrStr)
        return self
    }
    
    func getEmbededLink(withId userId : String) -> String{
        return "<a href=\"SSIT\(userId)\" style=\"text-decoration:none\">@\(self)</a>"
    }
    
    func getCommentString(arrTagUsers : [Tagusers]) -> String{
        var originalText = self
        for objTagUsers in arrTagUsers{
            let strToReplace = "<<<\((objTagUsers.id)!)>>>"
            originalText = originalText.replacingOccurrences(of: strToReplace, with: "<a href=\"SSIT\((objTagUsers.id)!)\" style=\"text-decoration:none\">@\((objTagUsers.uname)!)</a>")
        }
        return originalText
    }
}


extension User{
    func getMentionString() -> String{
        return "<<<\((self.internalIdentifier)!)>>>"
    }
}

// MARK: - UIViewController In-App Purchase Methods

extension UIViewController {
    /// fetches all the plans associated with the current user
    func getFollowersPurchasePlans(returnResult : @escaping Webservicecompletion) {
        var dicUserToken = [String : Any]()
        dicUserToken[Keys.token] = DetailsRouter.token
        WebserviceHelper.sharedInstance.call(urlRequest: DetailsRouter.GetFeedList().urlRequest!, parentViewController: self, parentView: self.view, isShowProgress: false) { (success, result, message) in
            if success == true{
                if (result != nil){
                    let arrResponse = result as? [JSON]
                    print(arrResponse!)
                }
            }
            
            returnResult(success, result, message)
        }
    }
    
    /// Purchase the IAP product for the current user.
    
    func purchaseIAPProduct(productId : String,returnResult : @escaping Webservicecompletion) {
        if SwiftyStoreKit.canMakePayments == true{
            SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
                switch result {
                case .success(let product):
                    
                    print("Purchase Success: \(product.productId)")
                    let receiptData = SwiftyStoreKit.localReceiptData
                    let receiptString = receiptData?.base64EncodedString(options: [])
                    returnResult(true, receiptString, nil)
                case .error(let error):
                    
                    var errorMsg = ""
                    switch error.code {
                    case .unknown:
                        errorMsg = "Unknown error. Please contact support"
                    case .clientInvalid:
                        errorMsg = "Not allowed to make the payment"
                    case .paymentCancelled:
                        errorMsg = "The payment was cancelled"
                        break
                    case .paymentInvalid:
                        errorMsg = "The purchase identifier is invalid"
                    case .paymentNotAllowed:
                        errorMsg = "The device is not allowed to make the payment"
                    case .storeProductNotAvailable:
                        errorMsg = "The product is not available in the current storefront"
                    case .cloudServicePermissionDenied:
                        errorMsg = "Access to cloud service information is not allowed"
                    case .cloudServiceNetworkConnectionFailed:
                        errorMsg = "Could not connect to the network"
                    default :
                        errorMsg = "Unknown error. Please contact support"
                    }
                    returnResult(false, nil, errorMsg)
                    print(errorMsg)
                }
            }
        }
        else{
            self.showAlertWithCompletion(pTitle: nil, pStrMessage: "Unable to proceed. User is not allowed to authorize payment. In-app purchase is disabled", includeOkButton: true, includeCancelButton: false, completionBlock: nil)
        }
    }
    
}
