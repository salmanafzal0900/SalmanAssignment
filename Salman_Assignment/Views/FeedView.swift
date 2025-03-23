//
//  ContentView.swift
//  InstaAssignment
//
//  Created by Salman Afzal on 21/03/2025.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.posts) { post in
                        PostView(post: post)
                    }
                }
            }
            .navigationTitle("Instagram Feed")
            .refreshable {
                viewModel.loadPosts()
            }
        }
    }
}
