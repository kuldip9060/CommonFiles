//
//  LocationData.swift
//
//  Created by Moveo Apps on 08/11/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

open class LocationData: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kLocationDataCityKey: String = "City"
	internal let kLocationDataLatitudeKey: String = "latitude"
	internal let kLocationDataRegionKey: String = "Region"
	internal let kLocationDataPlantCodeKey: String = "Plant_Code"
	internal let kLocationDataTelephoneKey: String = "Telephone"
	internal let kLocationDataDistrictKey: String = "District"
	internal let kLocationDataInternalIdentifierKey: String = "id"
	internal let kLocationDataCompanyCodeKey: String = "Company_Code"
	internal let kLocationDataLongitudeKey: String = "longitude"
	internal let kLocationDataPostalCodeKey: String = "Postal_Code"
	internal let kLocationDataTimeZoneKey: String = "Time_Zone"
	internal let kLocationDataCountryKey: String = "Country"
	internal let kLocationDataStreetKey: String = "Street"
	internal let kLocationDataFactoryKey: String = "Factory"
	internal let kLocationDataPlantTypeKey: String = "Plant_Type"
	internal let kLocationDataPlantDescriptionKey: String = "Plant_Description"


    // MARK: Properties
	public var city: String?
	public var latitude: String?
	public var region: String?
	public var plantCode: String?
	public var telephone: String?
	public var district: String?
	public var internalIdentifier: String?
	public var companyCode: String?
	public var longitude: String?
	public var postalCode: String?
	public var timeZone: String?
	public var country: String?
	public var street: String?
	public var factory: String?
	public var plantType: String?
	public var plantDescription: String?


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
		city = json[kLocationDataCityKey].string
		latitude = json[kLocationDataLatitudeKey].string
		region = json[kLocationDataRegionKey].string
		plantCode = json[kLocationDataPlantCodeKey].string
		telephone = json[kLocationDataTelephoneKey].string
		district = json[kLocationDataDistrictKey].string
		internalIdentifier = json[kLocationDataInternalIdentifierKey].string
		companyCode = json[kLocationDataCompanyCodeKey].string
		longitude = json[kLocationDataLongitudeKey].string
		postalCode = json[kLocationDataPostalCodeKey].string
		timeZone = json[kLocationDataTimeZoneKey].string
		country = json[kLocationDataCountryKey].string
		street = json[kLocationDataStreetKey].string
		factory = json[kLocationDataFactoryKey].string
		plantType = json[kLocationDataPlantTypeKey].string
		plantDescription = json[kLocationDataPlantDescriptionKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if city != nil {
			dictionary.updateValue(city! as AnyObject, forKey: kLocationDataCityKey)
		}
		if latitude != nil {
			dictionary.updateValue(latitude! as AnyObject, forKey: kLocationDataLatitudeKey)
		}
		if region != nil {
			dictionary.updateValue(region! as AnyObject, forKey: kLocationDataRegionKey)
		}
		if plantCode != nil {
			dictionary.updateValue(plantCode! as AnyObject, forKey: kLocationDataPlantCodeKey)
		}
		if telephone != nil {
			dictionary.updateValue(telephone! as AnyObject, forKey: kLocationDataTelephoneKey)
		}
		if district != nil {
			dictionary.updateValue(district! as AnyObject, forKey: kLocationDataDistrictKey)
		}
		if internalIdentifier != nil {
			dictionary.updateValue(internalIdentifier! as AnyObject, forKey: kLocationDataInternalIdentifierKey)
		}
		if companyCode != nil {
			dictionary.updateValue(companyCode! as AnyObject, forKey: kLocationDataCompanyCodeKey)
		}
		if longitude != nil {
			dictionary.updateValue(longitude! as AnyObject, forKey: kLocationDataLongitudeKey)
		}
		if postalCode != nil {
			dictionary.updateValue(postalCode! as AnyObject, forKey: kLocationDataPostalCodeKey)
		}
		if timeZone != nil {
			dictionary.updateValue(timeZone! as AnyObject, forKey: kLocationDataTimeZoneKey)
		}
		if country != nil {
			dictionary.updateValue(country! as AnyObject, forKey: kLocationDataCountryKey)
		}
		if street != nil {
			dictionary.updateValue(street! as AnyObject, forKey: kLocationDataStreetKey)
		}
		if factory != nil {
			dictionary.updateValue(factory! as AnyObject, forKey: kLocationDataFactoryKey)
		}
		if plantType != nil {
			dictionary.updateValue(plantType! as AnyObject, forKey: kLocationDataPlantTypeKey)
		}
		if plantDescription != nil {
			dictionary.updateValue(plantDescription! as AnyObject, forKey: kLocationDataPlantDescriptionKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.city = aDecoder.decodeObject(forKey: kLocationDataCityKey) as? String
		self.latitude = aDecoder.decodeObject(forKey:kLocationDataLatitudeKey) as? String
		self.region = aDecoder.decodeObject(forKey:kLocationDataRegionKey) as? String
		self.plantCode = aDecoder.decodeObject(forKey:kLocationDataPlantCodeKey) as? String
		self.telephone = aDecoder.decodeObject(forKey:kLocationDataTelephoneKey) as? String
		self.district = aDecoder.decodeObject(forKey:kLocationDataDistrictKey) as? String
		self.internalIdentifier = aDecoder.decodeObject(forKey:kLocationDataInternalIdentifierKey) as? String
		self.companyCode = aDecoder.decodeObject(forKey:kLocationDataCompanyCodeKey) as? String
		self.longitude = aDecoder.decodeObject(forKey:kLocationDataLongitudeKey) as? String
		self.postalCode = aDecoder.decodeObject(forKey:kLocationDataPostalCodeKey) as? String
		self.timeZone = aDecoder.decodeObject(forKey:kLocationDataTimeZoneKey) as? String
		self.country = aDecoder.decodeObject(forKey:kLocationDataCountryKey) as? String
		self.street = aDecoder.decodeObject(forKey:kLocationDataStreetKey) as? String
		self.factory = aDecoder.decodeObject(forKey:kLocationDataFactoryKey) as? String
		self.plantType = aDecoder.decodeObject(forKey:kLocationDataPlantTypeKey) as? String
		self.plantDescription = aDecoder.decodeObject(forKey:kLocationDataPlantDescriptionKey) as? String

    }

    open func encode(with aCoder: NSCoder) {
		aCoder.encode(city, forKey: kLocationDataCityKey)
		aCoder.encode(latitude, forKey: kLocationDataLatitudeKey)
		aCoder.encode(region, forKey: kLocationDataRegionKey)
		aCoder.encode(plantCode, forKey: kLocationDataPlantCodeKey)
		aCoder.encode(telephone, forKey: kLocationDataTelephoneKey)
		aCoder.encode(district, forKey: kLocationDataDistrictKey)
		aCoder.encode(internalIdentifier, forKey: kLocationDataInternalIdentifierKey)
		aCoder.encode(companyCode, forKey: kLocationDataCompanyCodeKey)
		aCoder.encode(longitude, forKey: kLocationDataLongitudeKey)
		aCoder.encode(postalCode, forKey: kLocationDataPostalCodeKey)
		aCoder.encode(timeZone, forKey: kLocationDataTimeZoneKey)
		aCoder.encode(country, forKey: kLocationDataCountryKey)
		aCoder.encode(street, forKey: kLocationDataStreetKey)
		aCoder.encode(factory, forKey: kLocationDataFactoryKey)
		aCoder.encode(plantType, forKey: kLocationDataPlantTypeKey)
		aCoder.encode(plantDescription, forKey: kLocationDataPlantDescriptionKey)

    }

}
