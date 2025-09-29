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
    private let overlappedContentView: (() -> OverlappedView)
    private let sheetContentView: (() -> SheetView)
    
    public init(
        viewModel: ViewModel,
        @ViewBuilder overlappedContentView: @escaping (() -> OverlappedView),
        @ViewBuilder sheetContentView: @escaping (() -> SheetView)
    ) {
        self.viewModel = viewModel
        self.overlappedContentView = overlappedContentView
        self.sheetContentView = sheetContentView
    }
    
    public var body: some View {
        ZStack {
            overlappedView
                .zIndex(0)
            
            sheetView
                .zIndex(1)
        }
    }
    
    private var overlappedView: some View {
        GeometryReader { _ in
            overlappedContentView()
        }
        .background(Color.white.opacity(0.001))
        .clipShape(Rectangle())
        .onTapGesture {
            viewModel.onOverlappedViewTapped()
        }
    }
    
    private var sheetView: some View {
        SUIFlexibleSheetView(
            viewModel: viewModel,
            content: { sheetContentView() }
        )
        .zIndex(1)
    }
}
