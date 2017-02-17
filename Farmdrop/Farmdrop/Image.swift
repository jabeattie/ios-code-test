//
//  Image.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import ReactiveSwift

func ==(lhs: Image, rhs: Image) -> Bool {
    return lhs.path.value == rhs.path.value
}

class Image: NSObject, NSCoding {
    // Very bare - but if more elements were added to the service later will be handy.
    var path = MutableProperty<String?>(nil)
    var position = MutableProperty<Int>(0)
    
    init(_ dict: NSDictionary) {
        super.init()
        self.path = MutableProperty(dict["path"] as? String)
        self.path.value = path.value?.replacingOccurrences(of: "https://fd-v5-api-release.imgix.net/assets/producer/", with: "")
        self.position = MutableProperty(dict["position"] as? Int ?? 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.path = MutableProperty(aDecoder.decodeObject(forKey: "path") as? String)
        self.position = MutableProperty(aDecoder.decodeInteger(forKey: "position"))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(path.value, forKey: "path")
        aCoder.encode(position.value, forKey: "position")
    }
}
