

import Foundation
class Question : Codable {
	let order_no : UInt!
    let settings : Settings!
    let optional : Bool!
    let labels : [Labels]!
    let question : String!
    let campaign_id : UInt!
    let question_translations : [QuestionTranslations]!
    let others_entry : Bool!
    let settings_translations : [SettingsTranslations]!
    let placeholders : Placeholders!
    let parent_question_id : String!
    let type : String!
    let id : UInt!
    let img_url : String!

	enum CodingKeys: String, CodingKey {

		case order_no = "order_no"
        case settings
        case optional = "optional"
        case labels = "labels"
        case question = "question"
        case campaign_id = "campaign_id"
        case question_translations = "question_translations"
        case others_entry = "others_entry"
        case settings_translations = "settings_translations"
        case placeholders
        case parent_question_id = "parent_question_id"
        case type = "type"
        case id = "id"
        case img_url = "img_url"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		order_no = try values.decodeIfPresent(UInt.self, forKey: .order_no)
        settings = try Settings(from: decoder)
        optional = try values.decodeIfPresent(Bool.self, forKey: .optional)
        labels = try values.decodeIfPresent([Labels].self, forKey: .labels)
        question = try values.decodeIfPresent(String.self, forKey: .question)
        campaign_id = try values.decodeIfPresent(UInt.self, forKey: .campaign_id)
        question_translations = try values.decodeIfPresent([QuestionTranslations].self, forKey: .question_translations)
        others_entry = try values.decodeIfPresent(Bool.self, forKey: .others_entry)
        settings_translations = try values.decodeIfPresent([SettingsTranslations].self, forKey: .settings_translations)
        placeholders = try Placeholders(from: decoder)
        parent_question_id = try values.decodeIfPresent(String.self, forKey: .parent_question_id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        id = try values.decodeIfPresent(UInt.self, forKey: .id)
        img_url = try values.decodeIfPresent(String.self, forKey: .img_url)
	}

}
