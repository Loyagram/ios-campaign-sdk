
import Foundation
class Widget : Codable {
	let very_likely : String!
	let not_likely : String!

	enum CodingKeys: String, CodingKey {

		case very_likely = "very_likely"
		case not_likely = "not_likely"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		very_likely = try values.decodeIfPresent(String.self, forKey: .very_likely)
		not_likely = try values.decodeIfPresent(String.self, forKey: .not_likely)
	}

}
