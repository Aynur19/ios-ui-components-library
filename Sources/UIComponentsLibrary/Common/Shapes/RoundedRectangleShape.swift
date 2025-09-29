//
//  RoundedRectangleShape.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI

public struct RoundedRectangleShape: Shape {
    let topLeft: CGFloat?
    let topRight: CGFloat?
    let bottomLeft: CGFloat?
    let bottomRight: CGFloat?
    
    public init(cornerRadius: CGFloat? = nil) {
        self.topLeft = cornerRadius
        self.topRight = cornerRadius
        self.bottomLeft = cornerRadius
        self.bottomRight = cornerRadius
    }
    
    public init(
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

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height

        // Начинаем с левого верхнего угла
        let topLeftRadius = min(max(0, topLeft ?? 0), min(width, height) / 2)
        let topRightRadius = min(max(0, topRight ?? 0), min(width, height) / 2)
        let bottomLeftRadius = min(max(0, bottomLeft ?? 0), min(width, height) / 2)
        let bottomRightRadius = min(max(0, bottomRight ?? 0), min(width, height) / 2)

        // старт сверху-слева
        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))

        // верхняя сторона
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        pathTopRight(path: &path, rect: rect, radius: topRightRadius)

        // правая сторона
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        pathBottomRight(path: &path, rect: rect, radius: bottomRightRadius)

        // нижняя сторона
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        pathBottomLeft(path: &path, rect: rect, radius: bottomLeftRadius)

        // левая сторона
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        pathTopLeft(path: &path, rect: rect, radius: topLeftRadius)

        path.closeSubpath()
        
        return path
    }
    
    private func pathTopRight(path: inout Path, rect: CGRect, radius: CGFloat) {
        if radius > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(radians: -CGFloat.pi / 2),
                endAngle: Angle(radians: 0),
                clockwise: false
            )
        }
    }
    
    private func pathBottomRight(path: inout Path, rect: CGRect, radius: CGFloat) {
        if radius > 0 {
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(radians: 0),
                endAngle: Angle(radians: CGFloat.pi / 2),
                clockwise: false
            )
        }
    }
    
    private func pathBottomLeft(path: inout Path, rect: CGRect, radius: CGFloat) {
        if radius > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(radians: CGFloat.pi / 2),
                endAngle: Angle(radians: CGFloat.pi),
                clockwise: false
            )
        }
    }
    
    private func pathTopLeft(path: inout Path, rect: CGRect, radius: CGFloat) {
        if radius > 0 {
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(radians: CGFloat.pi),
                endAngle: Angle(radians: -CGFloat.pi / 2),
                clockwise: false
            )
        }
    }
}
