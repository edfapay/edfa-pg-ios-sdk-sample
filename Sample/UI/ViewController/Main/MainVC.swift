//
//  MainVC.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit
import EdfaPgSdk

final class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnPayWithCard(_ sender: Any) {
        // Show your app loading
        EdfaPgPublicIP { ip, error in
            // Hide your app loading
            if let ip_ = ip{
                self.doSDKUITransaction(ip: ip_)
            }else{
                debugPrint("Error while getting your network public ip.\n --> Exception:(\(error.debugDescription))")
            }
        }
    }
    
    @IBAction func btnPayWithCustomUICard(_ sender: Any) {
        EdfaPgPublicIP { ip, error in
            // Hide your app loading
            if let ip_ = ip{
                self.doCustomUITransaction(ip: ip_)
            }else{
                debugPrint("Error while getting your network public ip.\n --> Exception:(\(error.debugDescription))")
            }
        }
    }
    
    func edfaPgCard()->EdfaPgCard{
        return EdfaPgCard(
            number: "5294151606897978",
            expireMonth: Int(10),
            expireYear: Int(2029),
            cvv: "444"
        )
    }
    
    
    func order()->EdfaPgSaleOrder{
        return EdfaPgSaleOrder(
            id: UUID().uuidString,
            amount:1.00,
            currency: "SAR",
            description: "Test Order"
        )
    }
    
    func payer(ip:String)->EdfaPgPayer{
        return EdfaPgPayer(
            firstName: "haseeb", lastName: "buriro", address: "riyadh",
            country: "SA", city: "Riyadh", zip: "123221",
            email: "a2zzuhaib@gmail.com", phone: "737373737", ip: ip
        )
    }
    
    
    func doSDKUITransaction(ip:String){
        
        let payer = payer(ip:ip)
        let order = order()
        // The precise way to present by sdk it self
        var cardDetailVC:UIViewController?
        cardDetailVC = EdfaCardPay()
            .set(order: order)
            .set(payer: payer)
            .setDesignType(designType: EdfaCardPay.EdfaPayPaymentDesignType.designType_THREE)
            .setLanguage(languageCode: EdfaCardPay.EdfaPayLanguage.language_ar)
            .on(transactionFailure: { result, err in
                debugPrint(result ?? "No Result")
                debugPrint(err ?? "No Error Summary")
                cardDetailVC?.dismiss(animated: true)
                self.show(message: "Failure")
            })
            .on(transactionSuccess: { res, data in
                debugPrint(res ?? "Missing Result")
                debugPrint(data ?? "Missing Data")
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
        
        
        // The way to present by your style or own
//        present(
//            EdfaCardPay.viewController(
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
        
    }
    
    func doCustomUITransaction(ip:String){
        // Usage Example:if you want call sdk with your custom UI
        let edfaPgCard = edfaPgCard();
        let order = order()
        let payer = payer(ip:ip)

      EdfaPayWithCardDetails(viewController: self)
            .setCard(edfaPgCard)
            .setPayer(payer)
            .setOrder(order)
            .onTransactionSuccess { response, result in
                print("Transaction Success: \(result)")
                self.show(message: "Success")
            }
            .onTransactionFailure { response, error in
                print("Transaction Failed: \(error)")
                self.show(message: "Failure")
            }
            .initialize(onError:  { err in
                debugPrint(err)
            })
        
        
    }
    
    func show(message:String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                      
        present(alert, animated: true)
    }
}

