

import Foundation
class LabelTranslations : Codable {
	let text : String!
	let auto : Bool!
	let language_code : String!

	enum CodingKeys: String, CodingKey {

		case text = "text"
		case auto = "auto"
		case language_code = "language_code"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		auto = try values.decodeIfPresent(Bool.self, forKey: .auto)
		language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
	}

}
