//
//  EdfaPgCreditvoidVC.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit
import EdfaPgSdk

final class EdfaPgCreditvoidVC: TransactionViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tfPartialAmount: UITextField!
    
    // MARK: - Private Properties
    
    private lazy var creditvoidAdapter: EdfaPgCreditvoidAdapter = {
        let adapter = EdfaPgAdapterFactory().createCreditvoid()
        adapter.delegate = self
        return adapter
    }()
    
    // MARK: - Actions
    
    @IBAction func loadCreditvoidAction() {
        transactions = transactionStorage.getCreditvoidTransactions()
    }
    
    @IBAction func creditvoidAction() {
        executeRequest()
    }
    
    // MARK: - Private Methods
    
    private func executeRequest() {
        guard let selectedTransaction = selectedTransaction else { return }
        
        let amount = Double(tfPartialAmount.text ?? "")
        
        let transaction = EdfaPgTransactionStorage.Transaction(payerEmail: selectedTransaction.payerEmail,
                                                                  cardNumber: selectedTransaction.cardNumber)
        
        creditvoidAdapter.execute(transactionId: selectedTransaction.id,
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
