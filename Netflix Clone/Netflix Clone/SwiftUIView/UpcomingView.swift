//
//  UpcomingView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import SwiftUI

struct UpcomingView: View {
    let viewModel: UpcomingViewModel
    
    let imageSize: CGSize = .init(width: 100, height: 140)
    let iconSize: CGFloat = 30
    
    var body: some View {
        List {
            ForEach(viewModel.titles, id: \.id) { title in
                CommonListRow(title: title) { title in
                    viewModel.didClickedItem(title)
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
    }
}
