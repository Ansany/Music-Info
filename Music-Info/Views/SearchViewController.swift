//
//  ViewController.swift
//  Music-Info
//
//  Created by Andrey Alymov on 20.10.2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    var albums: [Result] = []
    var albumsForSearch: [Result] = []
    static var albumsForHistory: [Result] = []
    static var searchHistory: [SearchHistoryItem] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var networkService = NetworkService()
    var searching = false
    var textFromSearch: String = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        setupSearchController()
        registerCells()
        networkService.delegate = self
        networkService.fetchAlbums()
        getAllItems()
    }
    
    private func registerCells() {
        albumCollectionView.register(UINib(nibName: AlbumCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
    
    private func setupSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search"
    }
    
//MARK: - CoreData

    func getAllItems() {
        do {
            SearchViewController.searchHistory = try context.fetch(SearchHistoryItem.fetchRequest())
        } catch {
            print("Get Items Error - \(error)")        }
    }

    func createHistoryItem(name: String, collectionId: String) {
        let newItem = SearchHistoryItem(context: context)
        newItem.name = name
        newItem.collectionId = collectionId
        do{
            try context.save()
            getAllItems()
        } catch {
            print("Create Item Error - \(error)")
        }
    }
    
    func removeHistoryItem(item: SearchHistoryItem) {
        context.delete(item)
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
            SearchViewController.albumsForHistory = album
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
        if searching {
            return albumsForSearch.count
        } else {
            return albums.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if searching {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath)
                as! AlbumCollectionViewCell
            
            let jData = albumsForSearch[indexPath.item]
                cell.albumNameLabel.text = jData.collectionName
                cell.artistNameLabel.text = jData.artistName
                cell.numberOfTracksLabel.text = "\(jData.trackCount) song(s)"
                cell.albumImage.load(urlString: "\(jData.artworkUrl100)")
                cell.dateOfRelease.text = jData.releaseDate.substring(toIndex: 10)
                return cell
        } else {
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if textFromSearch != "" {
            let controller = AlbumDetailViewController.instantiate()
            controller.albums = albumsForSearch[indexPath.row]
            createHistoryItem(name: textFromSearch, collectionId: "\(controller.albums.collectionId)")
            textFromSearch = ""
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = AlbumDetailViewController.instantiate()
            controller.albums = albums[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty {
            searching = true
            albumsForSearch.removeAll()
            textFromSearch = searchText
            for item in albums {
                if item.collectionName.lowercased().contains(searchText.lowercased()) {
                    albumsForSearch.append(item)
                }
            }
        } else {
            searching = false
            albumsForSearch.removeAll()
            albumsForSearch = albums
        }
        albumCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        albumsForSearch.removeAll()
        albumCollectionView.reloadData()
    }
}



