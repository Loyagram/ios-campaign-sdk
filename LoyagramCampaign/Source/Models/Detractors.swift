

import Foundation
class Detractors : Codable {
	let disabled : Bool?
	let auto : Bool?
	let message : String?
	let links : [String]?

	enum CodingKeys: String, CodingKey {

		case disabled = "disabled"
		case auto = "auto"
		case message = "message"
		case links = "links"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		disabled = try values.decodeIfPresent(Bool.self, forKey: .disabled)
		auto = try values.decodeIfPresent(Bool.self, forKey: .auto)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		links = try values.decodeIfPresent([String].self, forKey: .links)
	}

}
