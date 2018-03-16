import Foundation
class Ces_settings : Codable {
    let request_reason_settings : Request_reason_settings?
    
    enum CodingKeys: String, CodingKey {
        
        case request_reason_settings = "request_reason_settings"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        request_reason_settings = try values.decodeIfPresent(Request_reason_settings.self, forKey: .request_reason_settings)
    }
    
}
