//
//  UpcomingView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import SwiftUI

struct UpcomingView: View {
    let viewModel: UpcomingViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.titles, id: \.id) { title in
                    CommonListRow(title: title) { title in
                        viewModel.didClickedItem(title)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Coming Soon")
            .onAppear {
                Task {
                    await viewModel.onAppear()
                }
            }
        }
    }
}
