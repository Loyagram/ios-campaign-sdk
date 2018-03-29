
import Foundation
class Request_reason_settings : Codable {
	let all : All?
	let type : String?

	enum CodingKeys: String, CodingKey {

		case all = "all"
		case type = "type"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		all = try values.decodeIfPresent(All.self, forKey: .all)
		type = try values.decodeIfPresent(String.self, forKey: .type)
	}

}
