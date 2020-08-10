//
//  Data+utf8.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 10/08/2020.
//

import Foundation

// Assignment 5.
extension Data {
    var utf8: String? { String(data: self, encoding: .utf8)}
}
