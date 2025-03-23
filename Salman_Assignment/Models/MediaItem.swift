//
//  ContentView.swift
//  InstaAssignment
//
//  Created by Salman Afzal on 21/03/2025.
//

import Foundation
import SwiftUI

enum MediaType {
    case image
    case video
}

struct MediaItem: Identifiable {
    let id = UUID()
    let type: MediaType
    let url: String
    let thumbnailUrl: String?
    
    // For local assets
    var localAssetName: String?
    
    // For remote assets
    var remoteUrl: URL? {
        return URL(string: url)
    }
}
