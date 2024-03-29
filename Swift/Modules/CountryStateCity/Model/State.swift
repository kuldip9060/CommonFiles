//
//  State.swift
//
//  Created by Appuno Solutions on 05/06/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class State: cscCommon, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let name = "name"
    static let countryId = "country_id"
  }

  // MARK: Properties
  public var id: String?
  public var name: String?
  public var countryId: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    id = json[SerializationKeys.id].string
    name = json[SerializationKeys.name].string
    countryId = json[SerializationKeys.countryId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = countryId { dictionary[SerializationKeys.countryId] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.countryId = aDecoder.decodeObject(forKey: SerializationKeys.countryId) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(countryId, forKey: SerializationKeys.countryId)
  }

}
