//
//  Producer.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import JASON
import Moya_JASON
import ReactiveSwift

private extension JSONKeys {
    static let id = JSONKey<Int>("id")
    static let name = JSONKey<String>("name")
    static let shortDescription = JSONKey<String>("short_description")
    static let description = JSONKey<String>("description")
    static let location = JSONKey<String>("location")
    static let viaWholesaler = JSONKey<Bool>("via_wholesaler")
    static let wholesalerName = JSONKey<String>("wholesaler_name")
    static let images = JSONKey<AnyObject>("images")
}

func ==(lhs: Producer, rhs: Producer) -> Bool {
   return lhs.id == rhs.id
}

func ===(lhs: Producer, rhs: Producer) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name.value == rhs.name.value &&
        lhs.location.value == rhs.location.value &&
        lhs.viaWholesaler.value == rhs.viaWholesaler.value &&
        lhs.wholesalerName.value == rhs.wholesalerName.value
}

class Producer: NSObject, Mappable, NSCoding {
    var id: Int
    var name: MutableProperty<String>
    var shortDescription: MutableProperty<String?>
    var longDescription: MutableProperty<String?>
    var location: MutableProperty<String>
    var viaWholesaler: MutableProperty<Bool>
    var wholesalerName: MutableProperty<String>
    var images = MutableProperty<[Image]?>(nil)
    
    required init(_ json: JSON) throws {
        self.id = json[.id]
        self.name = MutableProperty(json[.name])
        self.shortDescription = MutableProperty(json[.shortDescription])
        self.longDescription = MutableProperty(json[.description])
        self.location = MutableProperty(json[.location])
        self.viaWholesaler = MutableProperty(json[.viaWholesaler])
        self.wholesalerName = MutableProperty(json[.wholesalerName])
        let jsonImages = json["images"].array
        if let jsonImages = jsonImages as? [NSDictionary] {
            var images: [Image] = []
            for jsonImage in jsonImages {
                images.append(Image(jsonImage))
            }
            self.images = MutableProperty(images)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.name = MutableProperty(aDecoder.decodeObject(forKey: "name") as! String)
        self.shortDescription = MutableProperty(aDecoder.decodeObject(forKey: "shortDescription") as? String)
        self.longDescription = MutableProperty(aDecoder.decodeObject(forKey: "longDescription") as? String)
        self.location = MutableProperty(aDecoder.decodeObject(forKey: "location") as! String)
        self.viaWholesaler = MutableProperty(aDecoder.decodeBool(forKey: "viaWholesaler"))
        self.wholesalerName = MutableProperty(aDecoder.decodeObject(forKey: "wholesalerName") as! String)
        self.images = MutableProperty(aDecoder.decodeObject(forKey: "images") as? [Image])
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name.value, forKey: "name")
        aCoder.encode(shortDescription.value, forKey: "shortDescription")
        aCoder.encode(longDescription.value, forKey: "longDescription")
        aCoder.encode(location.value, forKey: "location")
        aCoder.encode(viaWholesaler.value, forKey: "viaWholesaler")
        aCoder.encode(wholesalerName.value, forKey: "wholesalerName")
        aCoder.encode(images.value, forKey: "images")
    }
}
