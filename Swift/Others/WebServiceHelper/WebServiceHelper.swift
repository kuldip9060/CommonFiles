//
//  WebServiceHelper.swift
//  PsychScribe
//
//  Created by Ashish Kakkad on 7/27/16.
//  Copyright © 2015 MoveoApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebServiceHelper: NSObject
{
    typealias SuccessHandler = (JSON) -> Void
    typealias FailureHandler = (Error) -> Void
    /*
    class func checkTokenExpiration(_ strMessage : String) {
        if strMessage.contains(Messages.kTokenExpired) || strMessage.contains(Messages.kTokenSignatureNotVerified) {
            let userDefaults = UserDefaults.standard
            if let _ = userDefaults.object(forKey: Constants.kUserProfile) {
                userDefaults.removeObject(forKey: Constants.kUserProfile)
                userDefaults.synchronize()
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.checkUserAvailability(true)
        }
    }
    */
    // MARK: - Helper Methods

    class func getWebServiceCall(_ strURL : String, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler){
        let viewIndicator = UIView()
        if isShowLoader == true {
            viewIndicator.showIndicator()
        }
        
        Alamofire.request(strURL).responseJSON { (resObj) -> Void in
            
            print(resObj)
            
            if resObj.result.isSuccess {
                let resJson = JSON(resObj.result.value!)
                
                if isShowLoader == true {
                    viewIndicator.hideIndicator()
                }
                
                success(resJson)
            }
            if resObj.result.isFailure {
                let error : Error = resObj.result.error!
                
                CommonFunctions.presentAlertWithMessage(error.localizedDescription)
                
                if isShowLoader == true {
                    viewIndicator.hideIndicator()
                }
                
                failure(error)
            }
        }
    }
    
    class func getWebServiceCall(_ strURL : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler){
        let viewIndicator = UIView()
        if isShowLoader == true {
            viewIndicator.showIndicator()
        }
        
        Alamofire.request(strURL, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (resObj) -> Void in
            
            print(resObj)
            
            if resObj.result.isSuccess {
                let resJson = JSON(resObj.result.value!)
                
                if isShowLoader == true {
                    viewIndicator.hideIndicator()
                }
                
                success(resJson)
            }
            if resObj.result.isFailure {
                let error : Error = resObj.result.error!
                
                CommonFunctions.presentAlertWithMessage(error.localizedDescription)
                
                if isShowLoader == true {
                    viewIndicator.hideIndicator()
                }
                
                failure(error)
            }
        }
    }
    
    class func postWebServiceCall(_ strURL : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler)
    {
        
        let viewIndicator = UIView()
        if isShowLoader == true
        {
            viewIndicator.showIndicator()
        }

        let headers = ["PC-API-KEY" : Constants.kApiKey]
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (resObj) -> Void in
            
            print(resObj)
            
            if resObj.result.isSuccess
            {
                let resJson = JSON(resObj.result.value!)
                
                if isShowLoader == true
                {
                    viewIndicator.hideIndicator()
                }
                
                success(resJson)
            }
            
            if resObj.result.isFailure
            {
                let error : Error = resObj.result.error!
                
                CommonFunctions.presentAlertWithMessage(error.localizedDescription)
                
                if isShowLoader == true
                {
                    viewIndicator.hideIndicator()
                }
                
                failure(error)
            }
        }
    }
    
    class func postWebServiceCallWithImage(_ strURL : String, image : UIImage!, strImageParam : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler) {
        let viewIndicator = UIView()
        if isShowLoader == true
        {
            viewIndicator.showIndicator()
        }
        
        let header = ["PC-API-KEY" : Constants.kApiKey]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    //  multipartFormData.append(imageData, withName: NSDate.timeIntervalSinceReferenceDate().description+".jpg")
                    multipartFormData.append(imageData, withName:strImageParam , fileName: NSDate.timeIntervalSinceReferenceDate.description+".jpg", mimeType: "image/jpg")
                }
                
                for (key, value) in params! {
                    
                    let data = value as! String
                    
                    multipartFormData.append(data.data(using: String.Encoding.utf8)!, withName: key)
                    print(multipartFormData)
                }
        },
            to: strURL,
            headers : header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        //let datastring = String(data: response, encoding: String.Encoding.utf8)
                        
                        // let ds = String(datastring: response, encodingResult:String.Encoding.utf8)
                        // print(datastring)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    if isShowLoader == true
                    {
                        viewIndicator.hideIndicator()
                    }
                    
                    let error : NSError = encodingError as NSError
                    failure(error)
                }
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { (response) -> Void in
                        
                        if response.result.isSuccess
                        {
                            let resJson = JSON(response.result.value!)
                            
                            if isShowLoader == true
                            {
                                viewIndicator.hideIndicator()
                            }
                            
                            success(resJson)
                        }
                        
                        if response.result.isFailure
                        {
                            let error : Error = response.result.error! as Error
                            
                            if isShowLoader == true
                            {
                                viewIndicator.hideIndicator()
                            }
                            
                            failure(error)
                            
                            CommonFunctions.presentAlertWithMessage(error.localizedDescription)
                        }
                        
                    }
                case .failure(let encodingError):
                    if isShowLoader == true
                    {
                        viewIndicator.hideIndicator()
                    }
                    
                    let error : NSError = encodingError as NSError
                    failure(error)
                    
                    CommonFunctions.presentAlertWithMessage(error.localizedDescription)
                }
        }
        )
    }
    
    class func postWebServiceCallWithMultipleImages(_ strURL : String, images : [UIImage]!, strImageParam : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler) {
        let viewIndicator = UIView()
        if isShowLoader == true
        {
            viewIndicator.showIndicator()
        }
        
        let header = ["PC-API-KEY" : Constants.kApiKey]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for i in 0..<images.count {
                    if let imageData = UIImageJPEGRepresentation(images[i], 0.5) {
                        //  multipartFormData.append(imageData, withName: NSDate.timeIntervalSinceReferenceDate().description+".jpg")
                        multipartFormData.append(imageData, withName:strImageParam + "\(i+1)" , fileName: strImageParam + "\(i+1).jpg", mimeType: "image/jpg")
                        //                        print(strImageParam+"\(i+1)")
                        //                        print(strImageParam + "\(i+1)" + NSDate.timeIntervalSinceReferenceDate.description+".jpg")
                    }
                }
                
                for (key, value) in params! {
                    
                    let data = value as! String
                    
                    multipartFormData.append(data.data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: strURL,
            headers : header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        //let datastring = String(data: response, encoding: String.Encoding.utf8)
                        
                        // let ds = String(datastring: response, encodingResult:String.Encoding.utf8)
                        // print(datastring)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    if isShowLoader == true
                    {
                        viewIndicator.hideIndicator()
                    }
                    
                    let error : NSError = encodingError as NSError
                    failure(error)
                }
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { (response) -> Void in
                        
                        if response.result.isSuccess
                        {
                            let resJson = JSON(response.result.value!)
                            
                            if isShowLoader == true
                            {
                                viewIndicator.hideIndicator()
                            }
                            
                            success(resJson)
                        }
                        
                        if response.result.isFailure
                        {
                            let error : Error = response.result.error! as Error
                            
                            CommonFunctions.presentAlertWithMessage(error.localizedDescription)
                            
                            if isShowLoader == true
                            {
                                viewIndicator.hideIndicator()
                            }
                            
                            failure(error)
                        }
                        
                    }
                case .failure(let encodingError):
                    if isShowLoader == true
                    {
                        viewIndicator.hideIndicator()
                    }
                    
                    let error : NSError = encodingError as NSError
                    failure(error)
                    
                    CommonFunctions.presentAlertWithMessage(error.localizedDescription)
                }
        }
        )
    }
    
}
