//
//  File.swift
//  ADExtensionKit
//
//  Created by xu on 2022/4/6.
//

import Foundation

extension Character: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == Character {
    
    var isSimpleEmoji: Bool {
        guard let firstProperties = base.unicodeScalars.first?.properties else {
            return false
        }
        if #available(iOS 10.2, *) {
            return base.unicodeScalars.count == 1 && (firstProperties.isEmojiPresentation || firstProperties.generalCategory == .otherSymbol)
        } else {
            return base.unicodeScalars.count == 1 && firstProperties.generalCategory == .otherSymbol
        }
    }

    var isCombineEmoji: Bool{
        return base.unicodeScalars.count > 1 && base.unicodeScalars.contains{$0.properties.isJoinControl || $0.properties.isVariationSelector}
    }
    
    var isEmoji: Bool {
        return isSimpleEmoji || isCombineEmoji
    }
    
}
