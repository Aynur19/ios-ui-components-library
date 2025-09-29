//
//  AfterAppearAnimationModifier.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI

struct AfterAppearAnimationModifier<V: Equatable>: ViewModifier {
    @State private var didAppear = false
    
    private let condition: Bool
    private let animation: Animation?
    private let value: V
    
    public init(
        condition: Bool,
        animation: Animation?,
        value: V
    ) {
        self.condition = condition
        self.animation = animation
        self.value = value
    }

    func body(content: Content) -> some View {
        content
            .animation(isAnimated ? animation : nil, value: value)
            .onAppear {
                DispatchQueue.main.async {
                    didAppear = true
                }
            }
    }
    
    private var isAnimated: Bool {
        didAppear && condition
    }
}

extension View {
    /// Применяет анимацию только после того, как вью появилось
    public func animateAfterAppear<V: Equatable>(
        condition: Bool = true,
        animation: Animation? = nil,
        value: V
    ) -> some View {
        modifier(AfterAppearAnimationModifier(
            condition: condition,
            animation: animation,
            value: value
        ))
    }
}
