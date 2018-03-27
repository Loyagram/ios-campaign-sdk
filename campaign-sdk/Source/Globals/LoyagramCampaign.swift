//
//  LoyagramCampaign.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 27/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import Foundation

public class LoyagramCampaign {
    
    static var instance:LoyagramCampaign!
    var clientId = String()
    var clientSecret = String()
    var domainType = String()
    
    public class func initialize(clientId:String, clientSecret:String) {
        instance = LoyagramCampaign()
        instance.clientId = clientId
        instance.clientSecret = clientSecret
    }
    class func getInstance() -> LoyagramCampaign {
        if(instance == nil) {
            instance = LoyagramCampaign()
        }
        return instance
    }
    
    func setApiKey(clientId:String) {
        self.clientId = clientId
    }
    
    func setClientSecret(clientSecret:String) {
        self.clientSecret = clientSecret
    }
    
    func setDomainType(domainType:String) {
        self.domainType = domainType
    }
    
    func getClientId() -> String {
        return self.clientId
    }
    
    func getClientSecret() -> String {
        return self.clientSecret
    }
    
    func getDomainType() -> String {
        return self.domainType
    }
    
}
