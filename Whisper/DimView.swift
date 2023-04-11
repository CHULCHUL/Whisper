//
//  DimView.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/11.
//

import SwiftUI

struct DimView: View {
    var body: some View {
        Color.secondary
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial.opacity(0.75))
            .transition(.opacity)
    }
}

//struct BlurDimView: View {
//    var body: some View {
//        Color.background.opacity(0.1)
//            .ignoresSafeArea()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(.ultraThinMaterial)
//            .background(TransparentBackground())
//    }
//}

struct DimView_Previews: PreviewProvider {
    static var previews: some View {
        DimView()
    }
}

