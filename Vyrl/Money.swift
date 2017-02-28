//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

fileprivate struct Constants {
        static let currencySymbol = "$"
        static let locale: Locale = Locale(identifier: "en_US")
}

fileprivate let moneyWithDecimalDigits: NumberFormatter! = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .currency
    formatter.currencySymbol = Constants.currencySymbol
    formatter.locale = Constants.locale
    return formatter
}()

fileprivate let moneyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.numberStyle = .currency
    formatter.currencySymbol = Constants.currencySymbol
    formatter.locale = Constants.locale
    return formatter
}()

extension NSNumber {
    var asMoney: String {
        return moneyFormatter.string(from: self) ?? "-"
    }
    
    var asMoneyWithDecimals: String {
        return moneyWithDecimalDigits.string(from: self as NSNumber) ?? "-"
    }
}

extension Double {
    var asMoneyWithDecimals: String {
        return (self as NSNumber).asMoneyWithDecimals
    }
}
