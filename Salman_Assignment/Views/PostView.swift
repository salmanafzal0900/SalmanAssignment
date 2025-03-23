//
//  ContentView.swift
//  InstaAssignment
//
//  Created by Salman Afzal on 21/03/2025.
//

import SwiftUI
import Combine
import Foundation

struct PostView: View {
    let post: Post
    @State private var visibleMediaIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // User info header
            HStack {
                Image(systemName: post.userAvatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(post.username)
                    .font(.headline)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // Media content
            TabView(selection: $visibleMediaIndex) {
                ForEach(Array(post.mediaItems.enumerated()), id: \.element.id) { index, mediaItem in
                    Group {
                        if mediaItem.type == .image {
                            if let remoteUrl = mediaItem.remoteUrl {
                                // Use cached remote image
                                CachedAsyncImage(url: remoteUrl) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.black)
                                } placeholder: {
                                    ZStack {
                                        Color.black
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    }
                                }
                            } else if let imageName = mediaItem.localAssetName?.replacingOccurrences(of: ".jpg", with: "") {
                                // Fallback to local asset if remote URL is not available
                                if let uiImage = UIImage(named: imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.black)
                                } else {
                                    Color.black
                                        .overlay(
                                            Text("Failed to load image: \(imageName)")
                                                .foregroundColor(.white)
                                        )
                                }
                            } else {
                                Color.black
                                    .overlay(
                                        Text("Invalid image source")
                                            .foregroundColor(.white)
                                    )
                            }
                        } else {
                            VideoPlayerWithVisibility(mediaItem: mediaItem, isCurrentlyVisible: visibleMediaIndex == index)
                                .frame(height: 400)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 400)
            
            // Post actions and caption
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "heart")
                        .font(.title2)
                    Image(systemName: "message")
                        .font(.title2)
                    Image(systemName: "paperplane")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal)
                
                Text("\(post.likes) likes")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                HStack {
                    Text(post.username)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(post.caption)
                        .font(.subheadline)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.vertical, 8)
    }
}

// Wrapper view that handles visibility updates
struct VideoPlayerWithVisibility: View {
    let mediaItem: MediaItem
    let isCurrentlyVisible: Bool
    
    var body: some View {
        VideoPlayerView(mediaItem: mediaItem)
            .onAppear {
                // Trigger visibility when first appearing
                NotificationCenter.default.post(
                    name: NSNotification.Name("VideoVisibilityChanged"),
                    object: nil,
                    userInfo: ["id": mediaItem.id, "isVisible": isCurrentlyVisible]
                )
            }
            .onChange(of: isCurrentlyVisible) { newValue in
                // Update visibility when it changes
                NotificationCenter.default.post(
                    name: NSNotification.Name("VideoVisibilityChanged"),
                    object: nil,
                    userInfo: ["id": mediaItem.id, "isVisible": newValue]
                )
            }
    }
}
