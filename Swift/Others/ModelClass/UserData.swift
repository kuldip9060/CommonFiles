//
//  UserData.swift
//
//  Created by Manish on 04/10/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

open class UserData: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kUserDataDeviceTokenKey: String = "device_token"
	internal let kUserDataSocialIdKey: String = "social_id"
	internal let kUserDataSocialTypeKey: String = "social_type"
	internal let kUserDataDeviceTypeKey: String = "device_type"
	internal let kUserDataAgeKey: String = "age"
	internal let kUserDataIsActiveKey: String = "is_active"
	internal let kUserDataEmailKey: String = "email"
	internal let kUserDataNameKey: String = "name"
	internal let kUserDataGenderKey: String = "gender"
	internal let kUserDataInternalIdentifierKey: String = "id"
	internal let kUserDataTokenKey: String = "token"
	internal let kUserDataHeightKey: String = "height"
	internal let kUserDataWeightKey: String = "weight"
	internal let kUserDataSecurityNumberKey: String = "security_number"
	internal let kUserDataGradYearKey: String = "grad_year"
    internal let kUserDataProfilePic: String = "profile_pic"

    // MARK: Properties
	open var deviceToken: String?
	open var socialId: String?
	open var socialType: String?
	open var deviceType: String?
	open var age: String?
	open var isActive: String?
	open var email: String?
	open var name: String?
	open var gender: String?
	open var internalIdentifier: Int?
	open var token: String?
	open var height: String?
	open var weight: String?
	open var securityNumber: String?
	open var gradYear: String?
    open var profilePic: String?


    // MARK: SwiftyJSON Initalizers
    /**
    Initates the class based on the object
    - parameter object: The object of either Dictionary or Array kind that was passed.
    - returns: An initalized instance of the class.
    */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }

    /**
    Initates the class based on the JSON that was passed.
    - parameter json: JSON object from SwiftyJSON.
    - returns: An initalized instance of the class.
    */
    public init(json: JSON) {
		deviceToken = json[kUserDataDeviceTokenKey].string
		socialId = json[kUserDataSocialIdKey].string
		socialType = json[kUserDataSocialTypeKey].string
		deviceType = json[kUserDataDeviceTypeKey].string
		age = json[kUserDataAgeKey].string
		isActive = json[kUserDataIsActiveKey].string
		email = json[kUserDataEmailKey].string
		name = json[kUserDataNameKey].string
		gender = json[kUserDataGenderKey].string
		internalIdentifier = json[kUserDataInternalIdentifierKey].int
		token = json[kUserDataTokenKey].string
		height = json[kUserDataHeightKey].string
		weight = json[kUserDataWeightKey].string
		securityNumber = json[kUserDataSecurityNumberKey].string
		gradYear = json[kUserDataGradYearKey].string
        profilePic = json[kUserDataProfilePic].string
    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if deviceToken != nil {
			dictionary.updateValue(deviceToken! as AnyObject, forKey: kUserDataDeviceTokenKey)
		}
		if socialId != nil {
			dictionary.updateValue(socialId! as AnyObject, forKey: kUserDataSocialIdKey)
		}
		if socialType != nil {
			dictionary.updateValue(socialType! as AnyObject, forKey: kUserDataSocialTypeKey)
		}
		if deviceType != nil {
			dictionary.updateValue(deviceType! as AnyObject, forKey: kUserDataDeviceTypeKey)
		}
		if age != nil {
			dictionary.updateValue(age! as AnyObject, forKey: kUserDataAgeKey)
		}
		if isActive != nil {
			dictionary.updateValue(isActive! as AnyObject, forKey: kUserDataIsActiveKey)
		}
		if email != nil {
			dictionary.updateValue(email! as AnyObject, forKey: kUserDataEmailKey)
		}
		if name != nil {
			dictionary.updateValue(name! as AnyObject, forKey: kUserDataNameKey)
		}
		if gender != nil {
			dictionary.updateValue(gender! as AnyObject, forKey: kUserDataGenderKey)
		}
		if internalIdentifier != nil {
			dictionary.updateValue(internalIdentifier! as AnyObject, forKey: kUserDataInternalIdentifierKey)
		}
		if token != nil {
			dictionary.updateValue(token! as AnyObject, forKey: kUserDataTokenKey)
		}
		if height != nil {
			dictionary.updateValue(height! as AnyObject, forKey: kUserDataHeightKey)
		}
		if weight != nil {
			dictionary.updateValue(weight! as AnyObject, forKey: kUserDataWeightKey)
		}
		if securityNumber != nil {
			dictionary.updateValue(securityNumber! as AnyObject, forKey: kUserDataSecurityNumberKey)
		}
		if gradYear != nil {
			dictionary.updateValue(gradYear! as AnyObject, forKey: kUserDataGradYearKey)
		}
        if profilePic != nil {
            dictionary.updateValue(profilePic! as AnyObject, forKey: kUserDataProfilePic)
        }

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.deviceToken = aDecoder.decodeObject(forKey: kUserDataDeviceTokenKey) as? String
		self.socialId = aDecoder.decodeObject(forKey: kUserDataSocialIdKey) as? String
		self.socialType = aDecoder.decodeObject(forKey: kUserDataSocialTypeKey) as? String
		self.deviceType = aDecoder.decodeObject(forKey: kUserDataDeviceTypeKey) as? String
		self.age = aDecoder.decodeObject(forKey: kUserDataAgeKey) as? String
		self.isActive = aDecoder.decodeObject(forKey: kUserDataIsActiveKey) as? String
		self.email = aDecoder.decodeObject(forKey: kUserDataEmailKey) as? String
		self.name = aDecoder.decodeObject(forKey: kUserDataNameKey) as? String
		self.gender = aDecoder.decodeObject(forKey: kUserDataGenderKey) as? String
		self.internalIdentifier = aDecoder.decodeObject(forKey: kUserDataInternalIdentifierKey) as? Int
		self.token = aDecoder.decodeObject(forKey: kUserDataTokenKey) as? String
		self.height = aDecoder.decodeObject(forKey: kUserDataHeightKey) as? String
		self.weight = aDecoder.decodeObject(forKey: kUserDataWeightKey) as? String
		self.securityNumber = aDecoder.decodeObject(forKey: kUserDataSecurityNumberKey) as? String
		self.gradYear = aDecoder.decodeObject(forKey: kUserDataGradYearKey) as? String
        self.profilePic = aDecoder.decodeObject(forKey: kUserDataProfilePic) as? String
    }

    open func encode(with aCoder: NSCoder) {
		aCoder.encode(deviceToken, forKey: kUserDataDeviceTokenKey)
		aCoder.encode(socialId, forKey: kUserDataSocialIdKey)
		aCoder.encode(socialType, forKey: kUserDataSocialTypeKey)
		aCoder.encode(deviceType, forKey: kUserDataDeviceTypeKey)
		aCoder.encode(age, forKey: kUserDataAgeKey)
		aCoder.encode(isActive, forKey: kUserDataIsActiveKey)
		aCoder.encode(email, forKey: kUserDataEmailKey)
		aCoder.encode(name, forKey: kUserDataNameKey)
		aCoder.encode(gender, forKey: kUserDataGenderKey)
		aCoder.encode(internalIdentifier, forKey: kUserDataInternalIdentifierKey)
		aCoder.encode(token, forKey: kUserDataTokenKey)
		aCoder.encode(height, forKey: kUserDataHeightKey)
		aCoder.encode(weight, forKey: kUserDataWeightKey)
		aCoder.encode(securityNumber, forKey: kUserDataSecurityNumberKey)
		aCoder.encode(gradYear, forKey: kUserDataGradYearKey)
        aCoder.encode(profilePic, forKey: kUserDataProfilePic)
    }

}
