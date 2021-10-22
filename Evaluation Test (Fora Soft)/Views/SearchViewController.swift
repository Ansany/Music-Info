//
//  ViewController.swift
//  Evaluation Test (Fora Soft)
//
//  Created by Andrey Alymov on 20.10.2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    var albums: [Result] = []
    var albumsForSearch: [Result] = []
    var networkService = NetworkService()
    static var searchHistory: [SearchHistoryItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        registerCells()
        networkService.delegate = self
        networkService.fetchAlbums()
        getAllItems()
    }
    
    private func registerCells() {
        albumCollectionView.register(UINib(nibName: AlbumCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
    
//MARK: - CoreData

    func getAllItems() {
        do {
            SearchViewController.searchHistory = try context.fetch(SearchHistoryItem.fetchRequest())
        } catch {
            print("Get Items Error - \(error)")        }
    }

    func createItem(name: String) {
        let newItem = SearchHistoryItem(context: context)
        newItem.name = name
        do{
            try context.save()
            getAllItems()
        } catch {
            print("Create Item Error - \(error)")
        }
    }
}

//MARK: - AlbumManagerDelegate

extension SearchViewController: NetworkServiceDelegate {
   
    func updateInfo(_ manager: NetworkService, album: [Result]) {
        DispatchQueue.main.async {
            self.albums = album.sorted { $0.collectionName < $1.collectionName }
            self.albumsForSearch = self.albums
            self.albumCollectionView.reloadData()
        }
    }
    
    func errorInfo(error: Error) {
        print("Data request error - \(LocalizedError.self)")
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath)
            as! AlbumCollectionViewCell
        
            let jData = albums[indexPath.item]
            cell.albumNameLabel.text = jData.collectionName
            cell.artistNameLabel.text = jData.artistName
            cell.numberOfTracksLabel.text = "\(jData.trackCount) song(s)"
            cell.albumImage.load(urlString: "\(jData.artworkUrl100)")
            cell.dateOfRelease.text = jData.releaseDate.substring(toIndex: 10)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = AlbumDetailViewController.instantiate()
        controller.albums = albums[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        albums.removeAll()
        let searchBarText = searchBar.text!
        
        if !searchBarText.isEmpty {
            createItem(name: searchBarText)
        }
        
        for item in albumsForSearch {
            if item.collectionName.lowercased().contains(searchBar.text!.lowercased()) {
                albums.append(item)
            }
        }
        
        if searchBar.text!.isEmpty {
            albums = albumsForSearch
        }
        albumCollectionView.reloadData()
    }
}



