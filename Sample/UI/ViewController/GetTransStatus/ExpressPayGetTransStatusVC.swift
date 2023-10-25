//
//  EdfaPgGetTransStatusVC.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit
import EdfaPgSdk

final class EdfaPgGetTransStatusVC: TransactionViewController {
    
    // MARK: - Private Properties
    
    private lazy var getTransactionStatusAdapter: EdfaPgGetTransactionStatusAdapter = {
        let adapter = EdfaPgAdapterFactory().createGetTransactionStatus()
        adapter.delegate = self
        return adapter
    }()
    
    // MARK: - Actions
    
    @IBAction func getTransactionStatusAction() {
        executeRequest()
    }
    
    // MARK: - Private Methods
    
    private func executeRequest() {
        guard let selectedTransaction = selectedTransaction else { return }
        
        getTransactionStatusAdapter.execute(transactionId: selectedTransaction.id,
                                            payerEmail: selectedTransaction.payerEmail,
                                            cardNumber: selectedTransaction.cardNumber) { _ in
        }
    }
}

// MARK: - View life cycle

extension EdfaPgGetTransStatusVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllAction()
    }
}
