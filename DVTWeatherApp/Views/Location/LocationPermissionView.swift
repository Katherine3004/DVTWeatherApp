//
//  LocationPermissionView.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/18.
//

import SwiftUI

struct LocationPermissionView: View {
    
    let closePermissionSheet: () -> ()
    
    init(closePermissionSheet: @escaping () -> Void) {
        self.closePermissionSheet = closePermissionSheet
    }
    
    var body: some View {
        viewContent
            .safeAreaInset(edge: .bottom) {
                safeAreaContent
                    .padding([.bottom], 24)
                    .padding([.horizontal], 16)
            }
    }
    
    var viewContent: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "mappin.circle")
                .font(.system(size: 52))
                .padding(.top, 120)
                .padding(.bottom, 24)
            
            Text("Enable your location")
                .font(.h3)
                .foregroundColor(.cloudy)
                .padding(.bottom, 16)
                .multilineTextAlignment(.center)
            
            Text("We will need to access your location to get an accurate weather result")
                .font(.body14)
                .foregroundColor(.cloudy)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
    }
    
    var safeAreaContent: some View {
        VStack(alignment: .center, spacing: 0) {
            Button(action: { closePermissionSheet() }, label: {
                Text("Not right now")
                    .font(.body14SemiBold)
            })
            .buttonStyle(SecondaryButtonStyle())
            
            Button(action: { showAppSettings() }, label: {
                Text("Open settings")
            })
            .buttonStyle(PrimaryButtonStyle())
            .padding(.bottom, 16)
        }
    }
    
    func showAppSettings() {
        if let settings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settings) {
            UIApplication.shared.open(settings)
            closePermissionSheet()
        }
    }
}
