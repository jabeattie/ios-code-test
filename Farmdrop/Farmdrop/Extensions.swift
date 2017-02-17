//
//  StringExtensions.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
    
    func removeWhitespace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UITextView {
    func increaseFontSizeBy(pointSize: CGFloat) {
        let fullRange = NSRange(location: 0, length: text.characters.count)
        let mutableAttributeText = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributeText.enumerateAttribute(NSFontAttributeName, in: fullRange, options: .longestEffectiveRangeNotRequired) { (attribute, range, stop) in
            if let attribute = attribute as? UIFont {
                let newPointSize = attribute.pointSize + pointSize
                let scaledFont = UIFont(descriptor: attribute.fontDescriptor, size: newPointSize)
                mutableAttributeText.addAttribute(NSFontAttributeName, value: scaledFont, range: range)
            }
        }
        attributedText = mutableAttributeText
    }
    
    func changeFontFamilyToSystem() {
        let fullRange = NSRange(location: 0, length: text.characters.count)
        let mutableAttributeText = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributeText.enumerateAttribute(NSFontAttributeName, in: fullRange, options: .longestEffectiveRangeNotRequired) { (attribute, range, stop) in
            if let attribute = attribute as? UIFont {
                let font: UIFont
                if attribute.fontName.contains("Italic") {
                    font = UIFont.italicSystemFont(ofSize: 10)
                } else if attribute.fontName.contains("Bold") {
                    font = UIFont.boldSystemFont(ofSize: 10)
                } else {
                    font = UIFont.systemFont(ofSize: 10)
                }
                let fontDescriptor = UIFontDescriptor(name: font.fontName, size: attribute.pointSize)
                let newFont = UIFont(descriptor: fontDescriptor, size: attribute.pointSize)
                mutableAttributeText.addAttribute(NSFontAttributeName, value: newFont, range: range)
            }
        }
        attributedText = mutableAttributeText
    }
}

extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) -> Bool {
        if let index = index(of: object) {
            remove(at: index)
            return true
        }
        return false
    }
}
