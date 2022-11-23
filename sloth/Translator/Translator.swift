//
//  Translator.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/21.
//

import Foundation

class Translator: ObservableObject {
    
    static let shared = Translator()
    
    @Published var input = "" {
        didSet {
            output = getDefinitationDB(term: input)
        }
    }
    @Published var output = ""
    
    private func getDefinitationDB(term: String) -> String {
        let a = ECDICTHelper.shared.query(s: term)
        return a
    }
}
