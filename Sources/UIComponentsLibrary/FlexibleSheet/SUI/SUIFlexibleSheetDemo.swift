//
//  SUIFlexibleSheetDemo.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 29.09.2025.
//

#if DEBUG
import SwiftUI

struct SUIFlexibleSheetDemo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUIFlexibleSheetDemoHostView()
                .ignoresSafeArea()
        }
    }
}

private struct SUIFlexibleSheetDemoHostView: View {
    @StateObject private var vm = SUIFlexibleSheetViewModelImpl(
        sheetAnchor: SheetAnchor.bottom,
        sheetRoundedCorners: SheetRoundedCorners(
            topLeftRadius: 50,
            topRightRadius: 50
        )
    )
    
    var body: some View {
        ZStack {
            Color.secondary
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Spacer()
            }
            
            SUIFlexibleSheetView(
                viewModel: vm,
                content: { sheetcontent }
            )
            .ignoresSafeArea()
        }
    }
    
    private var sheetcontent: some View {
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
