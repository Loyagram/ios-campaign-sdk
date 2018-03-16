

import Foundation
class Static_texts : Codable {
	let text : String?
	let static_text_id : String?
	let language_code : String?

	enum CodingKeys: String, CodingKey {

		case text = "text"
		case static_text_id = "static_text_id"
		case language_code = "language_code"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		static_text_id = try values.decodeIfPresent(String.self, forKey: .static_text_id)
		language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
	}

}
