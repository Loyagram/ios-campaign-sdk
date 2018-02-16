
import Foundation
class Text : Codable {
	let all : All!
	let type : String!
	let custom : Custom!

	enum CodingKeys: String, CodingKey {

		case all
		case type = "type"
		case custom
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		all = try All(from: decoder)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		custom = try Custom(from: decoder)
	}

}
