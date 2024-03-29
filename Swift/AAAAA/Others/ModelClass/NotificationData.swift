//
//  NotificationData.swift
//
//  Created by Moveo Apps on 09/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class NotificationData: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kNotificationDataNotificationTextKey: String = "notification_text"
	internal let kNotificationDataCreatedDateKey: String = "created_date"
	internal let kNotificationDataScacCodeKey: String = "scac_code"


    // MARK: Properties
	public var notificationText: String?
	public var createdDate: String?
	public var scacCode: String?


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
		notificationText = json[kNotificationDataNotificationTextKey].string
		createdDate = json[kNotificationDataCreatedDateKey].string
		scacCode = json[kNotificationDataScacCodeKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if notificationText != nil {
			dictionary.updateValue(notificationText! as AnyObject, forKey: kNotificationDataNotificationTextKey)
		}
		if createdDate != nil {
			dictionary.updateValue(createdDate! as AnyObject, forKey: kNotificationDataCreatedDateKey)
		}
		if scacCode != nil {
			dictionary.updateValue(scacCode! as AnyObject, forKey: kNotificationDataScacCodeKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.notificationText = aDecoder.decodeObject(forKey: kNotificationDataNotificationTextKey) as? String
		self.createdDate = aDecoder.decodeObject(forKey: kNotificationDataCreatedDateKey) as? String
		self.scacCode = aDecoder.decodeObject(forKey: kNotificationDataScacCodeKey) as? String

    }

    open func encode(with aCoder: NSCoder) {
		aCoder.encode(notificationText, forKey: kNotificationDataNotificationTextKey)
		aCoder.encode(createdDate, forKey: kNotificationDataCreatedDateKey)
		aCoder.encode(scacCode, forKey: kNotificationDataScacCodeKey)

    }

}
