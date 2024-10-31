//
//  HorizontalMoviesView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import SwiftUI

struct HorizontalMoviesView: View {
    // MARK: - Properties
    
    let title: String
    @Binding var titles: [Movie]
    var action: (Movie) -> Void
    var longPressAction: ((Movie) async -> Void)
    
    private let spacing: CGFloat = 10
    private let itemSize: CGSize = .init(width: 140, height: 200)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 20).bold())
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(titles, id: \.id) { title in
                        Button(action: {
                            action(title)
                            
                        }, label: {
                            AsyncImage(url: .movieDBImagePath(imagePath: title.poster_path ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                default:
                                    ProgressView()
                                }
                            }
                            .frame(width: itemSize.width, height: itemSize.height)

                        })
                        .contextMenu {
                            Button(action: {
                                Task {
                                    await longPressAction(title)
                                }
                            }) {
                                Label("Download", systemImage: "arrow.down.circle")
                            }
                        }
                    }
                }
                .padding(spacing)
            }
        }
    }
}
