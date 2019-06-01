//
//  Constants.swift
//  PsychScribe
//
//  Created by Ashish Kakkad on 7/21/16.
//  Copyright © 2016 MoveoApps. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    static let kAppName                     = "SE Logistics"
    static let kDeviceType                  = "1"
    static let kDeviceTokenKey              = "DeviceToken"
    static let kUserProfile                 = "UserProfile"
    static let kHelpAlreadySeen             = "HelpAlreadySeen"
    static let kStates                      = "States"
    static let kApiKey                      = "925f57a336b60ea756ecf663a593a754"
    static let kSCACcode                    = "SCACCode"
    static let kLocationID                  = "LocationID"
    static let kLanguage                    = "Language"
    static let kIsAlreadyLogin              = "isAlreadyLogin"
    static let kIsLogin                     = "isLogin"
    static let kIsLogout                    = "isLogout"
    static let kGoToNotification            = "Go to Notification"
    static let kCancel                      = "Cancel"

    // MARK: - Screen Size
    
    static let kScreenWidth                 = UIScreen.main.bounds.size.width
    static let kScreenHeight                = UIScreen.main.bounds.size.height
    
    // MARK: - Colors
    
    static let ColorBlue = UIColor(red: 2/255.0, green: 136/255.0, blue: 209/255.0, alpha: 1.0)
    static let ColorDarkBlue = UIColor(red: 2/255.0, green: 84/255.0, blue: 173/255.0, alpha: 1.0)
    static let ColorGreen = UIColor(red: 110/255.0, green: 189/255.0, blue: 86/255.0, alpha: 1.0)
        
    // MARK: - DSA Questions
    
    static let kQuestions0                  = "What is the manufactured year of your trailer?"
    static let kQuestions1                  = "Pedestrians/Drivers Walking in Designated Walkways ?"
    static let kQuestions2                  = "Pedestrians/Drivers Walkway Free From Obstructions ?"
    static let kQuestions3                  = "Pedestrians/Drivers in Yard Wearing High Visibility Clothing ?"
    static let kQuestions4                  = "Pedestrians/Drivers Wearing Close Toe Shoes ?"
    static let kQuestions5                  = "Speed Limits Observed ?"
    static let kQuestions6                  = "Using 3 points On Contact When Getting In/Out Of Equipment ?"
    static let kQuestions7                  = "Carriers Using Landing Gear Crank Properly ?"
    static let kQuestions8                  = "Using Gloves When Handling Landing Gear Crank, Doors, 5th Wheel ?"
    static let kQuestions9                  = "Drivers Using Designated Tandem Sliding area ?"
    static let kQuestions10                 = "Tug Test Performed Before Pulling Out Of Location ?"
    static let kQuestions11                 = "Landing Gear Functioning Properly As Design ?"
    static let kQuestions12                 = "Trailer Stands At Proper Height ?"
    static let kQuestions13                 = "Tractors Are Not Idling While Parked In Dock/Yard ?"
    static let kQuestions14                 = "Is The Yard Free From Debris ?"
    static let kQuestions15                 = "Dock Doors Closed When Not In Use ?"
    static let kQuestions16                 = "Is The Lighting In The Yard in Good Working Condition ?"
    static let kQuestions17                 = "Do you want to attach images?"
    
       
    // MARK: - Web Services
    
    //static let BaseURL                      = "http://dsalogin.com/api/"
    static let BaseURL                        = "http://dev-applications.net/driversafety/Api/"
    
    static let URL_LOGIN                    = BaseURL + "signin"
    static let URL_UPDATE_LOCATION          = BaseURL + "update_location"
    static let URL_GETLOCATION              = BaseURL + "getLocations"
    static let URL_SUBMIT_EMAIL             = BaseURL + "submit_email"
    static let URL_GET_NOTIFICATION         = BaseURL + "getNotifications"
    static let URL_SUBMIT_DSAFORM           = BaseURL + "submit_DSAfrom"
    
    

}
