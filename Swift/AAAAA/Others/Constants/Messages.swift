//
//  Messages.swift
//  PsychScribe
//
//  Created by MITAL SOLANKI on 8/24/16.
//  Copyright © 2016 MoveoApps. All rights reserved.
//

import UIKit

class Messages: NSObject {

    // MARK: - Messages
    
    static let kInternetNotreachable        = "The network is not reachable."
    static let kInternetUnknown             = "It is unknown whether the network is reachable."
    
    static let kPleaseEnter                 = "Please enter "
    static let kMessageEnterSCAC            = kPleaseEnter + "SCAC code."
    static let kMessageEnterAddress         = kPleaseEnter + "address."
    static let kMessageEnterClosetPoint     = kPleaseEnter + "closest ship point."
    static let kMessageEnterName            = kPleaseEnter + "name."
    static let kMessageEnterEmail           = kPleaseEnter + "email."
    static let kMessageEnterPhone           = kPleaseEnter + "phone number."
    static let kMessageEnterValidPhone      = kPleaseEnter + "valid phone number."
    static let kMessageEnterMessage         = kPleaseEnter + "message."
    static let kMessageEnterPassword        = kPleaseEnter + "password."
    static let kMessageEnterConfirmPassword = kPleaseEnter + "confirm password."
    static let kMessageEnterValidEmail      = kPleaseEnter + "valid email address."
    static let kMessageEnterOldPassword     = kPleaseEnter + "old password."
    static let kMessageEnterNewPassword     = kPleaseEnter + "new password."
    static let kMessagePasswordNotMatch     = "Password and confirm password does not match."
    static let kMessagePasswordLength       = "Password length must be minimum 6 characters."
    
    static let kMessageSuccessDSAForm       = "Successfully submit your form"
    
    static let kPatientList                 = "Currently, there are no patients"
    static let kStateList                   = "Currently, there are no states"
    static let kSearchResult                = "No Results Found"
    static let kRxList                      = "Currently, there are no rx"
    static let kNoteList                    = "Currently, there are no notes"
    static let kTreatmentList               = "Currently, there are no treatment"
    
    static let kTokenExpired                = "Token has expired"
    static let kTokenSignatureNotVerified   = "Token Signature could not be verified."
    static let kFieldEmpty                  = "Field can not be empty!"
    
    static let kLocationServiceTitle        = "Disable Location Services"
    static let kLocationServiceMessage      = "Go to setting and allowed to location access"
    static let kLocationCantGet             = "We can't get your location because "
    
    static let kLogoutWarning               = "Are you sure you want to logout?"
    
    static let kNotificationReceive         = "You have receive new notification."
}
