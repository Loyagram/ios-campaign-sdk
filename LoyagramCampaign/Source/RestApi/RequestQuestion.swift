//
//  RequestQuestion.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 06/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

class RequestQuestion {
    
    class func requestQuestion (campaignId : String, completion: @escaping ((_ campaign:Campaign) -> Void), failure: @escaping ((_ errorMessage:String) -> Void)) {
        if(Reachability.isConnectedToNetwork()) {
            if(getQuestionPath(campaignId: campaignId) == "") {
                failure("Client ID or Client Secret needs to be initialized")
                return
            }
            let urlString = ApiBase.getApiPath() + getQuestionPath(campaignId: campaignId)
            let url = URL(string:urlString)
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 15.0
            sessionConfig.timeoutIntervalForResource = 15.0
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:url!)
            let task = session.dataTask(with:request) { (data, response, error) in
                do {
                    if(data != nil) {
                    let jsonDecoder = JSONDecoder()
                    let campaign = try jsonDecoder.decode(Campaign.self, from: data!)
                    completion(campaign)
                    } else {
                        failure((error?.localizedDescription ?? "Something unexpected happened, please try again after sometime")!)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    failure(error.localizedDescription)
                }
            }
            task.resume()
        } else {
            failure("Not connected to Internet")
        }
        
    }
    
    class func getQuestionPath(campaignId : String) -> String{
        
        let clientId = LoyagramCampaign.getInstance().getClientId()
        let clientSecret = LoyagramCampaign.getInstance().getClientSecret()
        if(clientId == "" || clientSecret == "") {
            return ""
        }
        return "/in-store/" + campaignId + "?lang=allapiKey="+clientId+"&apiSecret="+clientSecret
    }
    
}
