//
//  EdfaPgTransactionStorage.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import Foundation
import EdfaPgSdk

internal class EdfaPgTransactionStorage {

    private let storageKey = "EdfaPgTransactionStorage"
    private let storage = UserDefaults.standard

    func addTransaction(_ transaction: Transaction) {
        var transactions = getAllTransactions()
        transactions.append(transaction)
        
        if let data = try? JSONEncoder().encode(transactions) {
            storage.setValue(data, forKey: storageKey)
        }
    }

    func getAllTransactions() -> [Transaction] {
        guard let data = storage.value(forKey: storageKey) as? Data else { return [] }
        
        return (try? JSONDecoder().decode([Transaction].self, from: data)) ?? []
    }

    func getRecurringSaleTransactions() -> [Transaction] {
        getAllTransactions().filter { $0.action == .sale && !$0.recurringToken.isEmpty }
    }

    func getCaptureTransactions() -> [Transaction] {
        getAllTransactions().filter { $0.action == .sale && $0.isAuth }
    }

    func getCreditvoidTransactions() -> [Transaction] {
        getAllTransactions().filter { $0.action == .sale || $0.action == .capture || $0.isAuth }
    }

    func clearTransactions() {
        storage.removeObject(forKey: storageKey)
    }
}

// MARK: - Transaction

extension EdfaPgTransactionStorage {
    final class Transaction: CustomStringConvertible, Codable {
        let payerEmail: String
        let cardNumber: String
        
        var id: String = ""
        var action: EdfaPgAction?
        var result: EdfaPgResult?
        var status: EdfaPgStatus?
        
        var recurringToken: String = ""
        var isAuth: Bool = false
        
        var description: String {
            let mirror = Mirror(reflecting: self)
            
            var str = "\(mirror.subjectType)("
            var first = true
            for (label, value) in mirror.children {
                if let label = label {
                    if first {
                        first = false
                    } else {
                        str += ", "
                    }
                    str += label
                    str += ": "
                    str += "\(value)"
                }
            }
            str += ")"
            
            return str
        }
        
        init(payerEmail: String, cardNumber: String) {
            self.payerEmail = payerEmail
            self.cardNumber = cardNumber
        }
        
        func fill(result: EdfaPgResultProtocol) {
            id = result.transactionId
            action = result.action
            self.result = result.result
            status = result.status
        }
    }
}
