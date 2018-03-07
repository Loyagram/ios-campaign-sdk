//
//  General.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 28/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

struct GlobalConstants {
    
    static var FONT_MEDIUM = UIFont.systemFont(ofSize: 16)
    
    static var fonts = UIFont()
    
    //static var FONT_MEDIUM1 = UIFont(name: "Proxima Nova", size: 16)
    static func initContstants() {
        
    fonts = unpackFonts()
        FONT_MEDIUM = UIFont(name:"Proxima Nova", size: 16)!
    }

    static func unpackFonts() -> UIFont {
        do {
            //let bundle = Bundle(identifier: "com.loyagram.campaign-sdk")
            let bundle1 = Bundle(for: LoyagramCampaignView.self)
            let fontPath = bundle1.path(forResource: "ProximaNova-Regular", ofType: "otf")
            //let fontsFolderURL = URL(fileURLWithPath: (bundle1.bundlePath)).appendingPathComponent("Source/Fonts")
            let defaultFontSize: CGFloat = 25.0
            var fonts = UIFont()
//            let fontsDir = try FileManager.default.contentsOfDirectory(at: fontsFolderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
//            for fontFile in fontsDir {
//                do {
            let fontBinary  = try NSData(contentsOfFile: fontPath!, options: NSData.ReadingOptions())
                    //let fontBinary = try Data(contentsOf: fontFile)
                    
                    let error: UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
                    let dataProvider = CGDataProvider(data: fontBinary as CFData)
                    let font = CGFont(dataProvider!)!
                    
                    CTFontManagerRegisterGraphicsFont(font, error)
                    
                    if let _ = error {
                        let errorDescription = CFErrorCopyDescription(error as! CFError)
                        print("Failed to load font: \(String(describing: errorDescription))")
                    } else {
                        let fontName:String = font.postScriptName! as String
                        fonts = UIFont(name: fontName, size: defaultFontSize)!
                    }
                } catch {
                   // print("Can't read data from \(fontFile.lastPathComponent) font file!")
                }
            //}
            
            return fonts
//        } catch {
//            print("Couldn't access Fonts directory")
//            return nil
//        }
    }
}


