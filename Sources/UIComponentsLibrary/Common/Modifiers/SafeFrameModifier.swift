//
//  SafeFrameModifier.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI

struct SafeFrameModifier: ViewModifier {
    private let size: CGSize
    private let alignment: Alignment?
    
    init(
        size: CGSize,
        alignment: Alignment?
    ) {
        self.size = size
        self.alignment = alignment
    }

    func body(content: Content) -> some View {
        if let alignment {
            content.frame(width: width, height: height, alignment: alignment)
        } else {
            content.frame(width: width, height: height)
        }
    }
    
    private var width: CGFloat? {
        size.width >= 0 ? size.width : nil
    }
    
    private var height: CGFloat? {
        size.height >= 0 ? size.height : nil
    }
}

extension View {
    public func safeFrame(size: CGSize, alignment: Alignment? = nil) -> some View {
        self.modifier(SafeFrameModifier(size: size, alignment: alignment))
    }
}
