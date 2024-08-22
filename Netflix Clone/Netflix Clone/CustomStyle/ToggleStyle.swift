//
//  ToggleStyle.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/8/18.
//

import SwiftUI

struct RememberToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                
                Text("Remember")
            }
        }
        .tint(.primary)
    }
}
