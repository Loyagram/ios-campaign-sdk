

import Foundation
class Settings : Codable {
	let follow_up_request_enabled : Bool!
	let follow_up_question_enabled : Bool!
	let translation : [Language]!

	enum CodingKeys: String, CodingKey {

		case follow_up_request_enabled = "follow_up_request_enabled"
		case follow_up_question_enabled = "follow_up_question_enabled"
		case translation = "translations"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		follow_up_request_enabled = try values.decodeIfPresent(Bool.self, forKey: .follow_up_request_enabled)
		follow_up_question_enabled = try values.decodeIfPresent(Bool.self, forKey: .follow_up_question_enabled)
        translation = try values.decodeIfPresent([Language].self, forKey: .translation)
      
	}

}
