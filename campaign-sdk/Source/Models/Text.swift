
import Foundation
class Text : Codable {
//    let all : All!
//    let type : String!
//    let custom : Custom!
    let settings : TranslationSettings!

	enum CodingKeys: String, CodingKey {

//        case all
//        case type = "type"
//        case custom
        case settings = "settings"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
//        all = try All(from: decoder)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        custom = try Custom(from: decoder)
        //settings = try TranslationSettings(from:decoder)
        settings = try values.decodeIfPresent(TranslationSettings.self, forKey: .settings)
	}

}
