//
//  DictionaryLookup.swift
//  Singular
//
//  Created by dlr4life on 7/21/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import Foundation

class DictionaryLookup {
    var entries: [String]!
    
    init?(path: String) {
        guard let entries = try? String(contentsOfFile: path).components(separatedBy: "\n") else {
            return nil
        }
        self.entries = entries
    }
    
    func hasWord(_ word: String) -> Bool {
        return entries.contains(word)
    }
}
