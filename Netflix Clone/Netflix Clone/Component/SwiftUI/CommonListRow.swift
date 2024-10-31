//
//  CommonListRow.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import SwiftUI

struct CommonListRow: View {
    let title: Movie
    let showPlayIcon: Bool
    let action: (Movie) -> Void
    
    let imageSize: CGSize = .init(width: 100, height: 140)
    let iconSize: CGFloat = 30
    
    init(
        title: Movie,
        showPlayIcon: Bool = true,
        action: @escaping (Movie) -> Void
    ) {
        self.title = title
        self.showPlayIcon = showPlayIcon
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(url: .movieDBImagePath(imagePath: title.poster_path ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                default:
                    ProgressView()
                }
            }.frame(width: imageSize.width, height: imageSize.height)
            
            Text(title.original_title ?? title.original_name ?? "")
                .font(.system(size: 18))
                .padding(.leading, 10)
            
            Spacer()
            
            Image(systemName: "play.circle")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .padding(.trailing, 20)
                .opacity(showPlayIcon ? 1 : 0)
        }
        .contentShape(.rect)
        .onTapGesture {
            action(title)
        }
    }
}

#Preview {
    let title: Movie = .init(id: 0, media_type: nil, original_language: nil, original_title: "Andy Lin", original_name: nil, poster_path: "https://contentcenter-drcn.dbankcdn.cn/img/pub_1/Browser_contentImg_1471_8/76/v3/10514714f6b83e5ea34ed7ee287de5878091c48/758a50a5287f4438adc04b4b14a7d8c3_5_0/hd.webp", overview: nil, vote_count: 0, release_date: nil, vote_average: 0)
    return CommonListRow(title: title) { title in }
}
