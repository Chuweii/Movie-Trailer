//
//  SignAccountButton.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/8/19.
//

import SwiftUI

struct SignAccountButton: View {
    let systemName: String
    let buttonSize: CGSize
    let action: () -> Void

    var body: some View {
        Button { action() } label: {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: buttonSize.width, height: buttonSize.height)
                .tint(.primary)
                .background {
                    RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1.5)
                        .frame(width: buttonSize.width * 2, height: buttonSize.height * 2)
                        .foregroundStyle(.gray.opacity(0.3))
                }
        }
    }
}
