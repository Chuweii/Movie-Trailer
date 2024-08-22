//
//  SignInView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/8/18.
//

import SwiftUI

struct SignInView: View {
    @FocusState var isActive
    @Binding var email: String
    @Binding var password: String
    @Binding var isRemember: Bool
    @Binding var isShowSignUpView: Bool
    @State var isShowForgotView: Bool = false
    let action: () -> Void
    
    @ViewBuilder
    var body: some View {
        let spacing: CGFloat = 45
        
        VStack(spacing: spacing) {
            TopView(title: "Welcome back !!", detail: "Please sign in to your account")
            
            InfoTextField(title: "Email", text: $email)
            
            passwordView
            
            SignButton(title: "Sign in") {
                action()
            }
            
            OrView()
            
            signAccountButtons
            
        }
        .padding()
    }
}

// MARK: - Subviews

extension SignInView {
    @ViewBuilder
    var passwordView: some View {
        let spacing: CGFloat = 12
        let horizontalPadding: CGFloat = 10
        
        VStack(spacing: spacing) {
            InfoTextField(title: "Password", text: $password, ifNeedSecureField: true)
            
            HStack(spacing: 0) {
                Toggle(isOn: $isRemember, label: { })
                    .toggleStyle(RememberToggleStyle())
                
                Spacer()
                
                Button {
                    // Forgot password action
                } label: {
                    Text("Forgot password?")
                        .font(.footnote).bold()
                        .tint(.primary)
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
    }
    
    @ViewBuilder
    var signAccountButtons: some View {
        let spacing: CGFloat = 65
        let buttonSize: CGFloat = 25
        
        HStack(spacing: spacing) {
            SignAccountButton(systemName: "apple.logo", buttonSize: .init(width: buttonSize, height: buttonSize)) {
                // action
            }
            
            SignAccountButton(systemName: "envelope", buttonSize: .init(width: buttonSize, height: buttonSize)) {
                // action
            }
            
            SignAccountButton(systemName: "g.circle.fill", buttonSize: .init(width: buttonSize, height: buttonSize)) {
                // action
            }
        }
    }
}

struct TopView: View {
    let title: String
    let detail: String
    
    @ViewBuilder
    var body: some View {
        let spacing: CGFloat = 16
        
        VStack(alignment: .leading, spacing: spacing) {
            Text(title)
                .font(.title.bold())
            
            Text(detail)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct OrView: View {
    var body: some View {
        HStack(spacing: 10) {
            divider
            
            Text("or")
            
            divider
        }
    }
    
    @ViewBuilder
    var divider: some View {
        Rectangle()
            .foregroundStyle(.white)
            .opacity(0.3)
            .frame(height: 1)
    }
}

#Preview {
    UserCredentialView(isShowUserCredentialView: .constant(true))
}
