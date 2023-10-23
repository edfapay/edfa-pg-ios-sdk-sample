//
//  ExpressPayCaptureVC.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit
import ExpressPaySDK

final class ExpressPayCaptureVC: TransactionViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tfPartialAmount: UITextField!
    
    // MARK: - Private Properties
    
    private lazy var catpureAdapter: ExpressPayCaptureAdapter = {
        let adapter = ExpressPayAdapterFactory().createCapture()
        adapter.delegate = self
        return adapter
    }()
    
    // MARK: - Actions
    
    @IBAction func loadCaputreAction() {
        transactions = transactionStorage.getCaptureTransactions()
    }
    
    @IBAction func captureAction() {
        executeRequest()
    }
    
    // MARK: - Private Methods
    
    private func executeRequest() {
        guard let selectedTransaction = selectedTransaction else { return }
        
        let amount = Double(tfPartialAmount.text ?? "")
        
        let transaction = ExpressPayTransactionStorage.Transaction(payerEmail: selectedTransaction.payerEmail,
                                                                  cardNumber: selectedTransaction.cardNumber)

        catpureAdapter.execute(transactionId: selectedTransaction.id,
                               payerEmail: selectedTransaction.payerEmail,
                               cardNumber: selectedTransaction.cardNumber,
                               amount: amount) { [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .result(let result):
                transaction.fill(result: result.result)
                self.transactionStorage.addTransaction(transaction)
                
            case .error, .failure: break
            }
        }
    }
}
