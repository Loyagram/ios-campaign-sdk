//
//  RequestQuestion.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 06/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

class RequestQuestion {
    
    class func requestQuestion (campaignId : String, completion: @escaping ((_ campaign:Campaign) -> Void), failure: @escaping (() -> Void)) {
        
        let urlString = ApiBase.getApiPath() + getQuestionPath(campaignId: campaignId)
        let url = URL(string:urlString)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 15.0
        sessionConfig.timeoutIntervalForResource = 15.0
        let session = URLSession(configuration: sessionConfig)
        if(Reachability.isConnectedToNetwork()) {
            let date = Date()
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            print("---------- time before request \(minutes) : \(seconds)")
            let request = URLRequest(url:url!)
            let task = session.dataTask(with:request) { (data, response, error) in
                do {
                    let date = Date()
                    let calendar = Calendar.current
                    let minutes = calendar.component(.minute, from: date)
                    let seconds = calendar.component(.second, from: date)
                    print("---------- after response \(minutes) : \(seconds)")
                    if(data != nil) {
                    let jsonDecoder = JSONDecoder()
                    let campaign = try jsonDecoder.decode(Campaign.self, from: data!)
                    //print(campaign.brand_title ?? "not parsed!!!")
                    completion(campaign)
                    } else {
                        failure()
                    }
                } catch let error {
                    print(error.localizedDescription)
                    failure()
                }
            }
            task.resume()
        } else {
            failure()
        }
        
    }
    
    class func getQuestionPath(campaignId : String) -> String{
        
        return "/in-store/" + campaignId + "?lang=all"
    }
    
}
