//
//  BannerView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import SwiftUI

struct BannerView: View {
    // MARK: - Properties

    @Binding var imageURL: URL?
    let imageHeight: CGFloat = 450
    let playAction: () -> Void
    let downloadAction: (() async -> Void)

    let buttonSize: CGSize = .init(width: 100, height: 30)
    let padding: CGFloat = 30

    var body: some View {
        ZStack {
            Color.black

            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .empty:
                    Image("empty_image", bundle: nil)
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
                    button(title: "Play") {
                        playAction()
                    }

                    button(title: "Download") {
                        Task {
                            await downloadAction()
                        }
                    }
                }.padding(.bottom, padding)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: imageHeight)
    }
}

extension BannerView {
    @ViewBuilder
    func button(title: String, action: @escaping () -> Void) -> some View {
        let cornerRadius: CGFloat = 7

        Button(action: {
            action()

        }, label: {
            Text(title)
                .foregroundStyle(.white)
                .frame(width: buttonSize.width, height: buttonSize.height)
                .background(
                    Rectangle().fill(.white.opacity(0.1)).cornerRadius(cornerRadius)
                )
        })
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    .white,
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    @State var imageURL: URL? = .init(string: "https://media.gq.com.tw/photos/5fa2907c4a1c25519349c58c/16:9/w_2560%2Cc_limit/GettyImages-454008386.jpg")
    return BannerView(imageURL: $imageURL) { } downloadAction: { }
}
