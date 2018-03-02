//
//  TranslationSettings.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 01/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class TranslationSettings : Codable {
    
    let nps_settings : Nps_settings!
    let csat_settings : Csat_settings!
    let ces_settings : Ces_settings!
    
    enum CodingKeys: String, CodingKey {
        
        case nps_settings = "nps_settings"
        case csat_settings = "csat_settings"
        case ces_settings = "ces_settings"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nps_settings = try values.decodeIfPresent(Nps_settings.self, forKey: .nps_settings)
        csat_settings = try values.decodeIfPresent(Csat_settings.self, forKey: .csat_settings)
        ces_settings = try values.decodeIfPresent(Ces_settings.self, forKey: .ces_settings)
    }
}
