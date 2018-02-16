
import Foundation
class Nps_settings : Codable {
	let nps_type : String!
	let widget : Widget!
	let shape : String!
	let request_reason_settings : Request_reason_settings!

	enum CodingKeys: String, CodingKey {

		case nps_type = "nps_type"
		case widget
		case shape = "shape"
		case request_reason_settings
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		nps_type = try values.decodeIfPresent(String.self, forKey: .nps_type)
		widget = try Widget(from: decoder)
		shape = try values.decodeIfPresent(String.self, forKey: .shape)
		request_reason_settings = try Request_reason_settings(from: decoder)
	}

}
