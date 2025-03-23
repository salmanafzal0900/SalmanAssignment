//
//  ContentView.swift
//  InstaAssignment
//
//  Created by Salman Afzal on 22/03/2025.
//

import Foundation
import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Set cache limits
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeImage(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellable: AnyCancellable?
    private let url: URL
    private let cacheKey: String
    
    init(url: URL) {
        self.url = url
        self.cacheKey = url.absoluteString
        
        // Check if image is in cache
        if let cachedImage = ImageCache.shared.getImage(for: cacheKey) {
            self.image = cachedImage
            return
        }
        
        self.loadImage()
    }
    
    private func loadImage() {
        isLoading = true
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.error = error
                    return
                }
                
                guard let data = data, let loadedImage = UIImage(data: data) else {
                    self.error = NSError(domain: "ImageLoaderError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not load image from data"])
                    return
                }
                
                self.image = loadedImage
                ImageCache.shared.setImage(loadedImage, for: self.cacheKey)
            }
        }
        
        task.resume()
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let content: (UIImage) -> Content
    private let placeholder: () -> Placeholder
    
    init(url: URL, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self._loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                content(image)
            } else if loader.error != nil {
                // Default error view
                ZStack {
                    Color.black
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Failed to load image")
                            .foregroundColor(.white)
                            .padding(.top, 4)
                    }
                }
            } else {
                placeholder()
            }
        }
    }
} 
