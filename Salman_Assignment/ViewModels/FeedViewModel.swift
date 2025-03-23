//
//  ContentView.swift
//  InstaAssignment
//
//  Created by Salman Afzal on 21/03/2025.
//

import Foundation
import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // Cache for media items
    private var mediaCache: [String: Any] = [:]
    
    init() {
        print("Loading row lazily")
        loadPosts()
    }
    
    func loadPosts() {
        isLoading = true
        // In a real app, this would be an API call
        // For now, we'll use sample data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.posts = Post.samplePosts
            self.isLoading = false
        }
        
    }
    
    // Cache management
    func cacheMedia(_ media: Any, for key: String) {
        mediaCache[key] = media
    }
    
    func getCachedMedia(for key: String) -> Any? {
        return mediaCache[key]
    }
    
    func clearCache() {
        mediaCache.removeAll()
    }
}
