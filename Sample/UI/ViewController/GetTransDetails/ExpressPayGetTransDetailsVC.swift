//
//  ExpressPayGetTransDetailsVC.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit
import ExpressPaySDK

final class ExpressPayGetTransDetailsVC: TransactionViewController {
    
    // MARK: - Private Properties
    
    private lazy var getTransactionDetailsAdapter: ExpressPayGetTransactionDetailsAdapter = {
        let adapter = ExpressPayAdapterFactory().createGetTransactionDetails()
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

extension ExpressPayGetTransDetailsVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllAction()
    }
}

