//
//  ExpressPaySaleVC.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit
import Fakery
import ExpressPaySDK
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

    
    private lazy var saleAdapter: ExpressPaySaleAdapter = {
        let adapter = ExpressPayAdapterFactory().createSale()
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
        
        
        
        let order = ExpressPaySaleOrder(id: tfOrderId.text ?? "",
                                       amount: Double(tfOrderAmount.text ?? "") ?? 0,
                                       currency: tfOrderCurrencyCode.text ?? "",
                                       description: tfOrderDescription.text ?? "")
        
        
        let payerOptions = ExpressPayPayerOptions(middleName: tfPayerMiddleName.text,
                                                 birthdate: Foundation.Date.formatter.date(from: tfPayerBirthday.text ?? ""),
                                                 address2: tfPayerAddress2.text,
                                                 state: tfPayerState.text)
        
        let payer = ExpressPayPayer(firstName: tfPayerFirstName.text ?? "",
                                   lastName: tfPayerLastName.text ?? "",
                                   address: tfPayerAddress.text ?? "",
                                   country: tfPayerCountryCode.text ?? "",
                                   city: tfPayerCity.text ?? "",
                                   zip: tfPayerZip.text ?? "",
                                   email: tfPayerEmail.text ?? "",
                                   phone: tfPayerPhone.text ?? "",
                                   ip: tfPayerIpAddress.text ?? "",
                                   options: payerOptions)
        
        ExpressApplePay()
            .set(order: order)
            .set(payer: payer)
            .set(applePayMerchantID: EXPRESS_APPLEPAY_MERCHANT_ID)
            .enable(logs: true)
            .on(authentication: { auth in
                debugPrint("onAuthentication: \(String(data: auth.token.paymentData, encoding: .utf8)!)")
            }).on(transactionFailure: { res in
                debugPrint(res)
            }).on(transactionSuccess: { res in
                debugPrint(res)
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
    
}

