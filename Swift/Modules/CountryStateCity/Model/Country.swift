//
//  Country.swift
//
//  Created by Appuno Solutions on 05/06/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

protocol cscCommon {
    var name : String? { get }
}
/*struct Countrys: cscCommon {
   
    let phonecode: String?
    var name: String?
    let id: String?
    let sortname: String?
}*/

public final class Country: cscCommon, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let phonecode = "phonecode"
    static let name = "name"
    static let id = "id"
    static let sortname = "sortname"
  }

  // MARK: Properties
  public var phonecode: String?
  public var name: String?
  public var id: String?
  public var sortname: String?

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
    phonecode = json[SerializationKeys.phonecode].string
    name = json[SerializationKeys.name].string
    id = json[SerializationKeys.id].string
    sortname = json[SerializationKeys.sortname].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = phonecode { dictionary[SerializationKeys.phonecode] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = sortname { dictionary[SerializationKeys.sortname] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.phonecode = aDecoder.decodeObject(forKey: SerializationKeys.phonecode) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.sortname = aDecoder.decodeObject(forKey: SerializationKeys.sortname) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(phonecode, forKey: SerializationKeys.phonecode)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(sortname, forKey: SerializationKeys.sortname)
  }

}
