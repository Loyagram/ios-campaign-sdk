

import Foundation
class Placeholders : Codable {
	let original_text : String!
	let brand_name : String!

	enum CodingKeys: String, CodingKey {

		case original_text = "original_text"
		case brand_name = "brand_name"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		original_text = try values.decodeIfPresent(String.self, forKey: .original_text)
		brand_name = try values.decodeIfPresent(String.self, forKey: .brand_name)
	}

}
