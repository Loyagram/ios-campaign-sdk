//
//  CustomThankYouAndRedirectSettings.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 05/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class CustomThankYouAndRedirectSettings: Codable {
    let promoters : ThankYouAndRedirectSetting?
    let detractors : ThankYouAndRedirectSetting?
    let passives : ThankYouAndRedirectSetting?
    let neutral : ThankYouAndRedirectSetting?
    let disagree : ThankYouAndRedirectSetting?
    let agree : ThankYouAndRedirectSetting?
    let dissatisfied : ThankYouAndRedirectSetting?
    let satisfied : ThankYouAndRedirectSetting?
    
    enum CodingKeys: String, CodingKey {
        
        case promoters = "promoters"
        case detractors = "detractors"
        case passives = "passives"
        case neutral = "neutral"
        case disagree = "disagree"
        case agree = "agree"
        case dissatisfied = "dissatisfied"
        case satisfied = "satisfied"
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        promoters = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .promoters)
        detractors = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .detractors)
        passives = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .passives)
        neutral = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .neutral)
        disagree = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .disagree)
        agree = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .agree)
        dissatisfied = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .dissatisfied)
        satisfied = try values.decodeIfPresent(ThankYouAndRedirectSetting.self, forKey: .satisfied)
    }
    
}
