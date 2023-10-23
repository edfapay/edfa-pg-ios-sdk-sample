//
//  ExpressPaySaleVC.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit
import Fakery
import ExpressPaySDK

final class ExpressPaySaleVC: BaseViewController {
    
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
    
    @IBOutlet private weak var btnSuccessSaleCard: ExpressPayRadioButton!
    @IBOutlet private weak var btnFailueSaleCard: ExpressPayRadioButton!
    @IBOutlet private weak var btnFailureCaptureCard: ExpressPayRadioButton!
    @IBOutlet private weak var btnSuccess3dSecureSaleCard: ExpressPayRadioButton!
    @IBOutlet private weak var btnFailure3dSecureSaleCard: ExpressPayRadioButton!
    
    @IBOutlet private weak var swtInitRecurringSale: UISwitch!
    @IBOutlet private weak var tfChannelId: UITextField!
    
    // MARK: - Private Properties
    
    private lazy var cardsContainer = ExpressPayRadioButtonContainer(btnSuccessSaleCard,
                                                                    btnFailueSaleCard,
                                                                    btnFailureCaptureCard,
                                                                    btnSuccess3dSecureSaleCard,
                                                                    btnFailure3dSecureSaleCard)
    
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
    
    @IBAction func authRequestAction() {
        executeRequest(isAuth: true)
    }
    
    @IBAction func saleRequestAction() {
        executeRequest(isAuth: false)
    }
}

// MARK: - View life cycle

extension ExpressPaySaleVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsContainer.selectButton(at: 0)
    }
}

// MARK: - Private Methods

private extension ExpressPaySaleVC {
    func randomize(isAll: Bool) {
        tfOrderId.text = UUID().uuidString
        tfOrderAmount.text = String(format: "%.2f", Double.random(in: 0...10))
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
        
        cardsContainer.selectButton(at: .random(in: 0..<4))
        lbResponse.text = ""
        
        if (isAll) {
            tfPayerMiddleName.text = faker.name.lastName()
            tfPayerAddress2.text = faker.address.streetName() + faker.address.buildingNumber()
            tfPayerState.text = faker.address.state()
            tfPayerBirthday.text = Faker.birthday()
            
            swtInitRecurringSale.isOn = .random()
//            tfChannelId.text = String(UUID().uuidString.prefix(16))
            
        } else {
            tfPayerMiddleName.text = ""
            tfPayerAddress2.text = ""
            tfPayerState.text = ""
            tfPayerBirthday.text = ""
            
            swtInitRecurringSale.isOn = false
            tfChannelId.text = ""
        }
    }
    
    func executeRequest(isAuth: Bool) {
        guard let selectedCardIndex = cardsContainer.selectedIndex else { return }
        
        let order = ExpressPaySaleOrder(id: tfOrderId.text ?? "",
                                       amount: Double(tfOrderAmount.text ?? "") ?? 0,
                                       currency: tfOrderCurrencyCode.text ?? "",
                                       description: tfOrderDescription.text ?? "")
        
        let card = getCard(at: selectedCardIndex)
        
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
        
        let saleOptions = ExpressPaySaleOptions(channelId: tfChannelId.text,
                                               recurringInit: swtInitRecurringSale.isOn)
        
        let transaction = ExpressPayTransactionStorage.Transaction(payerEmail: payer.email,
                                                                  cardNumber: card.number)
        
        let termUrl3ds = "https://webhook.site/85cedd75-7a4b-42d7-a03f-a48683ea17c4"
        
        saleAdapter.execute(order: order,
                            card: card,
                            payer: payer,
                            termUrl3ds: termUrl3ds,
                            options: saleOptions,
                            auth: isAuth) { [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .result(let result):
                transaction.fill(result: result.result)
                transaction.isAuth = true
                
                switch result {
                case .recurring(let result):
                    transaction.recurringToken = result.recurringToken
                    
                case .secure3d(let result):
                    self.openRedirect3Ds(termUrl: result.redirectParams.termUrl,
                                         termUrl3Ds: "",
                                         redirectUrl: result.redirectUrl,
                                         paymentRequisites: result.redirectParams.paymentRequisites)
                    
                case .redirect(let result):
                    self.redirect(response:result)

                default: break
                    
                }
                
                self.transactionStorage.addTransaction(transaction)
                
            case .error, .failure: break
                print(response)
            }
        }
    }
    
    func redirect(response:ExpressPaySaleRedirect){
        
        SaleRedirectionView()
            .setup(response: response, onTransactionSuccess: { result in
                print("onTransactionSuccess: \(result)")
                
            }, onTransactionFailure: { result in
                print("onTransactionFailure: \(result)")
                
            })
            .enableLogs()
            .show(owner: self, onStartIn: { viewController in
                print("onStart: \(viewController)")
                
            }, onError: { error in
                print("onError: \(error)")
                
            })

        
    }
    
    
    func getCard(at index: Int) -> ExpressPayCard {
        switch index {
        case 1: return ExpressPayTestCard.saleFailure
        case 2: return ExpressPayTestCard.captureFailure
        case 3: return ExpressPayTestCard.secure3dSuccess
        case 4: return ExpressPayTestCard.secure3dFailure
        default: return ExpressPayTestCard.saleSuccess
        }
    }
}
