//
//  RoundedRectangleShapeModifier.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI

struct RoundedRectangleShapeModifier: ViewModifier {
    private let topLeft: CGFloat?
    private let topRight: CGFloat?
    private let bottomLeft: CGFloat?
    private let bottomRight: CGFloat?
    
    init(
        topLeft: CGFloat? = nil,
        topRight: CGFloat? = nil,
        bottomLeft: CGFloat? = nil,
        bottomRight: CGFloat? = nil
    ) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    func body(content: Content) -> some View {
        content.clipShape(
            RoundedRectangleShape(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight
            )
        )
    }
}

extension View {
    public func roundedRectangleShape(
        topLeft: CGFloat? = nil,
        topRight: CGFloat? = nil,
        bottomLeft: CGFloat? = nil,
        bottomRight: CGFloat? = nil
    ) -> some View {
        self.modifier(
            RoundedRectangleShapeModifier(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight
            )
        )
    }
}
