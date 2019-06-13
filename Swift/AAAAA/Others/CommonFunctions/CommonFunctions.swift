//
//  CommonFunctions.swift
//  PsychScribe
//
//  Created by Ashish Kakkad on 7/28/16.
//  Copyright © 2016 MoveoApps. All rights reserved.
//

import UIKit

class CommonFunctions: NSObject {

    // MARK: - Present Alert
    
    class func presentAlertWithMessage(_ strMessage: String)
    {
        if !(strMessage.contains(Messages.kTokenExpired) || strMessage.contains(Messages.kTokenSignatureNotVerified)) {
            let alertController = UIAlertController(title: Constants.kAppName, message: strMessage.localized(lang: UserDefaults.standard.object(forKey:Constants.kLanguage) as! String), preferredStyle: .alert)
            let alertActionOk = UIAlertAction(title: "OK", style: .default, handler: { (ACTION) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(alertActionOk)
            UIApplication.shared.keyWindow!.rootViewController!.present(alertController, animated: true, completion:nil)
        }
    }
    
    class func presentAlertWithMessage(_ strMessage: String, viewController : UIViewController)
    {
        if !(strMessage.contains(Messages.kTokenExpired) || strMessage.contains(Messages.kTokenSignatureNotVerified)) {
            let alertController = UIAlertController(title: Constants.kAppName, message: strMessage, preferredStyle: .alert)
            let alertActionOk = UIAlertAction(title: "OK", style: .default, handler: { (ACTION) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(alertActionOk)
            viewController.present(alertController, animated: true, completion:nil)
        }
    }
    
    // MARK: - Email Validation
    
    class func validateEmail(_ aStrEmailAdd: String) -> Bool
    {
        let aStrEmailRegex: String = "(?:[A-Za-z0-9]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-" +
            "zA-Z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let aPredEmailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", aStrEmailRegex)
        let boolIsEmailValid: Bool = aPredEmailTest.evaluate(with: aStrEmailAdd)
        return boolIsEmailValid
    }
    
    // MARK: - Custom Object with User Defaults
    
    class func saveCustomObject(_ object: AnyObject, key: String) {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedObject, forKey: key)
        userDefaults.synchronize()
    }
    
    class func loadCustomObject(_ key: String) -> AnyObject {
        let userDefaults = UserDefaults.standard
        let encodedObject = userDefaults.object(forKey: key) as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: encodedObject)! as AnyObject
    }
    
    // MARK: - Get Image from Color
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - Date Formatting Functions
    
    class func stringToDate(_ strDate: String, strForFormat strFormat: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = strFormat
        if let date = formatter.date(from: strDate) {
            return date
        }
        else {
            return Date()
        }
    }
    
    class func formatDateString(_ strDate: String, stringToFormat strFormat: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date: Date = formatter.date(from: strDate) {
            formatter.dateFormat = strFormat
            return formatter.string(from: date)
        }
        else {
            return ""
        }
    }
    
    class func formatDateString(_ strDate: String, stringFromFormat strFromFormat: String, stringToFormat strToFormat: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = strFromFormat
        if let date: Date = formatter.date(from: strDate) {
            formatter.dateFormat = strToFormat
            return formatter.string(from: date)
        }
        else {
            return ""
        }
    }
    
    class func formatDate(_ date: Date, stringToFormat strFormat: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = strFormat
        return formatter.string(from: date)
    }
    
    // MARK :- getObjectTableIndexPath
    class func getObjectTableIndexPath(_ anyView:AnyObject, tblView:UITableView) -> IndexPath {
        let  pointInTable = anyView.convert(anyView.bounds.origin, to: tblView) as CGPoint
        let indxPath = tblView.indexPathForRow(at: pointInTable)! as IndexPath
        return indxPath
    }
    
    // MARK :- Convert dictionary to JSON String
    
    class func jsonStringEncoding(_ aDict:[String:AnyObject]) -> String{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: aDict, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            // here "jsonData" is the dictionary encoded in JSON data
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print(jsonString)
            return jsonString
        } catch let error as NSError {
            print(error)
            return ""
        }
    }
    
    class func jsonStringFromArrayEncoding(_ aArr:[AnyObject]) -> String{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: aArr, options: JSONSerialization.WritingOptions.prettyPrinted)
            //            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            // here "jsonData" is the dictionary encoded in JSON data
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print(jsonString)
            return jsonString
        } catch let error as NSError {
            print(error)
            return ""
        }
    }
    
    //MARK: Document Directory paths
    class func getPathDocumentDirectory() -> String{
        
        let fileManager = FileManager.default
        let pathsFolder = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("IncidentItems")
        //        print("IMAGE PATH:\(pathsFolder)")
        
        if !fileManager.fileExists(atPath: pathsFolder){
            try! fileManager.createDirectory(atPath: pathsFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathsFolder
    }
    
    class func getImageFromDocumentDirectory(fileName : String) -> UIImage{
        var getImage = UIImage(named:"")
        
        let fileManager = FileManager.default
        let pathsFolder = getPathDocumentDirectory()
        let imagePAth = (pathsFolder as NSString).appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: imagePAth){
            getImage = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
        
        return getImage!
    }
    
    class func saveImageDocumentDirectory(image : UIImage) -> String{
        
        let fileManager = FileManager.default
        let pathsFolder = CommonFunctions.getPathDocumentDirectory()
        
        // image name with time stamp
        let imageName = "\(NSDate().timeIntervalSince1970 * 1000)"
        
        // save image
        let paths = (pathsFolder as NSString).appendingPathComponent(imageName)
        print(paths)
        let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        return imageName
    }
    
    //MARK: -Image operation
    class func scaleAndRotateImage(_ image: UIImage, kMaxResolution: CGFloat) -> UIImage {
        var imageCopy: UIImage = image
        if let imgRef: CGImage = image.cgImage {
            
            let width = CGFloat(imgRef.width)
            let height = CGFloat(imgRef.height)
            
            var transform = CGAffineTransform.identity
            var bounds = CGRect(x: 0, y: 0, width: width, height: height)
            
            if width > kMaxResolution || height > kMaxResolution {
                let ratio = width/height
                if ratio > 1 {
                    bounds.size.width = kMaxResolution
                    bounds.size.height = bounds.size.width / ratio
                } else {
                    bounds.size.height = kMaxResolution
                    bounds.size.width = bounds.size.height * ratio
                }
            }
            
            let scaleRatio = bounds.size.width / width
            let imageSize = CGSize(width: width, height: height)
            let boundHeight: CGFloat
            let orient: UIImageOrientation = image.imageOrientation
            switch orient {
            case .up:
                transform = CGAffineTransform.identity
                
            case .upMirrored:
                transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
                transform = transform.scaledBy(x: -1.0, y: 1.0)
                
            case .down:
                transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
                transform = transform.rotated(by: CGFloat(M_PI))
                
            case .downMirrored: //EXIF = 4
                transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
                transform = transform.scaledBy(x: 1.0, y: -1.0);
                
            case .leftMirrored: //EXIF = 5
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
                transform = transform.scaledBy(x: -1.0, y: 1.0);
                transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);
                
            case .left: //EXIF = 6
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
                transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);
                
            case .rightMirrored: //EXIF = 7
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
                transform = transform.rotated(by: CGFloat(M_PI) / 2.0);
                
            case .right: //EXIF = 8
                boundHeight = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = boundHeight;
                transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
                transform = transform.rotated(by: CGFloat(M_PI) / 2.0);
            }
            UIGraphicsBeginImageContext(bounds.size)
            
            if let context: CGContext = UIGraphicsGetCurrentContext() {
                if orient == .right || orient == .left {
                    context.scaleBy(x: -scaleRatio, y: scaleRatio)
                    context.translateBy(x: -height, y: 0)
                } else {
                    context.scaleBy(x: scaleRatio, y: -scaleRatio)
                    context.translateBy(x: 0, y: -height)
                }
                
                context.concatenate(transform)
                
                UIGraphicsGetCurrentContext()?.draw(imgRef, in: CGRect(x: 0,y: 0,width: width,height: height))
                imageCopy = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        }
        return imageCopy
    }

}
