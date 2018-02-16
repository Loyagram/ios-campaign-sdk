

import Foundation
class Labels : Codable {
	let field_type : String!
	let name : String!
	let order_no : Int!
	let settings : Settings!
	let deleted : Bool!
	let max_value : Int!
	let min_value : Int!
	let enabled : Bool!
	let value : String!
	let label : String!
	let label_translations : [LabelTranslations]!
	let step_value : Int!
	let img_url : String!
	let id : Int!
	let question_id : Int!

	enum CodingKeys: String, CodingKey {

		case field_type = "field_type"
		case name = "name"
		case order_no = "order_no"
		case settings
		case deleted = "deleted"
		case max_value = "max_value"
		case min_value = "min_value"
		case enabled = "enabled"
		case value = "value"
		case label = "label"
		case label_translations = "label_translations"
		case step_value = "step_value"
		case img_url = "img_url"
		case id = "id"
		case question_id = "question_id"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		field_type = try values.decodeIfPresent(String.self, forKey: .field_type)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		order_no = try values.decodeIfPresent(Int.self, forKey: .order_no)
		settings = try Settings(from: decoder)
		deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted)
		max_value = try values.decodeIfPresent(Int.self, forKey: .max_value)
		min_value = try values.decodeIfPresent(Int.self, forKey: .min_value)
		enabled = try values.decodeIfPresent(Bool.self, forKey: .enabled)
		value = try values.decodeIfPresent(String.self, forKey: .value)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		label_translations = try values.decodeIfPresent([LabelTranslations].self, forKey: .label_translations)
		step_value = try values.decodeIfPresent(Int.self, forKey: .step_value)
		img_url = try values.decodeIfPresent(String.self, forKey: .img_url)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
	}

}
