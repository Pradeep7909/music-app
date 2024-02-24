//
//  Extensions.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//
import Foundation
import SwiftUI

extension String{
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return regexPredicate.evaluate(with: self)
    }
}


