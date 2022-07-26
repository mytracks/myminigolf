//
//  LocalizationPostfixOperator.swift
//  myminigolf (iOS)
//
//  Created by Dirk Stichling on 24.07.22.
//

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
