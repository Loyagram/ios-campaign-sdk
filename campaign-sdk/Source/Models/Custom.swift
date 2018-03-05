

import Foundation
class Custom : Codable {
	let promoters : Promoters!
	let detractors : Detractors!
	let passives : Passives!

	enum CodingKeys: String, CodingKey {

		case promoters = "promoters"
		case detractors = "detractors"
		case passives = "passives"
        
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		promoters = try values.decodeIfPresent(Promoters.self, forKey: .promoters)
		detractors = try values.decodeIfPresent(Detractors.self, forKey: .detractors)
		passives = try values.decodeIfPresent(Passives.self, forKey: .passives)
	}

}
