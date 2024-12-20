//
//  EdfaPgSaleVC.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit
import Fakery
import EdfaPgSdk
import PassKit

final class ApplePayVC: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tfOrderId: UITextField!
    @IBOutlet private weak var tfOrderAmount: UITextField!
    @IBOutlet private weak var tfOrderDescription: UITextField!
    @IBOutlet private weak var tfOrderCurrencyCode: UITextField!
    
    @IBOutlet private weak var tfPayerFirstName: UITextField!
    @IBOutlet private weak var tfPayerLastName: UITextField!
    @IBOutlet private weak var tfPayerAddress: UITextField!
    @IBOutlet private weak var tfPayerCountryCode: UITextField!
    @IBOutlet private weak var tfPayerCity: UITextField!
    @IBOutlet private weak var tfPayerZip: UITextField!
    @IBOutlet private weak var tfPayerEmail: UITextField!
    @IBOutlet private weak var tfPayerPhone: UITextField!
    @IBOutlet private weak var tfPayerIpAddress: UITextField!
    
    @IBOutlet private weak var tfPayerMiddleName: UITextField!
    @IBOutlet private weak var tfPayerAddress2: UITextField!
    @IBOutlet private weak var tfPayerState: UITextField!
    @IBOutlet private weak var tfPayerBirthday: UITextField!

    
    private lazy var saleAdapter: EdfaPgSaleAdapter = {
        let adapter = EdfaPgAdapterFactory().createSale()
        adapter.delegate = self
        return adapter
    }()
    
    // MARK: - Actions
    
    @IBAction func clearTransactionAction() {
        transactionStorage.clearTransactions()
    }
    
    @IBAction func randomizeRequairedAction() {
        randomize(isAll: false)
    }
    
    @IBAction func randomizeAllAction() {
        randomize(isAll: true)
    }
    
    
    @IBAction func payRequestAction() {
        executeRequest()
    }
}

// MARK: - View life cycle

extension ApplePayVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Private Methods

private extension ApplePayVC {
    func randomize(isAll: Bool) {
        tfOrderId.text = UUID().uuidString
        tfOrderAmount.text = String(format: "%.2f", Double.random(in: 1...1.05))
        tfOrderDescription.text = faker.lorem.sentences()
        tfOrderCurrencyCode.text = ["SAR"].randomElement()
        
        tfPayerFirstName.text = faker.name.firstName()
        tfPayerLastName.text = faker.name.lastName()
        tfPayerAddress.text = faker.address.secondaryAddress()
        tfPayerCountryCode.text = faker.address.countryCode()
        tfPayerCity.text = faker.address.city()
        tfPayerZip.text = faker.address.postcode()
        tfPayerEmail.text = faker.internet.email()
        tfPayerPhone.text = faker.phoneNumber.phoneNumber()
        tfPayerIpAddress.text = faker.internet.ipV4Address()
        
        let randomNumber = Int.random(in: 100...150)
        tfPayerIpAddress.text = String(format: "%d.%d.%d.%d", randomNumber, randomNumber, randomNumber, randomNumber)
        
        lbResponse.text = ""
        
        if (isAll) {
            tfPayerMiddleName.text = faker.name.lastName()
            tfPayerAddress2.text = faker.address.streetName() + faker.address.buildingNumber()
            tfPayerState.text = faker.address.state()
            tfPayerBirthday.text = Faker.birthday()
                        
        } else {
            tfPayerMiddleName.text = ""
            tfPayerAddress2.text = ""
            tfPayerState.text = ""
            tfPayerBirthday.text = ""
        }
    }
    
    func executeRequest() {
        pay()
        return
        
        
        let order = EdfaPgSaleOrder(id: tfOrderId.text ?? "",
                                       amount: Double(tfOrderAmount.text ?? "") ?? 0,
                                       currency: tfOrderCurrencyCode.text ?? "",
                                       description: tfOrderDescription.text ?? "")
        
        
        let payerOptions = EdfaPgPayerOptions(middleName: tfPayerMiddleName.text,
                                                 birthdate: Foundation.Date.formatter.date(from: tfPayerBirthday.text ?? ""),
                                                 address2: tfPayerAddress2.text,
                                                 state: tfPayerState.text)
        
        let payer = EdfaPgPayer(firstName: tfPayerFirstName.text ?? "",
                                   lastName: tfPayerLastName.text ?? "",
                                   address: tfPayerAddress.text ?? "",
                                   country: tfPayerCountryCode.text ?? "",
                                   city: tfPayerCity.text ?? "",
                                   zip: tfPayerZip.text ?? "",
                                   email: tfPayerEmail.text ?? "",
                                   phone: tfPayerPhone.text ?? "",
                                   ip: tfPayerIpAddress.text ?? "",
                                   options: payerOptions)
        
        EdfaApplePay()
            .set(order: order)
            .set(payer: payer)
            .set(applePayMerchantID: APPLEPAY_MERCHANT_ID)
            .enable(logs: true)
            .on(authentication: { auth in
                debugPrint("onAuthentication: \(String(data: auth.token.paymentData, encoding: .utf8)!)")
            }).on(transactionFailure: { res in
                debugPrint(res)
            }).on(transactionSuccess: { res in
                debugPrint(res ?? "onSuccess \(res)")
            }).initialize(
                target: self,
                onError: { errors in
                    debugPrint("onError: \(errors)")
                },
                onPresent: {
                    debugPrint("onPresent: (-:")
                }
            )
    }
    
    func pay() {
        let ip = "1.1.1.1"

        let order = EdfaPgSaleOrder(
            id: "8A5A1E6B-3459-4F01-A84C-6287468AF789",
            amount: 1.0,
            currency: "SAR",
            description: "Total"
        )
                    
                  
         let payer = EdfaPgPayer(
            firstName: "Guest",
            lastName: "Guest",
            address: "KSA",
            country: "SA",
            city: "Riyadh",
            zip: "123456",
            email: "info@vastmenu.com",
            phone: "+966544392788",
            ip: ip,
            options: .init(birthdate: Date().addingTimeInterval(-1000000000))

        )

        
        print("birth date \(Date().addingTimeInterval(-1000000000))")
        EdfaApplePay()
            .set(order: order)
            .set(payer: payer)
            .set(applePayMerchantID: APPLEPAY_MERCHANT_ID)
            .set(merchantCapability: .capability3DS)
            .on(authentication: { auth in
                // Handle authentication success
                debugPrint("Authenticated with payment: \(auth)")
            })
            .on(transactionFailure: { res in
                // Handle transaction failure
                debugPrint("Transaction failed with response: \(res)")
            })
            .on(transactionSuccess: { res in
                // Handle transaction success
                guard
                    let status = res?["status"] as? String, status == "SETTLED",
                    (res?["result"] as? String) == "SUCCESS",
                    let transactionId = res?["trans_id"] as? String
                else {
                    return
                }
                debugPrint("Transaction succeeded with response: \(res)")
            })
            .initialize(target: self, onError: { errors in
                debugPrint("Initialization error: \(errors)")
            }, onPresent: {
                debugPrint("Apple Pay sheet presented")
            })
        }
    
}




