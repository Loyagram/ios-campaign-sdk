//
//  ResponseAnswers.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 08/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

class ResponseAnswer : Codable {
    
    var id : String!
    var biz_id : UInt!
    var biz_loc_id : String!
    var biz_user_id : CUnsignedLong!
    var campaign_id : CUnsignedLong!
    var response_id : String!
    var question_id : CUnsignedLong!
    var question_label_id : CUnsignedLong!
    var at : CUnsignedLong!
    var answer : UInt!
    var response_answer_text : ResponseAnswerText!
  
    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case biz_id = "biz_id"
//        case biz_loc_id = "biz_loc_id"
//        case biz_user_id = "biz_user_id"
//        case campaign_id = "campaign_id"
//        case response_id = "response_id"
//        case question_id = "question_id"
//        case question_label_id = "question_label_id"
//        case at = "at"
//        case answer = "answer"
//        case response_answer_text = "response_answer_text"
//    }
//
//    required init(from decoder: Decoder) throws {
//        var values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        biz_id = try values.decodeIfPresent(UInt.self, forKey: .biz_id)
//        biz_loc_id = try values.decodeIfPresent(UInt.self, forKey: .biz_loc_id)
//        biz_user_id = try values.decodeIfPresent(UInt.self, forKey: .biz_user_id)
//        campaign_id = try values.decodeIfPresent(UInt.self, forKey: .campaign_id)
//        response_id = try values.decodeIfPresent(String.self, forKey: .response_id)
//        question_id = try values.decodeIfPresent(UInt.self, forKey: .question_id)
//        question_label_id = try values.decodeIfPresent(UInt.self, forKey: .question_label_id)
//        at = try values.decodeIfPresent(CUnsignedLong.self, forKey: .at)
//        answer = try values.decodeIfPresent(UInt.self, forKey: .answer)
//        response_answer_text = try values.decodeIfPresent(ResponseAnswerText.self, forKey: .response_answer_text)
//    }
    
}
