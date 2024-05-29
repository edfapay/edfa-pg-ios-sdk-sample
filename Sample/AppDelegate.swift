//
//  AppDelegate.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit
import EdfaPgSdk

/*

 // Edfa Payment Gateway
// -----------------
ClientKey b5abdab4-5c46-11ed-a7be-8e03e789c25f
ClientPass: f922737e44c04144f8abb092f1f31049
PaymentUrl: https://api.expresspay.sa/post
 
*/

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = UIColor.init(named: "primary")


        // https://github.com/yassram/YRPayment
        let edfaPgCredential = EdfaPgCredential(
            clientKey: MERCHANT_KEY,
            clientPass: MERCHANT_PASSWORD,
            paymentUrl: PAYMENT_URL
        )
        
        EdfaPgSdk.config(edfaPgCredential)
        
        return true
    }
}
