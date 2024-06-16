//
//  ErrorDialogContainer.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/16.
//

import SwiftUI

struct ErrorDialogContainer<Modal: View>: ViewModifier {
    
    @Binding var isShowing: Bool
    @ViewBuilder var dialog: () -> Modal
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
                .zIndex(1)
            if isShowing {
                Color.black.ignoresSafeArea()
                    .zIndex(2)
                    .opacity(0.45).transition(.opacity)
                dialog()
                    .padding(.bottom, 16)
                    .padding(.trailing, 16)
                    .zIndex(3)
                    .transition(.scale(scale: 0.92).combined(with: .opacity))
            }
        }
    }
}

extension View {
    func dialog(isShowing: Binding<Bool>, @ViewBuilder dialog: @escaping () -> some View) -> some View {
        modifier(ErrorDialogContainer(isShowing: isShowing, dialog: dialog))
    }
}

