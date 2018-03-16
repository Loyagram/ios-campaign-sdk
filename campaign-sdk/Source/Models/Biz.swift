

import Foundation
class Biz : Codable {
	let color_accent : String?
	let in_url_channel : Bool?
	let color_primary : String?
	let name : String?
	let color_secondary : String?
	let in_web_channel : Bool?
	let in_app_channel : Bool?
	let number : String?
	let id : UInt?
	let in_pack_channel : Bool?
	let user_updated : Bool?
	let in_sms_channel : Bool?
	let in_store_channel : Bool?
	let img_url : String?
	let email : String?
	let in_mail_channel : Bool?

	enum CodingKeys: String, CodingKey {

		case color_accent = "color_accent"
		case in_url_channel = "in_url_channel"
		case color_primary = "color_primary"
		case name = "name"
		case color_secondary = "color_secondary"
		case in_web_channel = "in_web_channel"
		case in_app_channel = "in_app_channel"
		case number = "number"
		case id = "id"
		case in_pack_channel = "in_pack_channel"
		case user_updated = "user_updated"
		case in_sms_channel = "in_sms_channel"
		case in_store_channel = "in_store_channel"
		case img_url = "img_url"
		case email = "email"
		case in_mail_channel = "in_mail_channel"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		color_accent = try values.decodeIfPresent(String.self, forKey: .color_accent)
		in_url_channel = try values.decodeIfPresent(Bool.self, forKey: .in_url_channel)
		color_primary = try values.decodeIfPresent(String.self, forKey: .color_primary)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		color_secondary = try values.decodeIfPresent(String.self, forKey: .color_secondary)
		in_web_channel = try values.decodeIfPresent(Bool.self, forKey: .in_web_channel)
		in_app_channel = try values.decodeIfPresent(Bool.self, forKey: .in_app_channel)
		number = try values.decodeIfPresent(String.self, forKey: .number)
		id = try values.decodeIfPresent(UInt.self, forKey: .id)
		in_pack_channel = try values.decodeIfPresent(Bool.self, forKey: .in_pack_channel)
		user_updated = try values.decodeIfPresent(Bool.self, forKey: .user_updated)
		in_sms_channel = try values.decodeIfPresent(Bool.self, forKey: .in_sms_channel)
		in_store_channel = try values.decodeIfPresent(Bool.self, forKey: .in_store_channel)
		img_url = try values.decodeIfPresent(String.self, forKey: .img_url)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		in_mail_channel = try values.decodeIfPresent(Bool.self, forKey: .in_mail_channel)
	}

}
