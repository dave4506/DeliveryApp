//
//  IAP.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/28/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa
import Firebase

typealias IAPIdentifier = String

internal enum IAPIdentifiers:String {
    case proPack = "test3.proPack"
    case free = "free"
}

enum IAPStatus {
    case unintiated, loading, loaded, error
}

enum Transaction {
    case unintiated, loading, success, error, dismiss
}

class IAPModel:NSObject {
    static let IAPPurchaseNotification = "IAPPurchaseNotification"
    fileprivate var productsRequest:SKProductsRequest?
    fileprivate let iapIdentifiers:Set<IAPIdentifier> = ["test.proPack","proPack","test2.proPack","test3.proPack"]
    fileprivate let purchasedIapIdentifiers = Variable<Set<IAPIdentifier>>(["free"])
    fileprivate let productsVar = Variable<[SKProduct]>([])
    public let iapStatusVar = Variable<IAPStatus>(.unintiated)
    public let transactionStatusVar = Variable<Transaction>(.unintiated)

    let userModel:UserModel
    let disposeBag = DisposeBag()
    
    override init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        userModel = delegate.userModel!
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension IAPModel {
    
    public func requestProducts() {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: iapIdentifiers)
        productsRequest!.delegate = self
        iapStatusVar.value = .loading
        productsRequest!.start()
    }
    
    public func buyProduct(_ identifier: IAPIdentifier) {
        guard let product = productsVar.value.first(where: { $0.productIdentifier == identifier }) else { print("\(identifier) was not found"); transactionStatusVar.value = .error;return;}
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        transactionStatusVar.value = .loading
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ identifier: IAPIdentifier) -> Bool {
        return purchasedIapIdentifiers.value.contains(identifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        transactionStatusVar.value = .loading
    }
}

extension IAPModel: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        iapStatusVar.value = .loaded
        productsVar.value = response.products
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        iapStatusVar.value = .error
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPModel: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        transactionStatusVar.value = .dismiss
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
            }
        }
        transactionStatusVar.value = .error
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        print("identifier \(identifier)")
        guard let identifier = identifier else { return }
        purchasedIapIdentifiers.value.insert(identifier)
        transactionStatusVar.value = .success
        updatePurchasesWith(productIdentifier: identifier)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPModel.IAPPurchaseNotification), object: identifier)
    }
    
    private func updatePurchasesWith(productIdentifier:String) {
        let settings = userModel.userSettingsVar.value
        guard let uid = userModel.getCurrentUser()?.uid else { return }
        Database.database().reference(withPath: "/user_settings/\(uid)/purchases").childByAutoId().setValue(productIdentifier)
    }
}

