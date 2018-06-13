# ios-campaign-sdk
Loyagram iOS FRAMEWORK

### Getting started

```
platform :ios, '9.0'
use_frameworks!

target YOUR_PROJECT_TARGET do
  pod 'LoyagramCampaign'
end
```

Install Loyagram iOS Framework through CocoaPods.

```
pod install
```

### Usage

Firstly initialize the **Client Id** and **Client Secret**. In you Application class add the following lines of codes.
```swift
LoyagramCampaign.initialize(clientId: "----------27e1450c131", clientSecret: "-------------476c88")

```

Loyagram campaign sdk can be implemented using any of the following methods:

1. Show as a new view controller
2. Show as a dialog
3. Animate from bottom

**1. Show as a new View Controller**

To run campaigns as a new Controller.
```swift
import LoyagramCampaign

 LoyagramCampaignManager.showAsViewController(viewController: self, campaignId: campaignId,  colorPrimary: colorPrimary)
```
###### parameters:-
  - viewController:- View Controller
  - campaignId:- String campaignId
  - primaryColor:- Theme color(UIColor)

**2. Show as a dialog**

To run campaigns as a DialogFragment
```swift
import LoyagramCampaign

LoyagramCampaignManager.showAsDialog(viewController: self, campaignView: mainView, campaignId: campaignId, colorPrimary: colorPrimary)
```
###### parameters:-
  - viewController:- View Controller
  - campaignView:- UIView 
  - campaignId:- String campaignId
  - primaryColor:- Theme color(UIColor)



**3. Animate from bottom.**

In this method campaign view will be animated from bottom. The button used to invoke campaign will be hide once the campaign view appeared.
```swift

import LoyagramCampaign

LoyagramCampaignManager.showFromBottom(viewController: self, campaignView: campaignView, campaignId: campaignId, colorPrimary: colorPrimary)
```
###### Parameters:-
  - viewController:- View Controller
  - campaignId:- String campaignId
  - primaryColor:- Theme color(UIColor)

  ### Advanced Usage
  - To add callbacks for successful or unsuccessful completion of campaigns.
  ```swift
  LoyagramCampaignManager.showAsViewController(viewController: self, campaignId: campaignId, colorPrimary: colorPrimary, onSucces: {
            () -> Void in
            print("campaign success")
        }, onError:{ () -> Void in
            print("campaign error")
        })
```
- To set custom attributes.
To set custom attributes either of the following methods can be used.

- Set attributes using the addAttribute() method.
```swift
LoyagramCampaignManager.addAttribute(key:"username", value:"1234");

```

- Set attributes using the addAttributes() method.
```swift
var attributes = [String:String] ()
        attributes["username"] = "username"
        attributes["cusotmerId"] = "1234"
LoyagramCampaignManager.addAttributes(attributes: attributes)

```

### License

LoyagramCampaign is released under the [Apache 2.0 license](LICENSE).

```
Copyright 2017 DataFactors Software India Pvt. Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 ```
