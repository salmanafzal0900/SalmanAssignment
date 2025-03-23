//
//  ContentView.swift
//  InstaAssignment
//
//  Created by Salman Afzal on 21/03/2025.
//

import Foundation

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let userAvatar: String
    let mediaItems: [MediaItem]
    let caption: String
    let likes: Int
    let timestamp: Date
    
    // For demo purposes, we'll create some sample posts
    static let samplePosts: [Post] = [
        Post(
            username: "Salman Afzal",
            userAvatar: "person.circle.fill",
            mediaItems: [
                MediaItem(type: .image, url: "https://picsum.photos/200/300", thumbnailUrl: nil, localAssetName: "sample_image_1")
            ],
            caption: "Beautiful sunset of Dubai...",
            likes: 786,
            timestamp: Date()
        ),
        Post(
            username: "Ali Abdullah",
            userAvatar: "person.circle.fill",
            mediaItems: [
                MediaItem(type: .image, url: "https://picsum.photos/200/300", thumbnailUrl: nil, localAssetName: "sample_image_1")
            ],
            caption: "Sun, sand, and good vibes with @Zubair 🌊☀️",
            likes: 1234,
            timestamp: Date()
        ),
        Post(
            username: "Khalid",
            userAvatar: "person.circle.fill",
            mediaItems: [
                MediaItem(type: .image, url: "https://picsum.photos/200/300", thumbnailUrl: nil, localAssetName: "sample_image_1")
            ],
            caption: "Living the high life with a view of the Burj Khalifa 🏙️✨",
            likes: 1234,
            timestamp: Date()
        ),
        Post(
            username: "Danial",
            userAvatar: "person.circle.fill",
            mediaItems: [
                MediaItem(type: .video, url: "sample_video_1", thumbnailUrl: "sample_video_1_thumb", localAssetName: "sample_video_1")
            ],
            caption: "Exploring new places ✈️",
            likes: 567,
            timestamp: Date().addingTimeInterval(-3600)
        ),
        Post(
            username: "Ali",
            userAvatar: "person.circle.fill",
            mediaItems: [
                MediaItem(type: .image, url: "https://picsum.photos/200/300", thumbnailUrl: nil, localAssetName: "sample_image_2"),
                MediaItem(type: .video, url: "sample_video_2", thumbnailUrl: "sample_video_2_thumb", localAssetName: "sample_video_2")
            ],
            caption: "Delicious food and great vibes 🍜",
            likes: 890,
            timestamp: Date().addingTimeInterval(-7200)
        ),
        Post(
            username: "Ahmed",
            userAvatar: "person.circle.fill",
            mediaItems: [
                MediaItem(type: .image, url: "https://picsum.photos/200/300", thumbnailUrl: nil, localAssetName: "sample_image_1")
            ],
            caption: "Beautiful sunset",
            likes: 1234,
            timestamp: Date()
        )
    ]
}
