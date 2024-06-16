//
//  ButtonStyles.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/16.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButton(configuration: configuration)
    }
    
    struct PrimaryButton: View {
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            if #available(iOS 16.0, *) {
                configuration.label
                    .font(.body16SemiBold)
                    .tracking(0.2)
                    .foregroundColor(isEnabled ? .white : .gray2)
                    .padding([.top, .bottom], 12)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill()
                            .foregroundColor(isEnabled ? configuration.isPressed ? .cloudy : .darkCloudy : .disable)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    )
                    .scaleEffect(configuration.isPressed ? 0.98 : 1)
                    .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            } else {
                configuration.label
                    .font(.body16SemiBold)
                    .foregroundColor(isEnabled ? .white : .gray2)
                    .padding([.top, .bottom], 12)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill()
                            .foregroundColor(isEnabled ? configuration.isPressed ? .cloudy : .darkCloudy : .disable)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    )
                    .scaleEffect(configuration.isPressed ? 0.98 : 1)
                    .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            }
        }
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        SecondaryButton(configuration: configuration)
    }
    
    struct SecondaryButton: View {
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            if #available(iOS 16.0, *) {
                configuration.label
                    .font(.body16SemiBold)
                    .tracking(0.2)
                    .foregroundColor(isEnabled ? .gray2 : .gray5)
                    .padding([.top, .bottom], 12)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(isEnabled ? configuration.isPressed ? Color.cloudy : Color.darkCloudy : Color.disable, lineWidth: 2)
                    )
                    .scaleEffect(configuration.isPressed ? 0.98 : 1)
                    .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            } else {
                configuration.label
                    .font(.body16SemiBold)
                    .foregroundColor(isEnabled ? .gray2 : .gray5)
                    .padding([.top, .bottom], 12)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(isEnabled ? configuration.isPressed ? Color.cloudy : Color.darkCloudy : Color.disable, lineWidth: 2)
                    )
                    .scaleEffect(configuration.isPressed ? 0.98 : 1)
                    .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            }
        }
    }
}
