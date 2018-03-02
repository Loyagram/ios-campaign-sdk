

import Foundation
class SettingsTranslations : Codable {
	let text : Text!
	let auto : Bool!
	let language_code : String!

	enum CodingKeys: String, CodingKey {

		case text = "text"
		case auto = "auto"
		case language_code = "language_code"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		//text = try Text(from: decoder)
        text = try values.decodeIfPresent(Text.self, forKey: .text)
		auto = try values.decodeIfPresent(Bool.self, forKey: .auto)
		language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
	}

}
