

import Foundation
class Thank_you_and_redirect_settings_translations : Codable {
	let text : Text!
	let language_code : String!

	enum CodingKeys: String, CodingKey {

		case text
		case language_code = "language_code"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		text = try Text(from: decoder)
		language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
	}

}
