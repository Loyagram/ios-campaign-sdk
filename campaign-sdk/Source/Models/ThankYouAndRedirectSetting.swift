//
//  ThankYouAndRedirectSetting.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 05/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class ThankYouAndRedirectSetting : Codable {
    let message : String!
    let disabled : Bool!
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
        case disabled = "disabled"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        disabled = try values.decodeIfPresent(Bool.self, forKey: .disabled)
    }
    
}
