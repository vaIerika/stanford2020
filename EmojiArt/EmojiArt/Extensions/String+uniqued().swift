//
//  String+uniqued().swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 12/08/2020.
//

import Foundation

extension String {
    func uniqued() -> String {
        var uniqued = ""
        for charecter in self {
            if !uniqued.contains(charecter) {
                uniqued.append(charecter)
            }
        }
        return uniqued
    }
}
