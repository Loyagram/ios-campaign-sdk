//
//  CampaignViewController.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 12/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class CampaignViewController: UIViewController {
    
    var mainView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainView)
    
        
        //Main View Constrinats
        let mainViewTrailing  = NSLayoutConstraint(item: self.mainView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let mainViewLeading  = NSLayoutConstraint(item: self.mainView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)

        let mainViewTop  = NSLayoutConstraint(item: self.mainView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)

        let mainViewBottom  = NSLayoutConstraint(item: self.mainView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([mainViewTrailing,mainViewLeading,mainViewTop,mainViewBottom])
        self.view.layoutIfNeeded()
        let campaignView = LoyagramCampaignView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        campaignView.setViewController(vc: self)
        self.mainView.addSubview(campaignView)
        
        campaignView.translatesAutoresizingMaskIntoConstraints = false
        
        //Campaign View Constrinats
        let campaignViewTrailing  = NSLayoutConstraint(item: campaignView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let campaignViewLeading  = NSLayoutConstraint(item: campaignView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let campaignViewTop  = NSLayoutConstraint(item: campaignView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let campaignViewBottom  = NSLayoutConstraint(item: campaignView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([campaignViewTrailing,campaignViewLeading,campaignViewTop,campaignViewBottom])
        
        
        //NPS
        //let url = URL(string: "https://loyagram.com/in-store/1020-49bd1a50-1c51-445d-8043-fa8f907a0078?lang=all")
        
        //Survey
        //let url = URL(string: "https://loyagram.com/in-store/1020-80c64203-5484-4a52-b41d-5ef485cc80f1?lang=all")
        
        //CSAT
        let url = URL(string: "https://loyagram.com/in-store/1020-2d06b020-aeb6-472b-8321-556f3d4ec510?lang=all")
        
        //CES
        //let url = URL(string: "https://loyagram.com/in-store/1020-193be5eb-870d-4d27-971a-268cff4add88?lang=all")
        
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in 
            do {
                let jsonDecoder = JSONDecoder()
                let campaign = try jsonDecoder.decode(Campaign.self, from: data!)
                //print(campaign.brand_title ?? "not parsed!!!")
                DispatchQueue.main.async() {
                    campaignView.setCampaign(campaign: campaign)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }


}
