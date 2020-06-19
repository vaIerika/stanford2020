//
//  Array+Only.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 10/06/2020.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil 
    }
}
