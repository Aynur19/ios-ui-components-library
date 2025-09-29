//
//  View+ReadSize.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI

extension View {
    public func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear.preference(
                    key: SizePreferenceKey.self,
                    value: geometryProxy.size
                )
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) {
            onChange($0)
        }
    }
}

private struct SizePreferenceKey: PreferenceKey, Sendable {
    static var defaultValue: CGSize {
        CGSize.zero
    }
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
