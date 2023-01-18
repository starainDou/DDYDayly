//
//  UIColorExtension.swift
//  elevator
//
//  Created by ddy on 2023/1/17.
//

import Foundation

public extension UITextField {
    
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        let existingTintColor = tintColor
        tintColor = .clear
        if let existingText = text, isSecureTextEntry {
            deleteBackward()
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
        
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
        self.tintColor = existingTintColor
    }
}
