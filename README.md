
# iOS Setup guide

## How to install

### CocoaPods
We strongly recommend the use of [CocoaPods](https://cocoapods.org) in order to install our SDK.
In your `Podfile` add the following line to your app target:

```
pod 'CCPAConsentViewController', '1.1.3'
```
### Carthage
We also support [Carthage](https://github.com/Carthage/Carthage). It requires a couple more steps to install so we dedicated a whole [wiki page](https://github.com/SourcePointUSA/CCPA_iOS_SDK/wiki/Carthage-SDK-integration-guide) for it.
Let us know if we missed any step.

### Manual
We also support Manual integration of SDK. It requires a couple more steps to install so we dedicated a whole [wiki page](https://github.com/SourcePointUSA/CCPA_iOS_SDK/wiki/Manual-SDK-integration-guide) for it.
Let us know if we missed any step.

## How to use it

It's pretty simple, here are 5 easy steps for you:

1. implement the `ConsentDelegate` protocol
2. instantiate the `CCPAConsentViewController` with your Account ID, property id, property name, privacy manager id, campaign environment and the consent delegate
3. call `.loadMessage()` when your app starts or `.loadPrivacyManager()` when you wish to show the PrivacyManager.
4. present the controller when the message/PM is ready to be displayed
5. profit!

### Swift
```swift
import UIKit
import CCPAConsentViewController

class ViewController: UIViewController, ConsentDelegate {
    lazy var consentViewController: CCPAConsentViewController = { return CCPAConsentViewController(
      accountId: 22,
      propertyId: 6099, 
      propertyName: try! PropertyName("ccpa.mobile.demo"), 
      PMId: "5df9105bcf42027ce707bb43", 
      campaignEnv: .Public, 
      consentDelegate: self
    )}()

    func ccpaConsentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }

    func onConsentReady(consentUUID: ConsentUUID, userConsent: UserConsent) {
        print("consentUUID: \(consentUUID)")
        print("userConsents: \(userConsent)")
    }

    func onError(error: CCPAConsentViewControllerError?) {
        print("Error: \(error?.description ?? "Something Went Wrong")")
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
    }
}
```

### Objective-C
```obj-c
#import "ViewController.h"
@import CCPAConsentViewController;

@interface ViewController ()<ConsentDelegate>

@end

@implementation ViewController

CCPAConsentViewController *cvc;

- (void)viewDidLoad {
    [super viewDidLoad];

    PropertyName *propertyName = [[PropertyName alloc] init:@"ccpa.mobile.demo" error: nil];
    
    cvc = [[CCPAConsentViewController alloc]
        initWithAccountId:22
        propertyId:6099
        propertyName:propertyName
        PMId:@"5df9105bcf42027ce707bb43"
        campaignEnv:CampaignEnvPublic
        consentDelegate:self];

    [cvc loadMessage];
}

- (IBAction)onPrivacySettingsTap:(UIButton *)sender {
    [cvc loadPrivacyManager];
}

- (void)onConsentReadyWithConsentUUID:(NSString *)consentUUID userConsent:(UserConsent *)userConsent {
    NSLog(@"uuid: %@", consentUUID);
    NSLog(@"userConsent: %@", userConsent);
}

- (void)onErrorWithError:(CCPAConsentViewControllerError *)error {
    NSLog(@"Error: %@", error);
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)consentUIDidDisappear {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ccpaConsentUIWillShow {
    [self presentViewController:cvc animated:YES completion:NULL];
}

@end
```

### Authenticated Consent

#### How does it work?
You need to give us a `authId`, that can be anything, user name, email, uuid, as long as you can uniquely identifies an user in your user base.

We'll check our database for a consent profile associated with that `authId`. If we find one, we'll bring it to the user's device and not show a consent message again (technically this will depend on the scenario setup in our dashboard). If we haven't found any consent profile for that `authId` we'll create one and associate with the current user. 

#### How to use it?

The workflow to use authenticated consent is exactly the same as the one above but instead of calling:
```swift
consentViewController.loadMessage()
```
you should use:
```swift
consentViewController.loadMessage(forAuthId: String?)
```
