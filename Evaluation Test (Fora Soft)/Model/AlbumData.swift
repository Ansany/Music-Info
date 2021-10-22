//
//  AlbumData.swift
//  Evaluation Test (Fora Soft)
//
//  Created by Andrey Alymov on 20.10.2021.
//

import Foundation

struct AlbumData: Codable {
    
    let results: [Result]
    
}

struct Result: Codable {
    
    let artistName, collectionName: String
    let trackCount: Int
    let releaseDate: String
    let artworkUrl100: String
    let trackName: String?
    
}

struct TrackName {
    
    let songs: [String]
    
}
