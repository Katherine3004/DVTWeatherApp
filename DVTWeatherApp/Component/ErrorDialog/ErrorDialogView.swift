//
//  ErrorDialogView.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/16.
//

import SwiftUI

struct ErrorDialogView: View {
    let title: String
    let description: String
    let retry: () -> ()
    
    init(title: String, description: String, retry: @escaping () -> Void) {
        self.title = title
        self.description = description
        self.retry = retry
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.h5)
                .foregroundStyle(Color.darkCloudy)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(description)
                .font(.body16)
                .foregroundStyle(Color.cloudy)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: { retry() }, label: {
                Text("Retry")
            })
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.16), radius: 24, x: 0, y: 8)
        )
        .padding(.horizontal, 48)
    }
}

#Preview {
    ErrorDialogView(title: "Error Title", description: "Description", retry: {})
}
