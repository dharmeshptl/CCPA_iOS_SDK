//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import CCPAConsentViewController
import ConsentViewController

class ViewController: UIViewController, ConsentDelegate, GDPRConsentDelegate {
    
    let logger = Logger()

    lazy var consentViewController: CCPAConsentViewController = { return CCPAConsentViewController(
        accountId: 378,
        propertyId: 4074,
        propertyName: try! PropertyName("vice.ios.app"),
        PMId: "5e19063e6468c12231c899a8",
        campaignEnv: .Stage,
        targetingParams: ["SDK_TYPE":"CCPA"],
        consentDelegate: self
    )}()
    
    lazy var gdpr: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 378,
        propertyId: 4074,
        propertyName: try! GDPRPropertyName("vice.ios.app"),
        PMId: "5e19063e6468c12231c899a8",
        campaignEnv: .Stage,
        targetingParams: ["SDK_TYPE":"GDPR"],
        consentDelegate: self
    )}()
    
    func ccpaConsentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }
    
    func gdprConsentUIWillShow() {
        present(gdpr, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }
    
    func onConsentReady(consentUUID: ConsentUUID, userConsent: UserConsent) {
        print("-- CCPA --")
        print("consentUUID: \(consentUUID)")
        print("userConsents: \(userConsent)")
    }
    
    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        print("-- GDPR --")
        print("gdprUUID: \(gdprUUID)")
        print("userConsents: \(userConsent)")
    }

    @nonobjc func onError(error: CCPAConsentViewControllerError?) {
        logger.log("Error: %{public}@", [error?.description ?? "Something Went Wrong"])
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
        gdpr.loadMessage()
    }
}


{"mmsCookies":["_sp_v1_uid=1:131:5a42671e-5320-467a-8f2c-f82efc5f3035;","_sp_v1_csv=1;","_sp_v1_lt=1:msg|true:;","_sp_v1_ss=1:H4sIAAAAAAAAAItWqo5RKimOUbKKBjLyQAyD2lidGKVUEDOvNCcHyC4BK6iurVWKBQAW54XRMAAAAA%3D%3D;","_sp_v1_opt=1:;","_sp_v1_data=2:89576:1584794536:0:1:0:1:0:0:27753693-5f8c-4da6-b1f5-adde4488b1e8:114806;"],"messageId":"114806","dnsDisplayed":true,"status":"consentedAll"}"
