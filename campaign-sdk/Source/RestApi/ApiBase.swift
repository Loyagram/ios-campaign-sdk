//
//  ApiBase.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 06/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class ApiBase {

    static let HOST:String  = "https://cx.loyagram.com"
    static let AUTHENTICATED_PATH:String  = "/api/v0.0.1beta"
    
    class func getApiPath() -> String {
        return HOST + AUTHENTICATED_PATH
    }
}
