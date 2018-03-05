
import Foundation
class Text : Codable {
    let all : All!
    let type : String!
    let custom : Custom!
    let settings : TranslationSettings!

	enum CodingKeys: String, CodingKey {

        case all = "all"
        case type = "type"
        case custom = "custom"
        case settings = "settings"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(All.self, forKey: .all)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        custom = try values.decodeIfPresent(Custom.self, forKey: .custom)
        settings = try values.decodeIfPresent(TranslationSettings.self, forKey: .settings)
	}

}
