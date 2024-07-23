//
//  BannerView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import SwiftUI

struct BannerView: View {
    // MARK: - Properties
    
    @Binding var imageURL: String
    let imageHeight: CGFloat = 450
    let playAction: () -> Void
    let downloadAction: () -> Void
    
    let buttonSize: CGSize = .init(width: 100, height: 30)
    let padding: CGFloat = 30
    
    var body: some View {
        ZStack {
            Color.black

            AsyncImage(url: .init(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()

                default:
                    ProgressView()
                }
            }

            LinearGradient(
                gradient: Gradient(colors: [.clear, Color(.black)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack {
                Spacer()
                
                HStack(spacing: padding) {
                    Button(action: {
                        playAction()
                        
                    }, label: {
                        Text("Play")
                            .foregroundStyle(.white)
                            .frame(width: buttonSize.width, height: buttonSize.height)
                            .background(
                                Rectangle().fill(.red).opacity(0.7).cornerRadius(7)
                            )
                    })
                    
                    Button(action: {
                        downloadAction()
                        
                    }, label: {
                        Text("Download")
                            .foregroundStyle(.white)
                            .frame(width: buttonSize.width, height: buttonSize.height)
                            .background(
                                Rectangle().fill(.red).opacity(0.7).cornerRadius(7)
                            )
                    })
                }.padding(.bottom, padding)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: imageHeight)
    }
}

#Preview {
    @State var imageURL: String = "https://media.gq.com.tw/photos/5fa2907c4a1c25519349c58c/16:9/w_2560%2Cc_limit/GettyImages-454008386.jpg"
    return BannerView(imageURL: $imageURL) {} downloadAction: {}
}
