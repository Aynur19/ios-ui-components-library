//
//  File.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
