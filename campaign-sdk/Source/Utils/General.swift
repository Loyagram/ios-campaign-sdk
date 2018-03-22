//
//  General.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 28/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

struct GlobalConstants {
    
    static var FONT_MEDIUM = UIFont.systemFont(ofSize: 17)
    static var FONT_SMALL = UIFont.systemFont(ofSize: 12)
    static var FONT_XSMALL = UIFont.systemFont(ofSize: 10)
    static func initContstants() {
        unpackFonts()
        FONT_MEDIUM = UIFont(name:"Proxima Nova", size: 17)!
        FONT_SMALL = UIFont(name:"Proxima Nova", size: 12)!
        FONT_XSMALL = UIFont(name:"Proxima Nova", size: 10)!
    }
    
    static func unpackFonts() {
        do {
            let bundle = Bundle(for: LoyagramCampaignView.self)
            let fontPath = bundle.path(forResource: "ProximaNova-Regular", ofType: "otf")
            let fontBinary  = try NSData(contentsOfFile: fontPath!, options: NSData.ReadingOptions())
            let error: UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
            let dataProvider = CGDataProvider(data: fontBinary as CFData)
            let font = CGFont(dataProvider!)!
            CTFontManagerRegisterGraphicsFont(font, error)
            if let _ = error {
                let errorDescription = CFErrorCopyDescription(error as! CFError)
                print("Failed to load font: \(String(describing: errorDescription))")
            }
        } catch {
        }
    }
}


