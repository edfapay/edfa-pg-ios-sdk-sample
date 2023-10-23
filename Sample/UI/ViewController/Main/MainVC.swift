//
//  MainVC.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit
import ExpressPaySDK

final class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnPayWithCard(_ sender: Any) {
        
        // Show your app loading
        ExpressPayPublicIP { ip, error in
            // Hide your app loading
            if let ip_ = ip{
                self.doTransaction(ip: ip_)
            }else{
                debugPrint("Error while getting your network public ip.\n --> Exception:(\(error.debugDescription ?? ""))")
            }
        }
        
    }
    
    func doTransaction(ip:String){
        
        let payer = ExpressPayPayer(
            firstName: "Zohaib", lastName: "Kambrani", address: "a2zzuhaib@gmail.com",
            country: "SA", city: "Riyadh", zip: "123221",
            email: "a2zzuhaib@gmail.com", phone: "966500409598", ip: ip
        )
        
        let order = ExpressPaySaleOrder(
            id: UUID().uuidString,
            amount: 0.01,
            currency: "SAR",
            description: "Test Order"
        )
    
            
        // The way to present by your style or own
//        present(
//            ExpressCardPay.viewController(
//                target: self,
//                payer: payer,
//                order: order,
//                transactionSuccess: { res, data  in
//                    debugPrint(res)
//
//                }, transactionFailure: { err, data in
//                    debugPrint(err)
//
//                }, onError: { err in
//                    debugPrint(err)
//
//                }, onPresent: {
//                    debugPrint("onPresent :)")
//                }
//            ),
//            animated: true
//        )
                
        
        // The precise way to present by sdk it self
        var cardDetailVC:UIViewController?
        cardDetailVC = ExpressCardPay()
            .set(order: order)
            .set(payer: payer)
            .on(transactionFailure: { result, err in
                debugPrint(result)
                debugPrint(err)
                cardDetailVC?.dismiss(animated: true)
                self.show(message: "Failure")
            })
            .on(transactionSuccess: { res, data in
                debugPrint(res)
                debugPrint(data)
                cardDetailVC?.dismiss(animated: true)
                self.show(message: "Success")

            }).initialize(
                target: self,
                onError: { err in
                    debugPrint(err)

                },
                onPresent: {
                    debugPrint("onPresent :)")
                }
            )
    }
    
    func show(message:String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                      
        present(alert, animated: true)
    }
}

