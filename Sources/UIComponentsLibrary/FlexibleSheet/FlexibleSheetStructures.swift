//
//  FlexibleSheetStructures.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import Foundation

public enum SheetAnchor {
    case top
    case bottom
    case leading
    case trailing
}

public enum SheetExpandMode {
    case minMax
    case minMidMax
    case dragging
}

public enum SheetExpandState: Hashable {
    case min
    case mid
    case max
    case custom(offset: CGFloat)
}

public struct SheetRoundedCorners {
    public let topLeftRadius: CGFloat?
    public let topRightRadius: CGFloat?
    public let bottomLeftRadius: CGFloat?
    public let bottomRightRadius: CGFloat?
    
    public init(
        topLeftRadius: CGFloat? = nil,
        topRightRadius: CGFloat? = nil,
        bottomLeftRadius: CGFloat? = nil,
        bottomRightRadius: CGFloat? = nil
    ) {
        self.topLeftRadius = topLeftRadius
        self.topRightRadius = topRightRadius
        self.bottomLeftRadius = bottomLeftRadius
        self.bottomRightRadius = bottomRightRadius
    }
    
    public init(radius: CGFloat? = nil) {
        self.topLeftRadius = radius
        self.topRightRadius = radius
        self.bottomLeftRadius = radius
        self.bottomRightRadius = radius
    }
}

extension RoundedRectangleShape {
    public init(corners: SheetRoundedCorners) {
        self.topLeft = corners.topLeftRadius
        self.topRight = corners.topRightRadius
        self.bottomLeft = corners.bottomLeftRadius
        self.bottomRight = corners.bottomRightRadius
    }
}
