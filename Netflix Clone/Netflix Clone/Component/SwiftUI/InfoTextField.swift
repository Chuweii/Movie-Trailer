//
//  InfoTextField.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/8/18.
//

import SwiftUI

struct InfoTextField: View {
    let title: String
    @Binding var text: String
    @FocusState var isActive
    @State var ifNeedSecureField: Bool = false
    @State var isPasswordVisible: Bool = false
    
    @ViewBuilder
    var body: some View {
        let textFieldHeight: CGFloat = 55
        let offsetY: CGFloat = 50
        let cornerRadius: CGFloat = 16
        
        ZStack(alignment: .leading) {
            SecureField("", text: $text)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .frame(height: textFieldHeight).focused($isActive)
                .background(.gray.opacity(0.3), in: .rect(cornerRadius: cornerRadius))
                .opacity(isPasswordVisible ? 0 : 1)
                .hidden(!ifNeedSecureField)
            
            TextField("", text: $text)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .frame(height: textFieldHeight).focused($isActive)
                .background(.gray.opacity(0.3), in: .rect(cornerRadius: cornerRadius))
                .opacity(!ifNeedSecureField ? 1 : isPasswordVisible ? 1 : 0)
            
            Text(title)
                .padding(.leading)
                .offset(y: (isActive || !text.isEmpty) ? -offsetY : 0)
                .animation(.spring, value: isActive)
                .onTapGesture {
                    isActive = true
                }
        }
        .overlay(alignment: .trailing) {
            if ifNeedSecureField {
                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                    .padding()
                    .contentShape(.rect)
                    .foregroundStyle(isPasswordVisible ? .primary : .secondary)
                    .onTapGesture {
                        isPasswordVisible.toggle()
                    }
            }
        }
    }
}


#Preview {
    @State var text: String = ""
    return InfoTextField(title: "Email", text: $text)
}
