//
//  SUIFlexibleSheetViewModel.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI
import Combine
import SwiftExtensionsLibrary

public protocol SUIFlexibleSheetViewModel: ObservableObject, AnyObject {
    var containerSize: CGSize { get }
        
    var sheetAnchor: SheetAnchor { get }
    var sheetExpandMode: SheetExpandMode { get }
    var sheetRoundedCorners: SheetRoundedCorners { get }
    var sheetExpandAnimation: Animation { get }
    var sheetMinOffset: CGFloat { get }
    var sheetOffsets: [SheetExpandState: CGFloat] { get }
    
    var useSwipes: Bool { get }
        
    var offsetForMax: CGFloat { get }
    var offsetForMin: CGFloat { get }
    var offsetForMid: CGFloat { get }
        
    var minOffset: CGFloat { get }
    var maxOffset: CGFloat { get }
    
    var viewAlignment: Alignment { get }
    
    var sheetExpandStatePublisher: AnyPublisher<SheetExpandState, Never> { get }
        
    @MainActor
    func setup(containerSize: CGSize)

    @MainActor
    func update(sheetExpandState: SheetExpandState)
        
    @MainActor
    func onSheetViewTapped()
        
    @MainActor
    func onOverlappedViewTapped()
    
    @MainActor
    func updateExpandState(predictedOffset: CGFloat)
    
    @MainActor
    func updateMinOffsetIfNeeded(freeSpace: CGFloat)
    
    @MainActor
    func updateSheetMinOffset(newValue: CGFloat)

    func getSheetOffset(expandState: SheetExpandState) -> CGFloat
        
    func clampedOffset(_ offset: CGFloat) -> CGFloat
}

extension SUIFlexibleSheetViewModel {
    @MainActor
    public func updateMinOffsetIfNeeded(freeSpace: CGFloat) {
        guard freeSpace > sheetMinOffset else { return }
    
        updateSheetMinOffset(newValue: freeSpace)
    }
}

public final class SUIFlexibleSheetViewModelImpl: SUIFlexibleSheetViewModel {
    @Published public private(set) var containerSize: CGSize = .zero
    @Published private var sheetExpandState: SheetExpandState
    
    public let sheetAnchor: SheetAnchor
    public let sheetExpandMode: SheetExpandMode
    public let sheetExpandAnimation: Animation
    public let sheetRoundedCorners: SheetRoundedCorners
    public let sheetMinOffset: CGFloat
    public let useSwipes: Bool
    
    public private(set) var offsetForMax: CGFloat = .zero
    public private(set) var offsetForMin: CGFloat = .zero
    public private(set) var offsetForMid: CGFloat = .zero
    
    public private(set) var minOffset: CGFloat = .zero
    public private(set) var maxOffset: CGFloat = .zero
    
    public private(set) var sheetOffsets: [SheetExpandState: CGFloat] = [:]
    
    public init(
        sheetAnchor: SheetAnchor,
        sheetExpandMode: SheetExpandMode = SheetExpandMode.minMax,
        sheetExpandState: SheetExpandState = SheetExpandState.min,
        sheetRoundedCorners: SheetRoundedCorners,
        sheetExpandAnimation: Animation = Animation.spring(response: 1, dampingFraction: 1),
        sheetMinOffset: CGFloat = 100,
        useSwipes: Bool = true
    ) {
        self.sheetAnchor = sheetAnchor
        self.sheetExpandMode = sheetExpandMode
        self.sheetExpandState = sheetExpandState
        self.sheetRoundedCorners = sheetRoundedCorners
        self.sheetExpandAnimation = sheetExpandAnimation
        self.sheetMinOffset = sheetMinOffset
        self.useSwipes = useSwipes
    }
    
    public var viewAlignment: Alignment {
        switch sheetAnchor {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        }
    }
    
    public var sheetExpandStatePublisher: AnyPublisher<SheetExpandState, Never> {
        $sheetExpandState.eraseToAnyPublisher()
    }
    
    public func setup(containerSize: CGSize) {
        setup(anchor: sheetAnchor, containerSize: containerSize)
        sheetExpandState = SheetExpandState.min
    }
    
    private func setup(anchor: SheetAnchor, containerSize: CGSize) {
        self.containerSize = containerSize
        
        switch anchor {
        case .top:
            self.offsetForMin = -containerSize.height + sheetMinOffset
            self.offsetForMax = 0
            self.offsetForMid = offsetForMin / 2
            
            self.minOffset = offsetForMin
            self.maxOffset = offsetForMax
            
        case .bottom:
            self.offsetForMin = containerSize.height - sheetMinOffset
            self.offsetForMid = offsetForMin / 2
            self.offsetForMax = 0
            
            self.minOffset = offsetForMax
            self.maxOffset = offsetForMin
        
        case .leading:
            self.offsetForMin = -containerSize.width + sheetMinOffset
            self.offsetForMid = offsetForMin / 2
            self.offsetForMax = 0
            
            self.minOffset = offsetForMin
            self.maxOffset = offsetForMax
        
        case .trailing:
            self.offsetForMin = containerSize.width - sheetMinOffset
            self.offsetForMid = offsetForMin / 2
            self.offsetForMax = 0
            
            self.minOffset = offsetForMax
            self.maxOffset = offsetForMin
        }
        
        self.sheetOffsets[SheetExpandState.max] = offsetForMax
        self.sheetOffsets[SheetExpandState.min] = offsetForMin
        
        if case .minMidMax = sheetExpandMode {
            self.sheetOffsets[SheetExpandState.mid] = offsetForMid
        }
    }

    public func update(sheetExpandState: SheetExpandState) {
        self.sheetExpandState = sheetExpandState
    }
    
    public func onSheetViewTapped() {
        update(sheetExpandState: SheetExpandState.max)
    }
    
    public func onOverlappedViewTapped() {
        update(sheetExpandState: SheetExpandState.min)
    }
    
    public func updateExpandState(predictedOffset: CGFloat) {
        switch sheetExpandMode {
        case .minMax:
            sheetExpandState = sheetOffsets.closestEntry(to: predictedOffset)?.0 ?? sheetExpandState
        
        case .minMidMax:
            sheetExpandState = sheetOffsets.closestEntry(to: predictedOffset)?.0 ?? sheetExpandState
        
        case .dragging:
            sheetExpandState = SheetExpandState.custom(offset: predictedOffset)
        }
    }
    
    public func updateSheetMinOffset(newValue: CGFloat) {
        sheetOffsets[.min] = newValue
        offsetForMin = newValue
    }

    public func getSheetOffset(expandState: SheetExpandState) -> CGFloat {
        switch expandState {
        case .min: offsetForMin
        case .mid: offsetForMid
        case .max: offsetForMax
        case let .custom(offset):
            offset
        }
    }
    
    public func clampedOffset(_ offset: CGFloat) -> CGFloat {
        min(maxOffset, max(minOffset, offset))
    }
}
