//
//  HorizontalMoviesView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import SwiftUI

struct HorizontalMoviesView: View {
    
    let title: String
    @Binding var images: [Title]
    
    private let spacing: CGFloat = 10
    private let itemSize: CGSize = .init(width: 140, height: 200)
    var action: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 20).bold())
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(images, id: \.id) { title in
                        Button(action: {
                            action(title.original_title ?? title.original_name ?? "")
                            
                        }, label: {
                            AsyncImage(url: .init(string: .movieDBImagePath(imagePath: title.poster_path ?? ""))) { phase in
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
                    }
                }
                .padding(spacing)
            }
        }
    }
}
