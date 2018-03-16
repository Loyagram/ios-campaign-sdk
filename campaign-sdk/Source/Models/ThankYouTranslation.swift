//
//  ThankYouTranslation.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 05/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class ThankYouTranslation : Codable {
    let language_code : String?
    let text : Thank_you_and_redirect_settings?
    
    enum CodingKeys: String, CodingKey {
        
        case language_code = "language_code"
        case text = "text"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
        text = try values.decodeIfPresent(Thank_you_and_redirect_settings.self, forKey: .text)
    }
    
}
