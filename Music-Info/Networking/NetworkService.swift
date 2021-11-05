//
//  Manager.swift
//  Music-Info
//
//  Created by Andrey Alymov on 20.10.2021.
//

import Foundation

protocol NetworkServiceDelegate {
    func updateInfo (_ manager: NetworkService, album: [Result])
    func errorInfo (error: Error)
}

struct NetworkService {
    
    var delegate: NetworkServiceDelegate?
    
    func fetchAlbums () {
        let urlString = "https://itunes.apple.com/search?term=teylor+swift&entity=album"
        performRequest(with: urlString)
    }
    
    func fetchSongs(limit: Int, albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&entity=song&limit=\(limit)"
        performSongRequest(with: urlString)
    }
    
    func performSongRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.errorInfo(error: error!)
                }
                if let safeData = data {
                    if let songs = self.parseJSON(safeData) {
                        delegate?.updateInfo(self, album: songs)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.errorInfo(error: error!)
                }
                if let safeData = data {
                    if let albums = self.parseJSON(safeData) {
                        delegate?.updateInfo(self, album: albums)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [Result]? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(AlbumData.self, from: data)
            let result = decodedData.results
            return result
        } catch {
            print(error)
            return nil
        }
    }   
}
