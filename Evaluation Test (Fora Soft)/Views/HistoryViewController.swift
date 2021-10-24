//
//  HistoryViewController.swift
//  Evaluation Test (Fora Soft)
//
//  Created by Andrey Alymov on 20.10.2021.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    var netWorkService = NetworkService()
    var searchVC = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search history"
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        historyTableView.reloadData()
        registerCells()
    }
    
    private func registerCells() {
        historyTableView.register(UINib(nibName: HistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.identifier)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchViewController.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history = SearchViewController.searchHistory[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        
        cell.historyLabel.text = history.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AlbumDetailViewController.instantiate()
        for item in SearchViewController.albumsForHistory {
            let colId = "\(item.collectionId)"
            if colId == SearchViewController.searchHistory[indexPath.row].collectionId {
                controller.albums = Result(artistName: item.artistName, collectionName: item.collectionName, trackCount: item.trackCount, releaseDate: item.releaseDate, artworkUrl100: item.artworkUrl100, trackName: nil, collectionId: item.collectionId)
            } 
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            historyTableView.beginUpdates()
            if SearchViewController.searchHistory.count == 1 {
                searchVC.removeHistoryItem(item: SearchViewController.searchHistory[indexPath.row])
            } else {
                searchVC.removeHistoryItem(item: SearchViewController.searchHistory[indexPath.row - 1])
            }
            historyTableView.deleteRows(at: [indexPath], with: .fade)
            historyTableView.endUpdates()
        }
    }
}
