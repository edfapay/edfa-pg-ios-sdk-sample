//
//  EdfaPgGetTransDetailsVC.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit
import EdfaPgSdk

final class EdfaPgGetTransDetailsVC: TransactionViewController {
    
    // MARK: - Private Properties
    
    private lazy var getTransactionDetailsAdapter: EdfaPgGetTransactionDetailsAdapter = {
        let adapter = EdfaPgAdapterFactory().createGetTransactionDetails()
        adapter.delegate = self
        return adapter
    }()
    
    // MARK: - Actions
    
    @IBAction func getTransactionDetailsAction() {
        executeRequest()
    }
    
    // MARK: - Private Methods
    
    private func executeRequest() {
        guard let selectedTransaction = selectedTransaction else { return }
        
        getTransactionDetailsAdapter.execute(transactionId: selectedTransaction.id,
                                             payerEmail: selectedTransaction.payerEmail,
                                             cardNumber: selectedTransaction.cardNumber) { (_) in
        }
    }
}

// MARK: - View life cycle

extension EdfaPgGetTransDetailsVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllAction()
    }
}

