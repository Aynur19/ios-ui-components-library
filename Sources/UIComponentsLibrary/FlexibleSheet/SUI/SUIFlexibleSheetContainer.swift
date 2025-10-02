//
//  SUIFlexibleSheetContainer.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 30.09.2025.
//

import SwiftUI

public struct SUIFlexibleSheetContainer<OverlappedView, SheetView, ViewModel>: View
where OverlappedView: View,
      SheetView: View,
      ViewModel: SUIFlexibleSheetViewModel
{
    @ObservedObject private var viewModel: ViewModel
    @Binding private var sheetIsVisible: Bool
    private let overlappedContentView: (() -> OverlappedView)
    private let sheetContentView: (() -> SheetView)
    
    public init(
        viewModel: ViewModel,
        sheetIsVisible: Binding<Bool>,
        @ViewBuilder overlappedContentView: @escaping (() -> OverlappedView),
        @ViewBuilder sheetContentView: @escaping (() -> SheetView)
    ) {
        self.viewModel = viewModel
        self._sheetIsVisible = sheetIsVisible
        self.overlappedContentView = overlappedContentView
        self.sheetContentView = sheetContentView
    }
    
    public var body: some View {
        ZStack {
            overlappedView
                .zIndex(0)
            
            if sheetIsVisible {
                sheetView
                    .zIndex(1)
            }
        }
    }
    
    private var overlappedView: some View {
        GeometryReader { _ in
            VStack {
                overlappedContentView()
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
        }
        .background(Color.white.opacity(0.001))
        .clipShape(Rectangle())
        .onTapGesture {
            viewModel.onOverlappedViewTapped()
        }
    }
    
    @ViewBuilder
    private var overlappedLayerView: some View {
        if viewModel.sheetAnchor.isVertical {
            VStack(spacing: 0) {
                if viewModel.sheetAnchor.isTop {
                    Spacer(minLength: overlappedLayerOffset)
                }
                
                overlappedContentView()
                
                if viewModel.sheetAnchor.isBottom {
                    Spacer(minLength: overlappedLayerOffset)
                }
            }
        } else {
            HStack(spacing: 0) {
                if viewModel.sheetAnchor.isLeading {
                    Spacer(minLength: overlappedLayerOffset)
                }
                
                overlappedContentView()
                
                if viewModel.sheetAnchor.isTralling {
                    Spacer(minLength: overlappedLayerOffset)
                }
            }
        }
    }
    
    private var overlappedLayerOffset: CGFloat {
        sheetIsVisible ? viewModel.sheetMinOffset : 0
    }
    
    private var sheetView: some View {
        SUIFlexibleSheetView(
            viewModel: viewModel,
            content: { sheetContentView() }
        )
        .zIndex(1)
    }
}
