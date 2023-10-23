//
//  TransactionViewController.swift
//  Sample
//
//  Created by ExpressPay(zik) on 11.03.2021.
//

import UIKit

class TransactionViewController: BaseViewController {
    
    @IBOutlet var btnSelectTransaction: ExpressPayButton!
    @IBOutlet var btnLoadAll: ExpressPayButton?
    @IBOutlet var lbSelectedTransaction: UILabel!
    
    private(set) var selectedTransaction: ExpressPayTransactionStorage.Transaction?
    var transactions: [ExpressPayTransactionStorage.Transaction] = [] {
        didSet {
            setTansaction(nil)
            btnSelectTransaction.isEnabled = !transactions.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbSelectedTransaction.font = .systemFont(ofSize: 13)
        lbSelectedTransaction.textColor = .darkText
        
        btnSelectTransaction.addTarget(self, action: #selector(selectTransaction), for: .touchUpInside)
        btnLoadAll?.addTarget(self, action: #selector(loadAllAction), for: .touchUpInside)
        
        lbSelectedTransaction.text = ""
        lbSelectedTransaction.numberOfLines = 0
        
        btnSelectTransaction.isEnabled = !transactions.isEmpty
    }
    
    @objc func loadAllAction() {
        transactions = transactionStorage.getAllTransactions()
    }
    
    @objc func selectTransaction() {
        let chooserVC = ExpressPayChooserVC<ExpressPayTransactionStorage.Transaction>()
        chooserVC.data = transactions
        chooserVC.completion = { [unowned self] in self.setTansaction($0) }
        present(chooserVC, animated: true, completion: nil)
    }
    
    func setTansaction(_ transaction: ExpressPayTransactionStorage.Transaction?) {
        selectedTransaction = transaction
        
        if let transaction = transaction,
           let data = try? JSONEncoder().encode(transaction),
              let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let dictData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            lbSelectedTransaction?.text = String(data: dictData, encoding: .utf8)
        
        } else {
            lbSelectedTransaction.text = ""
        }
    }
}
