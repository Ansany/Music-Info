//
//  AlbumDetailViewController.swift
//  Music-Info
//
//  Created by Andrey Alymov on 20.10.2021.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var numberOfTracks: UILabel!
    @IBOutlet weak var dateOfRelease: UILabel!
        
    @IBOutlet weak var albumDetailTableView: UITableView!
    
    var albums: Result!
    var info: [Result] = []
    var songs: [String] = []
    var networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        networkService.delegate = self
        networkService.fetchSongs(limit: albums.trackCount ,albumName: albumName.text!.removeWhitespace())
        registerCells()
    }
    
    private func setup() {
        
        albumName.text = albums.collectionName
        artistName.text = "Artist name: \(albums.artistName)"
        numberOfTracks.text = "Number of tracks: \(albums.trackCount) song(s)"
        dateOfRelease.text = "Date of release: \( albums.releaseDate.substring(toIndex: 10))"
        albumImage.load(urlString: "\(albums.artworkUrl100)")
        
    }

    private func registerCells() {
        albumDetailTableView.register(UINib(nibName: AlbumDetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AlbumDetailTableViewCell.identifier)
    }
}

//MARK: - NetworkServiceDelegate

extension AlbumDetailViewController: NetworkServiceDelegate {
    func updateInfo(_ manager: NetworkService, album: [Result]) {
        DispatchQueue.main.async {
            self.info = album
            for item in self.info {
                self.songs.append(item.trackName!)
            }
            self.albumDetailTableView.reloadData()
        }
    }
    
    func errorInfo(error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumDetailTableViewCell.identifier, for: indexPath) as! AlbumDetailTableViewCell

        cell.songNameLabel.text = songs[indexPath.row]
        return cell
    }
}
