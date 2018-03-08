
import Foundation
class  Campaign : Codable {
   let static_texts : [Static_texts]!
    let thankyou_message_enabled : Bool!
    let in_web_channel : Bool!
    let in_app_channel : Bool!
    let updated_at : String!
    let in_store_channel : Bool!
    let thank_you_and_redirect_settings : Thank_you_and_redirect_settings!
    let in_sms_channel : Bool!
    let questions : [Question]!
    let thankyou_message : String!
	let brand_title : String!
    let id : UInt!
    let in_url_channel : Bool!
    let user_id : UInt!
    let welcome_message : String!
    let note : String!
    let color_accent : String!
    let translation_status : String!
    let logo_url : String!
    let type : String!
    let welcome_message_enabled : Bool!
    let thank_you_and_redirect_settings_translations : [ThankYouTranslation]!
    let deleted : Bool!
    let biz_id : UInt!
    let in_pack_channel : Bool!
    let biz : Biz!
    let active_to : String!
    let active : Bool!
    let str_id : String!
    let color_primary : String!
    let in_mail_channel : Bool!
    let color_secondary : String!
    let welcome_message_translations : [Welcome_message_translations]!
    let name : String!
    let settings : Settings!
    let created_at : String!
    let link_id : String!
    let published : Bool!
    let active_from : String!
    let primary_lang : String!

	enum CodingKeys: String, CodingKey {

        case static_texts = "static_texts"
        case thankyou_message_enabled = "thankyou_message_enabled"
        case in_web_channel = "in_web_channel"
        case in_app_channel = "in_app_channel"
        case updated_at = "updated_at"
        case in_store_channel = "in_store_channel"
        case thank_you_and_redirect_settings
        case in_sms_channel = "in_sms_channel"
        case questions = "questions"
        case thankyou_message = "thankyou_message"
		case brand_title = "brand_title"
        case id = "id"
        case in_url_channel = "in_url_channel"
        case user_id = "user_id"
        case welcome_message = "welcome_message"
        case note = "note"
        case color_accent = "color_accent"
        case translation_status = "translation_status"
        case logo_url = "logo_url"
        case type = "type"
        case welcome_message_enabled = "welcome_message_enabled"
        case thank_you_and_redirect_settings_translations = "thank_you_and_redirect_settings_translations"
        case deleted = "deleted"
        case biz_id = "biz_id"
        case in_pack_channel = "in_pack_channel"
        case biz = "biz"
        case active_to = "active_to"
        case active = "active"
        case str_id = "str_id"
        case color_primary = "color_primary"
        case in_mail_channel = "in_mail_channel"
        case color_secondary = "color_secondary"
        case welcome_message_translations = "welcome_message_translations"
        case name = "name"
        case settings = "settings"
        case created_at = "created_at"
        case link_id = "link_id"
        case published = "published"
        case active_from = "active_from"
        case primary_lang = "primary_lang"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		static_texts = try values.decodeIfPresent([Static_texts].self, forKey: .static_texts)
        thankyou_message_enabled = try values.decodeIfPresent(Bool.self, forKey: .thankyou_message_enabled)
        in_web_channel = try values.decodeIfPresent(Bool.self, forKey: .in_web_channel)
        in_app_channel = try values.decodeIfPresent(Bool.self, forKey: .in_app_channel)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        in_store_channel = try values.decodeIfPresent(Bool.self, forKey: .in_store_channel)
        thank_you_and_redirect_settings = try Thank_you_and_redirect_settings(from: decoder)
        in_sms_channel = try values.decodeIfPresent(Bool.self, forKey: .in_sms_channel)
        questions = try values.decodeIfPresent([Question].self, forKey: .questions)
        thankyou_message = try values.decodeIfPresent(String.self, forKey: .thankyou_message)
		brand_title = try values.decodeIfPresent(String.self, forKey: .brand_title)
        id = try values.decodeIfPresent(UInt.self, forKey: .id)
        in_url_channel = try values.decodeIfPresent(Bool.self, forKey: .in_url_channel)
        user_id = try values.decodeIfPresent(UInt.self, forKey: .user_id)
        welcome_message = try values.decodeIfPresent(String.self, forKey: .welcome_message)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        color_accent = try values.decodeIfPresent(String.self, forKey: .color_accent)
        translation_status = try values.decodeIfPresent(String.self, forKey: .translation_status)
        logo_url = try values.decodeIfPresent(String.self, forKey: .logo_url)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        welcome_message_enabled = try values.decodeIfPresent(Bool.self, forKey: .welcome_message_enabled)
        thank_you_and_redirect_settings_translations = try values.decodeIfPresent([ThankYouTranslation].self, forKey: .thank_you_and_redirect_settings_translations)
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted)
        biz_id = try values.decodeIfPresent(UInt.self, forKey: .biz_id)
        in_pack_channel = try values.decodeIfPresent(Bool.self, forKey: .in_pack_channel)
        biz = try values.decodeIfPresent(Biz.self, forKey: .biz)
        active_to = try values.decodeIfPresent(String.self, forKey: .active_to)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        str_id = try values.decodeIfPresent(String.self, forKey: .str_id)
        color_primary = try values.decodeIfPresent(String.self, forKey: .color_primary)
        in_mail_channel = try values.decodeIfPresent(Bool.self, forKey: .in_mail_channel)
        color_secondary = try values.decodeIfPresent(String.self, forKey: .color_secondary)
        welcome_message_translations = try values.decodeIfPresent([Welcome_message_translations].self, forKey: .welcome_message_translations)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        //settings = try Settings(from: decoder)
        settings = try values.decodeIfPresent(Settings.self, forKey: .settings)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        link_id = try values.decodeIfPresent(String.self, forKey: .link_id)
        published = try values.decodeIfPresent(Bool.self, forKey: .published)
        active_from = try values.decodeIfPresent(String.self, forKey: .active_from)
        primary_lang = try values.decodeIfPresent(String.self, forKey: .primary_lang)
	}

}
