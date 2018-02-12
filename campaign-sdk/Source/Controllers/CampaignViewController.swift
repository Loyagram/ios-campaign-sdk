//
//  CampaignViewController.swift
//  campaign-sdk
//
//  Created by iOS-Apps on 12/02/18.
//  Copyright © 2018 loyagram. All rights reserved.
//

import UIKit

class CampaignViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let campaignView = LoyagramCampaignView(frame:rect)
        campaignView.setViewController(vc: self)
        self.view.addSubview(campaignView)
        
        //campaignView.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
