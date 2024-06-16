//
//  CircleProgressView.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/16.
//

import SwiftUI

struct CircleProgressView: View {
    
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
//            Circle()
//                .stroke(Color.lightCloudy, lineWidth: 4)
//                .frame(width: 48, height: 48)
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(Color.darkCloudy, lineWidth: 4)
                .frame(width: 48, height: 48)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        self.isAnimating = true
                    }
                }
        }
    }
}
