////
////  Campaign.swift
////  campaign-sdk
////
////  Created by iOS-Apps on 13/02/18.
////  Copyright © 2018 loyagram. All rights reserved.
////
//
//import Foundation
//class Campaign: Hashable, Equatable, Codable {
//    let staticTexts: [StaticText]
//    let thankyouMessageEnabled: Bool
//    let inWebChannel: Bool
//    let inAppChannel: Bool
//    let updatedAt: String
//    let inStoreChannel: Bool
//    let thankYouAndRedirectSettings: ThankYouAndRedirectSettings
//    let inSMSChannel: Bool
//    let questions: [Question]
//    let thankyouMessage: String
//    let brandTitle: String
//    let id: Int
//    let inURLChannel: Bool
//    let userID: Int
//    let welcomeMessage: String
//    let note: String
//    let colorAccent: JSONNull?
//    let translationStatus: String
//    let logoURL: String
//    let type: String
//    let welcomeMessageEnabled: Bool
//    let thankYouAndRedirectSettingsTranslations: [ThankYouAndRedirectSettingsTranslation]
//    let deleted: Bool
//    let bizID: Int
//    let inPackChannel: Bool
//    let biz: Biz
//    let activeTo: JSONNull?
//    let active: Bool
//    let strID: String
//    let colorPrimary: String
//    let inMailChannel: Bool
//    let colorSecondary: JSONNull?
//    let welcomeMessageTranslations: [Translation]
//    let name: String
//    let settings: CampaignSettings
//    let createdAt: String
//    let inWebSettings: InWebSettings
//    let published: Bool
//    let activeFrom: JSONNull?
//    let primaryLang: String
//    
//    enum CodingKeys: String, CodingKey {
//        case staticTexts = "static_texts"
//        case thankyouMessageEnabled = "thankyou_message_enabled"
//        case inWebChannel = "in_web_channel"
//        case inAppChannel = "in_app_channel"
//        case updatedAt = "updated_at"
//        case inStoreChannel = "in_store_channel"
//        case thankYouAndRedirectSettings = "thank_you_and_redirect_settings"
//        case inSMSChannel = "in_sms_channel"
//        case questions = "questions"
//        case thankyouMessage = "thankyou_message"
//        case brandTitle = "brand_title"
//        case id = "id"
//        case inURLChannel = "in_url_channel"
//        case userID = "user_id"
//        case welcomeMessage = "welcome_message"
//        case note = "note"
//        case colorAccent = "color_accent"
//        case translationStatus = "translation_status"
//        case logoURL = "logo_url"
//        case type = "type"
//        case welcomeMessageEnabled = "welcome_message_enabled"
//        case thankYouAndRedirectSettingsTranslations = "thank_you_and_redirect_settings_translations"
//        case deleted = "deleted"
//        case bizID = "biz_id"
//        case inPackChannel = "in_pack_channel"
//        case biz = "biz"
//        case activeTo = "active_to"
//        case active = "active"
//        case strID = "str_id"
//        case colorPrimary = "color_primary"
//        case inMailChannel = "in_mail_channel"
//        case colorSecondary = "color_secondary"
//        case welcomeMessageTranslations = "welcome_message_translations"
//        case name = "name"
//        case settings = "settings"
//        case createdAt = "created_at"
//        case inWebSettings = "in_web_settings"
//        case published = "published"
//        case activeFrom = "active_from"
//        case primaryLang = "primary_lang"
//    }
//    
//    init(staticTexts: [StaticText], thankyouMessageEnabled: Bool, inWebChannel: Bool, inAppChannel: Bool, updatedAt: String, inStoreChannel: Bool, thankYouAndRedirectSettings: ThankYouAndRedirectSettings, inSMSChannel: Bool, questions: [Question], thankyouMessage: String, brandTitle: String, id: Int, inURLChannel: Bool, userID: Int, welcomeMessage: String, note: String, colorAccent: JSONNull?, translationStatus: String, logoURL: String, type: String, welcomeMessageEnabled: Bool, thankYouAndRedirectSettingsTranslations: [ThankYouAndRedirectSettingsTranslation], deleted: Bool, bizID: Int, inPackChannel: Bool, biz: Biz, activeTo: JSONNull?, active: Bool, strID: String, colorPrimary: String, inMailChannel: Bool, colorSecondary: JSONNull?, welcomeMessageTranslations: [Translation], name: String, settings: CampaignSettings, createdAt: String, inWebSettings: InWebSettings, published: Bool, activeFrom: JSONNull?, primaryLang: String) {
//        self.staticTexts = staticTexts
//        self.thankyouMessageEnabled = thankyouMessageEnabled
//        self.inWebChannel = inWebChannel
//        self.inAppChannel = inAppChannel
//        self.updatedAt = updatedAt
//        self.inStoreChannel = inStoreChannel
//        self.thankYouAndRedirectSettings = thankYouAndRedirectSettings
//        self.inSMSChannel = inSMSChannel
//        self.questions = questions
//        self.thankyouMessage = thankyouMessage
//        self.brandTitle = brandTitle
//        self.id = id
//        self.inURLChannel = inURLChannel
//        self.userID = userID
//        self.welcomeMessage = welcomeMessage
//        self.note = note
//        self.colorAccent = colorAccent
//        self.translationStatus = translationStatus
//        self.logoURL = logoURL
//        self.type = type
//        self.welcomeMessageEnabled = welcomeMessageEnabled
//        self.thankYouAndRedirectSettingsTranslations = thankYouAndRedirectSettingsTranslations
//        self.deleted = deleted
//        self.bizID = bizID
//        self.inPackChannel = inPackChannel
//        self.biz = biz
//        self.activeTo = activeTo
//        self.active = active
//        self.strID = strID
//        self.colorPrimary = colorPrimary
//        self.inMailChannel = inMailChannel
//        self.colorSecondary = colorSecondary
//        self.welcomeMessageTranslations = welcomeMessageTranslations
//        self.name = name
//        self.settings = settings
//        self.createdAt = createdAt
//        self.inWebSettings = inWebSettings
//        self.published = published
//        self.activeFrom = activeFrom
//        self.primaryLang = primaryLang
//    }
//}

