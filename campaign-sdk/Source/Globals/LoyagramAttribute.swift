//
//  LoyagramAttribute.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 16/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class LoyagramAttribute {
    
    static var instance = LoyagramAttribute()
    var attributes = [String:String]()
    
    class func getInstance() -> LoyagramAttribute {
        return instance
    }
    
     func setAttributes(attributes:[String: String]) {
        self.attributes = attributes
    }
    
     func setAttribute(key:String, value:String) {
        self.attributes[key] = value
    }
}
