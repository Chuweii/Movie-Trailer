//
//  UserCredentialView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/8/18.
//

import SwiftUI

struct UserCredentialView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isRemember: Bool = false
    @State var isShowSignUpView: Bool = false
    @Binding var isShowUserCredentialView: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isShowSignUpView {
                SignUpView()
            } else {
                SignInView(email: $email, password: $password, isRemember: $isRemember, isShowSignUpView: $isShowSignUpView) {
                    isShowUserCredentialView = false
                }
            }
        }
    }
}

#Preview {
    UserCredentialView(isShowUserCredentialView: .constant(true))
}
