

import Foundation
class Custom : Codable {
	let promoters : Promoters!
	let detractors : Detractors!
	let passives : Passives!

	enum CodingKeys: String, CodingKey {

		case promoters
		case detractors
		case passives
	}

	required init(from decoder: Decoder) throws {
		//let values = try decoder.container(keyedBy: CodingKeys.self)
		promoters = try Promoters(from: decoder)
		detractors = try Detractors(from: decoder)
		passives = try Passives(from: decoder)
	}

}
