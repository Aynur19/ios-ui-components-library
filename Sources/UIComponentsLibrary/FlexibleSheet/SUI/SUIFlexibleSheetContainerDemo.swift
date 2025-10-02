//
//  File.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 30.09.2025.
//

#if DEBUG
import SwiftUI

struct SUIFlexibleSheetContainerDemo_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SUIFlexibleSheetContainerDemoHostView()
            Spacer(minLength: 100)
        }
        .ignoresSafeArea()
    }
}

private struct SUIFlexibleSheetContainerDemoHostView: View {
    @StateObject private var viewModel = SUIFlexibleSheetViewModelImpl(
        sheetAnchor: .bottom,
        sheetExpandMode: .minMidMax,
        sheetExpandState: .min,
        sheetRoundedCorners: SheetRoundedCorners(
            topLeftRadius: 50,
            topRightRadius: 50
        ),
        sheetExpandAnimation: .spring,
        sheetMinOffset: 100,
        useSwipes: true
    )
    
    @State private var color = Color.green
    @State private var sheetIsVisible = true
    
    var body: some View {
        SUIFlexibleSheetContainer(
            viewModel: viewModel,
            sheetIsVisible: $sheetIsVisible,
            overlappedContentView: { overlappedView },
            sheetContentView: { sheetView }
        )
    }
    
    private var overlappedView: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 16) {
            Spacer()
            HStack(spacing: 64) {
                Button(
                    action: {
                        color = Color.blue
                        sheetIsVisible.toggle()
                    },
                    label: { Text("Blue") }
                )
                .buttonStyle(.bordered)
                
                Button(
                    action: {
                        color = Color.red
                        viewModel.update(sheetExpandState: .min)
                    },
                    label: { Text("Red") }
                )
                .buttonStyle(.bordered)
            }
            .padding(20)
            
            color
        }
        .background(Color.blue)
    }
    
    private func getImageContainerSize(geometry: GeometryProxy) -> CGSize {
        CGSize(
            width: geometry.size.width,
            height: geometry.size.height
        )
    }

    
    private var sheetView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Sheet content")
                Spacer()
            }
            Spacer()
        }
        .background(Color.orange)
    }
}
#endif
