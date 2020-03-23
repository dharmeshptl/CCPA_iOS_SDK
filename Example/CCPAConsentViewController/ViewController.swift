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

    lazy var ccpa: CCPAConsentViewController = { return CCPAConsentViewController(
        accountId: 22,
        propertyId: 7480,
        propertyName: try! PropertyName("twosdks.demo"),
        PMId: "5e6a7f997653402334162542",
        campaignEnv: .Public,
        targetingParams: ["SDK_TYPE":"CCPA"],
        consentDelegate: self
    )}()
    
    lazy var gdpr: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 7480,
        propertyName: try! GDPRPropertyName("twosdks.demo"),
        PMId: "5e6a80616146a00ea27a9153",
        campaignEnv: .Public,
        targetingParams: ["SDK_TYPE":"GDPR"],
        consentDelegate: self
    )}()
    
    func ccpaConsentUIWillShow() {
        present(ccpa, animated: true, completion: nil)
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
        gdpr.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ccpa.loadMessage()
        gdpr.loadMessage()
    }
}
