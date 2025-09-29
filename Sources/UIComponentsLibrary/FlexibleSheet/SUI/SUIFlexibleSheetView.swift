//
//  SUIFlexibleSheetView.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

import SwiftUI

public struct SUIFlexibleSheetView<Content: View, ViewModel: SUIFlexibleSheetViewModel>: View {
    @State private var offset: CGFloat = 0
    @State private var baseOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var sheetSizeIsCalculated: Bool = false
    
    @ObservedObject private var viewModel: ViewModel
    private let content: () -> Content
    
    public init(
        viewModel: ViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: viewModel.viewAlignment) {
            overlappedLayerView
                .zIndex(0)
            
            contentView
                .zIndex(1)
        }
    }
    
    private var overlappedLayerView: some View {
        Color.clear
            .ignoresSafeArea()
            .readSize {
                if viewModel.containerSize == .zero {
                    viewModel.setup(containerSize: $0)
                }
            }
            .zIndex(0)
    }
    
    private var contentView: some View {
        ZStack {
            content()
                .safeFrame(
                    size: viewModel.containerSize,
                    alignment: viewModel.viewAlignment
                )
                .clipShape(sheetShape)
                .contentShape(sheetShape)
                .offset(currentOffset)
                .animateAfterAppear(
                    condition: !isDragging,
                    animation: viewModel.sheetExpandAnimation,
                    value: offset
                )
                .onReceive(viewModel.sheetExpandStatePublisher) { state in
                    guard !isDragging else { return }
                    didUpdateSheetExapndState(state)
                }
                .if(viewModel.useSwipes) { view in
                    view.gesture(dragGesture())
                }
                .onTapGesture {
                    viewModel.onSheetViewTapped()
                }
                
        }
    }
    
    private var isVertical: Bool {
        viewModel.sheetAnchor == .top || viewModel.sheetAnchor == .bottom
    }
    
    private var currentOffset: CGPoint {
        if isVertical {
            CGPoint(x: 0, y: viewModel.clampedOffset(offset))
        } else {
            CGPoint(x: viewModel.clampedOffset(offset), y: 0)
        }
    }
        
    private var sheetShape: some Shape {
        RoundedRectangleShape(corners: viewModel.sheetRoundedCorners)
    }
    
    private func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                }
                
                let translation = isVertical ? value.translation.height : value.translation.width
                offset = baseOffset + translation
            }
            .onEnded {
                isDragging = false
                onEndedDragGesture(value: $0)
            }
    }
    
    private func didUpdateSheetExapndState(_ state: SheetExpandState) {
        offset = viewModel.getSheetOffset(expandState: state)
        baseOffset = offset
    }
    
    private func onEndedDragGesture(value: DragGesture.Value) {
        let predictedOffset = offset + value.predictedEndTranslation.height
        
        viewModel.updateExpandState(predictedOffset: predictedOffset)
    }
}
