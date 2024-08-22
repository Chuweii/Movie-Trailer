//
//  SignButton.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/8/18.
//

import SwiftUI

struct SignButton: View {
    let title: String
    let action: () -> Void
    
    @ViewBuilder
    var body: some View {
        let height: CGFloat = 55
        let cornerRadius: CGFloat = 16
        
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(.black)
                .font(.title2).bold()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(.primary, in: .rect(cornerRadius: cornerRadius))
        }
        .tint(.primary)
    }
}

#Preview {
    SignButton(title: "Sign in", action: { })
}
