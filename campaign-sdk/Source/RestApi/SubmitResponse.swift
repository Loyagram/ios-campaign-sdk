//
//  RequestQuestion.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 06/03/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

class SubmitResponse {
    
    class func submitResponse (response : Data, success: @escaping (() -> Void), failure: @escaping (() -> Void)) {
        let urlString = ApiBase.getApiPath() + getQuestionPath()
        let url = URL(string:urlString)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 15.0
        sessionConfig.timeoutIntervalForResource = 15.0
        let session = URLSession(configuration: sessionConfig)
        if(Reachability.isConnectedToNetwork()) {
            var request = URLRequest(url:url!)
            request.httpMethod = "POST"
            request.httpBody = response
            let task = session.dataTask(with:request) { (data, response, error) in
                do {
                    if(data != nil) {
                        //print(String(data: data!, encoding: .utf8)!)
                        success()
                    } else {
                        failure()
                    }
                }
            }
            task.resume()
        } else {
            failure()
        }
        
    }
    
    class func getQuestionPath() -> String{
        return "/responses"
    }
    
}

