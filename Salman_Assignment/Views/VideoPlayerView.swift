//
//  ContentView.swift
//  InstaAssignment
//
//  Created by Salman Afzal on 21/03/2025.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let mediaItem: MediaItem
    @State private var player: AVPlayer?
    @State private var isVisible = false
    
    // Using a class-based property to store observer
    @State private var observer: NSObjectProtocol?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let player = player {
                    VideoPlayer(player: player)
                        .onAppear {
                            if isVisible {
                                player.play()
                            }
                        }
                        .onDisappear {
                            player.pause()
                        }
                } else {
                    Color.black
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                }
            }
        }
        .onAppear {
            setupPlayer()
            setupNotifications()
        }
        .onDisappear {
            removeNotifications()
            player?.pause()
            player = nil
        }
    }
    
    private func setupPlayer() {
        guard let assetName = mediaItem.localAssetName,
              let url = Bundle.main.url(forResource: assetName.replacingOccurrences(of: ".mp4", with: ""), withExtension: "mp4") else {
            print("Failed to load video: \(mediaItem.localAssetName ?? "unknown")")
            return
        }
        
        print("Loading video from URL: \(url)")
        let player = AVPlayer(url: url)
        self.player = player
        
        if isVisible {
            player.play()
        }
    }
    
    private func setupNotifications() {
        observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("VideoVisibilityChanged"),
            object: nil,
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let id = userInfo["id"] as? UUID,
                  id == mediaItem.id,
                  let isVisible = userInfo["isVisible"] as? Bool else {
                return
            }
            
            self.updateVisibility(isVisible)
        }
    }
    
    private func removeNotifications() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
    
    // This function will be called to update visibility
    func updateVisibility(_ visible: Bool) {
        print("Updating visibility to: \(visible) for video: \(mediaItem.localAssetName ?? "")")
        isVisible = visible
        if visible {
            player?.play()
        } else {
            player?.pause()
        }
    }
}
