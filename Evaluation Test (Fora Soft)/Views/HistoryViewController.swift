//
//  HistoryViewController.swift
//  Evaluation Test (Fora Soft)
//
//  Created by Andrey Alymov on 20.10.2021.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search history"
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = AlbumDetailViewController.instantiate()
//
//        navigationController?.pushViewController(controller, animated: true)
//    }
}
