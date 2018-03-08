import Foundation
class Response : Codable {
    var id : String!
    init() {
        //self.id = id
    }
    var biz_id : UInt!
    var location_id : String!
    var user_id: UInt!
    var campaign_id : UInt!
    var customer_number : String!
    var customer_email : String!
    var customer_name : String!
    var customer_address : String!
    var started_at : CUnsignedLong!
    var ended_at : CUnsignedLong!
    var response_answers : [ResponseAnswer]!
    var device_id : String!
    var channel : String!
    var sub_channel : String!
    var language_code : String!
    var attr : [String : String]!
    var email : String!
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case biz_id = "biz_id"
//        case location_id = "location_id"
//        case user_id = "user_id"
//        case campaign_id = "campaign_id"
//        case customer_number = "customer_number"
//        case customer_email = "customer_email"
//        case customer_name = "customer_name"
//        case customer_address = "customer_address"
//        case started_at = "started_at"
//        case ended_at = "ended_at"
//        case response_answers = "response_answers"
//        case device_id = "device_id"
//        case channel = "channel"
//        case sub_channel = "sub_channel"
//        case language_code = "language_code"
//        case attr = "attr"
//        case email = "email"
//
//    }
//
//    required init(from decoder: Decoder) throws {
//        var values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        biz_id = try values.decodeIfPresent(UInt.self, forKey: .biz_id)
//        location_id = try values.decodeIfPresent(String.self, forKey: .location_id)
//        user_id = try values.decodeIfPresent(UInt.self, forKey: .user_id)
//        campaign_id = try values.decodeIfPresent(UInt.self, forKey: .campaign_id)
//        customer_number = try values.decodeIfPresent(String.self, forKey: .customer_number)
//        customer_email = try values.decodeIfPresent(String.self, forKey: .customer_email)
//        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
//        customer_address = try values.decodeIfPresent(String.self, forKey: .customer_address)
//        started_at = try values.decodeIfPresent(CUnsignedLong.self, forKey: .started_at)
//        ended_at = try values.decodeIfPresent(CUnsignedLong.self, forKey: .ended_at)
//        response_answers = try values.decodeIfPresent(ResponseAnswer.self, forKey: .response_answers)
//        device_id = try values.decodeIfPresent(String.self, forKey: .device_id)
//        channel = try values.decodeIfPresent(String.self, forKey: .channel)
//        sub_channel = try values.decodeIfPresent(String.self, forKey: .sub_channel)
//        language_code = try values.decodeIfPresent(String.self, forKey: .language_code)
//        attr = try values.decodeIfPresent([String:String].self, forKey: .attr)
//        email = try values.decodeIfPresent(String.self, forKey: .email)
//    }
    
}
