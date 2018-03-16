

import Foundation
class Thank_you_and_redirect_settings : Codable {
	let all : All?
	let type : String?
	let custom : CustomThankYouAndRedirectSettings!

	enum CodingKeys: String, CodingKey {

        case all = "all"
        case type = "type"
        case custom = "custom"
	}

	required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(All.self, forKey: .all)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        custom = try values.decodeIfPresent(CustomThankYouAndRedirectSettings.self, forKey: .custom)
	}

}
