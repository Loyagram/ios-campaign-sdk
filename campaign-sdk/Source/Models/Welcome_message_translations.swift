

import Foundation
class Welcome_message_translations : Codable {
	let text : String?
	let language_code : String?

	enum CodingKeys: String, CodingKey {

		case text = "text"
		case language_code = "language_code"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
	}

}
