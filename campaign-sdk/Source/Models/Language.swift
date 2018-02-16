
import Foundation
class Language : Codable {
	let language_code : String!
	let name_en : String!
	let selected : Bool!
	let name : String!
	let primary : Bool!

	enum CodingKeys: String, CodingKey {

		case language_code = "language_code"
		case name_en = "name_en"
		case selected = "selected"
		case name = "name"
		case primary = "primary"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
		name_en = try values.decodeIfPresent(String.self, forKey: .name_en)
		selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		primary = try values.decodeIfPresent(Bool.self, forKey: .primary)
	}

}
