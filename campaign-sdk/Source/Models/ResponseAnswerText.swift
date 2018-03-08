//
//  ResponseAnswerText.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 08/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class ResponseAnswerText : Codable {
    var id : UInt!
    var response_answer_id : String!
    var text : String!
    
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case response_answer_id = "response_answer_id"
//        case text = "text"
//    }
//
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(UInt.self, forKey: .id)
//        response_answer_id = try values.decodeIfPresent(String.self, forKey: .response_answer_id)
//        text = try values.decodeIfPresent(String.self, forKey: .text)
//    }
    
}
